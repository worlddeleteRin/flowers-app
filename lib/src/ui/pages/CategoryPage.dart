import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/catalogue_bloc.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartIconBadge.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/PageLoadingCenter.dart';
import 'package:myapp/src/ui/components/products/ProductsList.dart';
import 'package:rxdart/rxdart.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;
  CategoryPage({
    required this.categoryId
  });

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{

  BehaviorSubject _categoryFetcher = BehaviorSubject();
  BehaviorSubject _categoryProductsFetcher = BehaviorSubject();

  Stream get category => _categoryFetcher.stream;
  Stream get categoryProducts => _categoryProductsFetcher.stream;

  bool _categoryInfoFetched = false;
  bool _categoryProductsFetched = false;


  setCategoryFetched (bool isFetched) {
    setState(() => _categoryInfoFetched = isFetched);
  }

  setCategoryProductsFetched (bool isFetched) {
    setState(() => _categoryProductsFetched = isFetched);
  }

  refreshCategoryPage () async {
    setCategoryFetched(false);
    setCategoryProductsFetched(false);
  }

  fetchCategoryInfo () async {
    setCategoryFetched(true);
    Category currentCategory = await catalogueBloc.fetchCategoryById(widget.categoryId);
    _categoryFetcher.sink.add(currentCategory);
  }

  fetchCategoryProducts () async {
    setCategoryProductsFetched(true);
    List<Product> categoryProducts = await catalogueBloc.fetchCategoryProducts(widget.categoryId);
    _categoryProductsFetcher.sink.add(categoryProducts);
  }

  @override
  Widget build(BuildContext context) {
    if (!_categoryInfoFetched) {
      fetchCategoryInfo();
    }
    if (!_categoryProductsFetched) {
      fetchCategoryProducts();
    }
    return StreamBuilder(
      stream: category,
      // future: loadCategoryPageInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is Category)) {
          Category category = snapshot.data;
          return CategoryPageContent(
            context: context,
            category: category,
          );
        }
        return CategoryPageLoading();
      }
    );
  }

  Widget CategoryPageLoading () {
    return SafeArea(
      child: Scaffold(
        body: PageLoadingCenter(),
      ),
    );
  }

  Widget CategoryPageContent({
    required BuildContext context,
    required Category category
  }) {      
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [

            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              pinned: true,
              title: Text('${category.name}'),
              expandedHeight: 220.0,
              foregroundColor: Colors.white,
              actions: [
                CartIconBadge(
                  context: context,
                  iconColor: Colors.white,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    category.imgsrc[0],
                  )
                ),
              ),
            ),

            MainSliverRefreshControl(
              handleOnRefresh: () async => await refreshCategoryPage(),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 15.0),
            ),

            SliverToBoxAdapter(
              child: ProductsFutureBuilder(context: context),
            )

          ]
        ),
      ),
    );
  }

  Widget ProductsFutureBuilder({
    required BuildContext context
  }) {

    return StreamBuilder(
      stream: categoryProducts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('error occurred...');
        }
        if (snapshot.hasData &
        (snapshot.data is List<Product>)) {
          List<Product> currentProducts = snapshot.data; 
          return ProductsList(
            context: context,
            products: currentProducts,
          );
        }
        return Text('loading products...');
      }
    );
  }

}

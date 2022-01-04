import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/catalogue_bloc.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/PageLoadingCenter.dart';
import 'package:myapp/src/ui/components/products/ProductsList.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;
  CategoryPage({
    required this.categoryId
  });

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{

  var _category = null;
  var _categoryProducts = null;

  setCategory (category) {
    setState(() => _category = category);
  }

  setCategoryProducts (categoryProducts) {
    setState(() => _categoryProducts = categoryProducts);
  }


  refreshCategoryPage () async {
    // await loadCategoryPageInfo();
    setCategoryProducts(null);
    setCategory(null);
  }

  loadCategoryPageInfo () async {
    print('run category get page info');
    if (_category != null) {
      return _category;
    }
    Category currentCategory = await catalogueBloc.fetchCategoryById(widget.categoryId);
    setCategory(currentCategory);
    return _category;
  }

  loadCategoryProducts () async {
    print('run get category products');   
    if (_categoryProducts != null) {
      return _categoryProducts;
    }
    List<Product> categoryProducts = await catalogueBloc.fetchCategoryProducts(widget.categoryId);
    setCategoryProducts(categoryProducts);
    return _categoryProducts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadCategoryPageInfo(),
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
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            MainSliverRefreshControl(
              handleOnRefresh: () async => await refreshCategoryPage(),
            ),
            SliverAppBar(
              //snap: true,
              //floating: true,
              backgroundColor: Colors.transparent,
              pinned: true,
              title: Text('${category.name}'),
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "http://placehold.it/1000x1000"
                  )
                ),
              ),
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
    return FutureBuilder(
      future: loadCategoryProducts(),
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

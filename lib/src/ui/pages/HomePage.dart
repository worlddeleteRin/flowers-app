import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartIconBadge.dart';
import 'package:myapp/src/ui/components/common/NavigationTitle.dart';
import 'package:myapp/src/ui/components/products/HorizontalCategories.dart';
import 'package:myapp/src/ui/components/products/HorizontalProducts.dart';
// import 'package:myapp/src/ui/components/products/ProductsList.dart';
// import 'package:myapp/src/ui/pages/CartPage.dart';
import 'package:myapp/src/ui/pages/CategoryPage.dart';

// local imports
import '../../blocs/catalogue_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key:key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  
  /*
  Future _refreshCategories () async {
    catalogueBloc.fetchCategories();
  }
  */
  refreshHome () async {
    print('refreshing home page');
    // TODO: remove delayed in production
    // await Future.delayed(Duration(seconds: 1));
    await catalogueBloc.fetchCategories();
    await catalogueBloc.fetchProducts();
  }

  goCataloguePage({ required BuildContext context }) {
    Navigator.pushNamed(
      context,
      '/catalogue',
    );
  }

  goCategoryPage({
    required BuildContext context,
    required String categoryId
  }) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return CategoryPage(
            categoryId: categoryId,
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!catalogueBloc.categoriesFetched) {
      catalogueBloc.fetchCategories();
    }
    if (!catalogueBloc.productsFetched) {
      catalogueBloc.fetchProducts();
    }

      return Scaffold(
        appBar: AppBar(
          title: Text('Главная'),
          actions: [
            CartIconBadge(context: context),
          ]
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              sliverRefreshControl(),

              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: NavigationTitle(
                    context: context,
                    title: "Каталог товаров",
                    handleRouteClick: () => goCataloguePage(context: context),
                  ),
                ),
              ),

              StreamBuilder(
                stream: catalogueBloc.allCategories,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (
                      snapshot.hasData & 
                      (snapshot.data is List<Category>)
                    ) {
                    List<Category> categories = snapshot.data;
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: HorizontalCategories(
                              context: context,
                              categories: categories,
                            ),
                          ),

                          CategoriesProductsBuilder(
                            context: context,
                            categories: categories,
                          ),

                          SizedBox(height: 10.0),

                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    SliverToBoxAdapter(
                      child: Text('error while loading categories'),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Text('loading...'),
                  );
                }
              ),


              
            ],
          ),
        ),
    );
  }

  Widget CategoriesProductsBuilder({
    required BuildContext context,
    required List<Category> categories,
  }) {
    return StreamBuilder(
      stream: catalogueBloc.allProducts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        

        if (snapshot.hasData & (snapshot.data is List<Product>)) {
          List<Product> products = snapshot.data;
            return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {

              List<Product> categoryProducts = products.where(
                (product) => product.categories.any(
                  (category) => category.id == categories[index].id
                )
              ).take(10).toList();

              if (categoryProducts.length == 0) {
                return SizedBox();
              }

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 14.0),
                    child: NavigationTitle(
                      context: context,
                      title: categories[index].name,
                      navText: "В категорию",
                      handleRouteClick: () => goCategoryPage(
                        context: context,
                        categoryId: categories[index].id,
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: HorizontalProducts(
                      context: context,
                      products: categoryProducts,
                    ),
                  ),
                ],
              );

            }
          );
        }
        if (snapshot.hasError) {
          return Text('error while loading products');
        }
          return Text('loading...');
      }
    );
  }

  Widget sliverRefreshControl () {
    return CupertinoSliverRefreshControl(
      onRefresh: () async {
        await refreshHome();
      },
    );
  }

}

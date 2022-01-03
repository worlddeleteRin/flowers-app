// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartIconBadge.dart';
import 'package:myapp/src/ui/components/common/NavigationTitle.dart';
import 'package:myapp/src/ui/components/products/HorizontalCategories.dart';
import 'package:myapp/src/ui/components/products/ProductsList.dart';
import 'package:myapp/src/ui/pages/CartPage.dart';

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

  @override
  Widget build(BuildContext context) {

    if (!catalogueBloc.categoriesFetched) {
      catalogueBloc.fetchCategories();
    }
    if (!catalogueBloc.productsFetched) {
      catalogueBloc.fetchProducts();
    }

      return Scaffold(
        /*
        navigationBar: CupertinoNavigationBar(
          middle: Text('asdasdf'), 
        ),
        */
        appBar: AppBar(
          title: Text('Главная'),
          actions: [
            CartIconBadge(context: context),
          ]
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              sliverRefreshControl(),

              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: NavigationTitle(
                    context: context,
                    title: "Каталог товаров",
                    pageRouteName: '/catalogue',
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
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: HorizontalCategories(
                          context: context,
                          categories: categories,
                        ),
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

              StreamBuilder(
                stream: catalogueBloc.allProducts,
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  if (snapshot.hasData & (snapshot.data is List<Product>)) {
                    // List<Product> products = snapshot.data;
                    return SliverToBoxAdapter(
                      child: ProductsList(
                        context: context,
                        products: snapshot.data,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Text('error while loading products')
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Text('loading...')
                  );
                }
              ),
              
            ],
          ),
        ),
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

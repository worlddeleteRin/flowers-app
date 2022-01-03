import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/catalogue_bloc.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartIconBadge.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/products/CategoryCard.dart';

class CataloguePage extends StatelessWidget {

  refreshCatalogue () async {
    print('refreshing catalogue');
    // TODO: remove delayed in production
    // await Future.delayed(Duration(seconds: 1));
    await catalogueBloc.fetchCategories();
  }

  @override 
  Widget build (BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Каталог товаров"),
        actions: [
          CartIconBadge(context: context),
        ]
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            MainSliverRefreshControl(
              handleOnRefresh: () async => await refreshCatalogue(),
            ),
            categoriesStreamBuilder(),
          ]
        ),
      )
      // Text('catalogue page is here')
    );
  }

  Widget categoriesStreamBuilder () {
    return StreamBuilder(
      stream: catalogueBloc.allCategories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is List<Category>)) {
          List<Category> categories = snapshot.data;
          return sliverCatalogueList(
            context: context,
            categories: categories,
          );
        }
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Text('Loading categories...'),
          );
        }
        return SliverToBoxAdapter(
          child: Text('Loading categories...'),
        );
      }
    );
  }

  Widget sliverCatalogueList ({
    required BuildContext context,
    required List<Category> categories,
  }) {

    List<Widget> categoriesListBlock = 
    categories.map<Widget>((category) => 
      CategoryCard(
        context: context,
        category: category,
      )
    ).toList();

    return SliverToBoxAdapter(
      child: GridView(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 150.0,
          crossAxisCount: 3,
          crossAxisSpacing: 7.0,
        ),
        children: categoriesListBlock,
      ),
    );
  }

}

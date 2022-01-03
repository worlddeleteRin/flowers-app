import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/api/catalogue_api_provider.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartIconBadge.dart';
import 'package:myapp/src/ui/components/common/PageLoadingCenter.dart';
import 'package:myapp/src/ui/components/products/ProductPageContent.dart';
//import 'package:myapp/src/ui/pages/CartPage.dart';

// blocs
//import 'package:myapp/src/blocs/catalogue_bloc.dart';


class ProductPage extends StatefulWidget {
  final String id;

  ProductPage({
    required this.id,
  });

  _ProductPageState createState() => _ProductPageState();

}

class _ProductPageState extends State<ProductPage> {
  var _product = null;
  bool _productLoading = false;

  final catalogueAPIProvider = CatalogueAPIProvider();

  setProduct(product) {
    setState(() => _product = product); 
  }

  loadProduct () async {
    final product_response = await catalogueAPIProvider.getProduct(widget.id);
    Product currentProduct = Product.fromJson(product_response);
    print('current product is');
    return currentProduct;
  }

  getProduct () async {
    // TODO: remove delayed;
    // await Future.delayed(Duration(seconds: 1));
    print('run get product');
    if (this._product != null) {
      return _product;
    }
    Product currentProduct = await loadProduct();
    setProduct(currentProduct);
    return this._product;
  }

  updateProductPage () async {
    print('run update Product page');
    // await Future.delayed(Duration(seconds: 1));
    setProduct(null);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // stream: _product,
      future: getProduct(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(  
            child: Text("error fetching product"),
          );
        }
        if (snapshot.hasData & (snapshot.data is Product)) {
          Product product = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('${product.name}'),
              actions: [
                CartIconBadge(context: context),
              ],
            ),
            body: SafeArea(
              maintainBottomViewPadding: true,
              child: ProductPageContent(
                product: product,
                handleUpdateProduct: updateProductPage, 
              ),
            ),
          );
        }
        return ProductPageLoading();
      }
    );
  }

  Widget ProductPageLoading () {
    return SafeArea(
      child: Scaffold(
        body: PageLoadingCenter(),
      ),
    );
  }

}


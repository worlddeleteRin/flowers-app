import 'dart:async';
//import 'dart:convert';
import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';

class CatalogueAPIProvider {
  Dio client = APIClient().loadDef();

  /// get all categories from api
  Future getCategories() async {
    print('run get categories function');
    Response response = await client.get(
      "/products/categories/"
    );
    return response.data["categories"];
  }

  /// get category object by it's [categoryId]
  Future getCategoryById(String categoryId) async {
    print('run get categories function');
    Response response = await client.get(
      "/products/categories/$categoryId"
    );
    return response.data;
  }

  /// get all category products it's [categoryId]
  Future getCategoryProducts(String categoryId) async {
    print('run get category products request');
    Response response = await client.get(
      "/products/categories/$categoryId/products"
    );
    // print('resp data is ${response.data.toString()}');
    return response.data;
  }

  /// get all products from api
  Future getProducts() async {
    print('run get products function');
    Response response = await client.get(
      "/products"
    );
    return response.data["products"];
  }

  /// get product with [productId] from api
  Future getProduct(String productId) async {
    // print('run get product function, product id is' + productId);
    Response response = await client.get(
      "/products/$productId"
    );
    return response.data;
  }

}

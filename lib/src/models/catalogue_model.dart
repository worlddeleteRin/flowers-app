// import 'dart:core';
import 'package:myapp/src/blocs/cart_bloc.dart';

class ProductCategory {
  String? id;
  String name;
  String slug;

  ProductCategory({
    this.id,
    required this.name,
    required this.slug,
  });

 factory ProductCategory.fromJson(Map<String,dynamic> json) {
  return ProductCategory(
    id: json["id"], 
    name: json["name"],
    slug: json["slug"],
  );
 }

}

class Product {
  String id; 
  String slug;
  String name;
  String description;
  List<String> imgsrc;
  int price;
  int? sale_price;
  String weight;
  List<ProductCategory> categories;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    this.description = "",
    required this.imgsrc,
    required this.price,
    this.sale_price,
    this.weight = "",
    this.categories = const [],
    // this.categories = ,
  });

  factory Product.fromJson(Map<String,dynamic> json) {

    List<String> imgsrcList = json["imgsrc"].map<String>((item) =>
      item.toString()
    ).toList();
    List<ProductCategory> productCategoriesList = 
      json["categories"].map<ProductCategory>((item) => 
      ProductCategory.fromJson(item)
    ).toList();

    return Product(
      id: json["id"],
      slug: json["slug"],
      name: json["name"],
      description: json["description"],
      imgsrc: imgsrcList,
      price: json["price"],
      sale_price: json["sale_price"],
      weight: json["weight"],
      categories: productCategoriesList,
    );
  }

  addToCart () async {
    await cartBloc.addCartItems(
      productId: this.id, 
    );
  }

  bool hasSalePrice () {
    if (this.sale_price == null ||
    (this.sale_price == 0) || 
    (!(this.sale_price is int))) {
      return false;
    }
    return true;
  }

}

class Category {
  String id;
  String name;
  String slug;
  String? description;
  List<String> imgsrc;
  int menu_order;
  String? parent_id;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description = "",
    this.imgsrc = const [],
    required this.menu_order,
    this.parent_id
  });

  factory Category.fromJson(Map<String,dynamic> json) {

    List<String> categoryImageList = 
      json["imgsrc"].map<String>((image) => image.toString()).toList();

    return Category(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      description: json["descripton"],
      imgsrc: categoryImageList,
      menu_order: json["menu_order"],
      parent_id: json["parent_id"],
    );
  }
  
}

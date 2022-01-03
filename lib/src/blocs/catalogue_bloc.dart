import 'package:myapp/src/models/catalogue_model.dart';
import 'package:rxdart/rxdart.dart';
import '../api/catalogue_api_provider.dart';


class CatalogueBloc {
  CatalogueAPIProvider catalogueAPIProvider = CatalogueAPIProvider();

  BehaviorSubject _categoriesFetcher = BehaviorSubject();
  BehaviorSubject _productsFetcher = BehaviorSubject();
  BehaviorSubject _productFetcher = BehaviorSubject();

  // test methods
  removeCategories () {
    _categoriesFetcher.sink.add(null);
  }
  // eof test methods

  bool categoriesFetched = false;
  bool productsFetched = false;

  Stream get allCategories => _categoriesFetcher.stream;
  Stream get allProducts => _productsFetcher.stream;
  Stream get currentProduct => _productFetcher.stream;

  /// get all categories, assign it to `_categoriesFetcher`
  fetchCategories() async {
    // _categoriesFetcher.sink.add(null);
      // final categories = await catalogueAPIProvider.getCategories();
    try {
      List categoriesRaw = await catalogueAPIProvider.getCategories();
      List<Category> categories = categoriesRaw.map<Category>(
        (category) => Category.fromJson(category)
      ).toList();
      _categoriesFetcher.sink.add(categories);
      categoriesFetched = true;
    } on Exception {
      _categoriesFetcher.addError(
        "error while loading categories"
      );
    }
  }

  Future<Category> fetchCategoryById(String categoryId) async {
    try {
      Map<String,dynamic> categoryRaw = 
      await catalogueAPIProvider.getCategoryById(categoryId);
      Category category = Category.fromJson(categoryRaw);
      // print('category is ${category.name}');
      return category;
    } on Exception {
      throw Exception();
    }
  }

  Future<List<Product>> fetchCategoryProducts(String categoryId) async {
    try {
      List categoryProductsRaw = 
      await catalogueAPIProvider.getCategoryProducts(categoryId);
      List<Product> categoryProducts = categoryProductsRaw.map<Product>(
        (product) => Product.fromJson(product)  
      ).toList();
      // print('category products are ${categoryProducts.toString()}');
      return categoryProducts;
    } on Exception {
      throw Exception();
    }
  }

  /// get all products and assign to `_productsFetcher`
  fetchProducts() async {
    // _productsFetcher.sink.add(null);
    try {
      List productsRaw = await catalogueAPIProvider.getProducts();
      List<Product> products = productsRaw.map<Product>((product) =>
        Product.fromJson(product)
      ).toList();
      productsFetched = true;
      _productsFetcher.sink.add(products);
    } on Exception {
      _productsFetcher.addError(
        "error while loading products"
      );
    }
  }

  // TODO: remove fetchProduct, done on component level
  fetchProduct(String product_id) async {
    _productFetcher.sink.add(null);
    try {
      Map product = await catalogueAPIProvider.getProduct(product_id);
      _productFetcher.sink.add(product);
    } on Exception {
      _productFetcher.addError(
        "error while loading product"
      );
    }
  }

  /// close all `CatalogueBloc` streams
  dispose() {
    _categoriesFetcher.close();
    _productsFetcher.close();
  }

}

final catalogueBloc = CatalogueBloc();

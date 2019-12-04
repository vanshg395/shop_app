import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProducts() async {
    const url = 'https://shop-app-2766f.firebaseio.com/products.json';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      _items = [];
      if (responseData != null) {
        responseData.forEach((prodId, prodData) {
          _items.insert(
              0,
              Product(
                id: prodId,
                title: prodData['title'],
                description: prodData['description'],
                isFavorite: prodData['isFavorite'],
                price: prodData['price'],
                imageUrl: prodData['imageUrl'],
              ));
        });
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Product product) async {
    const url = 'https://shop-app-2766f.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem(Product editedProduct) async {
    final itemIndex = _items.indexWhere((item) {
      return item.id == editedProduct.id;
    });
    final url =
        'https://shop-app-2766f.firebaseio.com/products/${editedProduct.id}.json';
    await http.patch(url,
        body: json.encode({
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price,
          'imageUrl': editedProduct.imageUrl,
        }));
    _items[itemIndex] = editedProduct;
  }

  Future<void> deleteProduct(Product product) async {
    final url =
        'https://shop-app-2766f.firebaseio.com/products/${product.id}.json';
    final existingProductIndex = _items.indexOf(product);
    var existingProduct = _items[existingProductIndex];
    try {
      final response = await http.delete(url);
      _items.remove(product);
      notifyListeners();
      if (response.statusCode >= 400) {
        throw HttpException('The product could not be deleted.');
      }
      existingProduct = null;
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw error;
    }
  }
}

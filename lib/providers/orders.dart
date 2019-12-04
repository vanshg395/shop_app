import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    const url = 'https://shop-app-2766f.firebaseio.com/orders.json';

    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    _orders = [];
    if (responseData != null) {
      responseData.forEach((orderId, orderData) {
        _orders.insert(
          0,
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            time: DateTime.parse(orderData['time']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (prod) => CartItem(
                    id: prod['id'],
                    title: prod['title'],
                    price: prod['price'],
                    quantity: prod['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });
    }
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-2766f.firebaseio.com/orders.json';

    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts.map((cp) {
            return {
              'id': cp.id,
              'price': cp.price,
              'quantity': cp.quantity,
              'title': cp.title,
            };
          }).toList(),
          'time': timestamp.toIso8601String(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        time: timestamp,
      ),
    );
    notifyListeners();
  }
}

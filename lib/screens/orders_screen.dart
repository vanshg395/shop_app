import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/nav_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchOrders().then((_) {
        _isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: NavDrawer(),
        body: !_isLoaded
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: (ctx, index) =>
                      OrderItem(ordersData.orders[index]),
                  itemCount: ordersData.orders.length,
                ),
                onRefresh: () => ordersData.fetchOrders().then((_) {
                  _isLoaded = true;
                }),
              ));
  }
}

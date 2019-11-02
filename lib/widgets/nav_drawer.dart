import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Container(
          //   color: Theme.of(context).backgroundColor,
          //   padding: EdgeInsets.all(15),
          //   height: 150,
          //   alignment: Alignment.bottomCenter,
          //   child: Text(
          //     'Hello Friend!',
          //     style: TextStyle(
          //       fontSize: 42,
          //     ),
          //   ),
          // ),
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

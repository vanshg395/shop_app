import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => EditProductScreen(
                          title: 'Edit Product',
                          product: product,
                        )));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                final Future<bool> confirmDeletion = showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to remove this product?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      );
                    });
                confirmDeletion.then((value) {
                  if (value) {
                    Provider.of<Products>(context)
                        .deleteProduct(product)
                        .catchError((error) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

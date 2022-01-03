import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/ui/pages/CartPage.dart';
import 'package:badges/badges.dart';

Widget CartIconBadge({
  required BuildContext context,
}) {

  Widget cartIcon = 
  Icon(
    Icons.shopping_cart
  );

  Widget badgeWidget = 
  StreamBuilder(
    stream: cartBloc.cart,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData &
        (snapshot.data is Cart)
      ) {
        Cart cart = snapshot.data;
        if (cart.line_items.length > 0) {
          return Badge(
            toAnimate: true,
            animationType: BadgeAnimationType.scale,
            badgeContent: Text(
              cart.line_items.length.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            child: cartIcon,
          );
        } else {
          return cartIcon;
        }
      }
      return cartIcon;
    }
  );

  Widget icon = TextButton(
    onPressed: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) =>
          CartPage(),
        ),
      );
    },
    child: badgeWidget,
  );
  return icon;
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/ui/pages/CartPage.dart';
import 'package:badges/badges.dart';

Widget CartIconBadge({
  required BuildContext context,
  Color iconColor = Colors.black,
  Color backgroundColor = Colors.transparent,
}) {

  Widget cartIcon = 
  Container(
    padding: EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Icon(
      Icons.shopping_cart,
      color: iconColor,
    ),
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
      BuildContext mainContext = Scaffold.of(context).context;
      Navigator.push(
        mainContext,
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

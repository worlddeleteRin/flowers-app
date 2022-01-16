// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/models/cart_model.dart';
// import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/CartEmptyBlock.dart';
import 'package:myapp/src/ui/components/cart/CartLineItems.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/pages/CheckoutPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState () => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  bool _cartRefreshing = false;

  void setCartRefreshing(bool isRefreshing) {
    setState(() => _cartRefreshing = isRefreshing);
  }

  void refreshCartPage () async {
    if (_cartRefreshing) { return;}
    setCartRefreshing(true);
    await cartBloc.fetchCart();
    setCartRefreshing(false);
  }

  removeLineItem ({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_cartRefreshing) { return;}
    setCartRefreshing(true);
    await cart.removeLineItem(lineItemId);
    setCartRefreshing(false);
  }

  removeLineItemQuantity ({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_cartRefreshing) { return;}
    setCartRefreshing(true);
    await cart.removeLineItemQuantity(lineItemId);
    setCartRefreshing(false);
  }

  addLineItemQuantity ({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_cartRefreshing) { return;}
    setCartRefreshing(true);
    await cart.addLineItemQuantity(lineItemId);
    setCartRefreshing(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: cartBloc.cart,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData & 
            (snapshot.data is Cart)) {
              Cart cart = snapshot.data;
              if (cart.line_items.length > 0) {
                return CartContent(
                  context: context,
                  cart: cart
                );
              } else {
                return CartEmptyBlock(context: context);
              }
            }
            return CartEmptyBlock(context: context);
          }
        )

      ),
    );
  }

  Widget CartContent ({
    required BuildContext context,
    required Cart cart,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 14.0,
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                MainSliverRefreshControl(
                  handleOnRefresh: () async => refreshCartPage(),
                ),
                SliverToBoxAdapter(
                  child: CartLineItems(
                    lineItems: cart.line_items,
                    handleRemoveLineItem: (String lineItemId) async => 
                    await removeLineItem(
                      cart: cart, 
                      lineItemId: lineItemId,
                    ),
                    handleRemoveLineItemQuantity: (String lineItemId) async =>
                    await removeLineItemQuantity(
                      cart: cart,
                      lineItemId: lineItemId,
                    ),
                    handleAddLineItemQuantity: (String lineItemId) async =>
                    await addLineItemQuantity(
                      cart: cart,
                      lineItemId: lineItemId,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: CartBottomMenu(
                    context: context,
                    cart: cart,
                  ),
                ),
              ]
            ),
          ),
          // eof cart main content
          // cart go checkout
          Container(
            child: CartBottomSheet(
              handleGoCheckout: () {
                BuildContext mainContext = Scaffold.of(context).context;
                Navigator.push(
                  mainContext,
                  CupertinoPageRoute(
                    builder: (BuildContext mainContext) {
                      return CheckoutPage();
                    }
                  )
                );
              },
            ),
          ),
          // eof cart go checkout
        ],
      ),
    );

  }

  Widget CartBottomMenu({
    required BuildContext context,
    required Cart cart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Доставка без оповещения'),
          trailing: CupertinoSwitch(
            activeColor: Colors.black,
            value: false,
            onChanged: (value) {},
          ),
        ),
        ListTile(
          title: Text(
            'Сумма заказа',
            style: Theme.of(context).textTheme.subtitle1
          ),
          trailing: Text(
            "${cart.base_amount}",
            style: Theme.of(context).textTheme.subtitle1
          ),
        ),
        ListTile(
          title: Text(
            'Сумма скидки',
            style: Theme.of(context).textTheme.subtitle1
          ),
          trailing: Text(
            "${cart.discount_amount}",
            style: Theme.of(context).textTheme.subtitle1
          ),
        ),
        ListTile(
          title: Text(
            'Общая стоимость',
            style: Theme.of(context).textTheme.subtitle1
          ),
          trailing: Text(
            "${cart.total_amount}",
            style: Theme.of(context).textTheme.subtitle1
          ),
        ),
      ]
    );
  }

  Widget CartBottomSheet({
    required Function handleGoCheckout
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () => handleGoCheckout(),
              child: Text(
                "К оформлению заказа",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )
              )
            ),
          )
        ),
      ]
    );
  }

}


import 'package:flutter/material.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/ui/components/cart/CartLineItem.dart';

class CartLineItems extends StatelessWidget {
  final List<LineItem> lineItems;
  final Function handleRemoveLineItem;
  final Function handleAddLineItemQuantity;
  final Function handleRemoveLineItemQuantity;

  CartLineItems({
    required this.lineItems,
    required this.handleRemoveLineItem,
    required this.handleAddLineItemQuantity,
    required this.handleRemoveLineItemQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        // itemExtent: 100.0,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: lineItems.length,
        itemBuilder: (BuildContext context, int index) {
          return CartLineItem(
            lineItem: lineItems[index], 
            handleRemoveLineItem: (String lineItemId) async => 
            await handleRemoveLineItem(lineItemId),
            handleAddLineItemQuantity: (String lineItemId) async => 
            await handleAddLineItemQuantity(lineItemId),
            handleRemoveLineItemQuantity: (String lineItemId) async => 
            await handleRemoveLineItemQuantity(lineItemId),
          );
        }
      )
    );
  }
}

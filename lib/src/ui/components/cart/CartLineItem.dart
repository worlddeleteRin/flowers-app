import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/ui/components/cart/ProductCartQuantityBlock.dart';
import 'package:myapp/src/ui/pages/ProductPage.dart';

class CartLineItem extends StatelessWidget {
  final LineItem lineItem;
  final Function handleRemoveLineItem;
  final Function handleAddLineItemQuantity;
  final Function handleRemoveLineItemQuantity;

  CartLineItem({
    required this.lineItem,
    required this.handleRemoveLineItem,
    required this.handleAddLineItemQuantity,
    required this.handleRemoveLineItemQuantity,
  });



  Widget build(BuildContext context) {
    goProductPage () {
      Navigator.push(
        context, 
        CupertinoPageRoute(
          builder: (BuildContext context) => ProductPage(
            id: lineItem.product.id,
          )
        ),
      );
    }

    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0), 
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
            blurRadius: 7.0,
            offset: Offset(0.0, 0.0),
            spreadRadius: -5.0,
          )
        ]
        // shape: BoxShape.circle
      ),
      // color: Colors.grey.withOpacity(0.2),
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {goProductPage();},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineItemImageBlock(),
                SizedBox(width: 14.0),
                LineItemContentBlock(),
              ],
            ),
          ),
          LineItemActionsBlock(),
        ],
      ),
    );
  }

  Widget LineItemActionsBlock () {
    return Container(
      height: 40.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LineItemDeleteAction(
            handleClick: () async => await handleRemoveLineItem(lineItem.id),
          ),
          SizedBox(width: 5.0),
          Container(
            child: ProductCartQuantityBlock(
              handleAddQuantity: () async => await handleAddLineItemQuantity(lineItem.id),
              handleRemoveQuantity: () async => await handleRemoveLineItemQuantity(lineItem.id),
              quantity: lineItem.quantity.toString(), 
              useButtonBackgroundColor: false,
            )
          ),
        ]
      ),
    );
  }

  Widget LineItemDeleteAction ({
    required Function handleClick
  }) {
    return Container(
      child: TextButton.icon(
        onPressed: () async => await handleClick(),
        label: Text("Удалить"),
        icon: Icon(Icons.delete_sweep_outlined),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            Colors.red
          ),
        ),
      ),
    );
  }

  Widget LineItemImageBlock () {
    return Container(
      color: Colors.white,
      width: 100.0,
      child: Image(
        width: 100.0,
        height: 70.0,
        fit: BoxFit.contain,
        image: CachedNetworkImageProvider(
          lineItem.product.imgsrc[0]
        )
      ),
    );
  }

  Widget LineItemContentBlock () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cartItemPriceBlock(),   
        SizedBox(height: 7.0),
        cartItemNameBlock(),   
      ]
    );
  }

  Widget cartItemPriceBlock() {
    Widget priceContent;
    if (lineItem.product.hasSalePrice()) {
      priceContent =
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ 
          Text( 
            "${lineItem.product.sale_price} ₽",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            )
          ),
          SizedBox(width: 4.0),
          Text( 
            "${lineItem.product.price} ₽",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.red,
              decorationThickness: 1.3,
            )
          ),
        ],
      );
    }
    else {
      priceContent = 
      Text( 
        "${lineItem.product.price} ₽",
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        )
      );
    }
    return priceContent;

  }

  Widget cartItemNameBlock() {
    return Text(
      lineItem.product.name 
    );
  }

}


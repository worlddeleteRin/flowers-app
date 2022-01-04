import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/ui/components/products/ProductButtonLoading.dart';

// local imports
// import 'package:myapp/src/ui/components/products/DraggableProductPage.dart';
import 'package:myapp/src/ui/pages/ProductPage.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  ProductCard({
    required this.product,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
    bool isCartButtonLoading = false;

    setIsCartAdding(bool isAdding) {
       setState(() {
        isCartButtonLoading = isAdding;
      });     
    }

    addProductCartClick () async {
      if (isCartButtonLoading) {
        return false;
      }
      setIsCartAdding(true);
      // TODO: remove delay
      // await Future.delayed(Duration(seconds: 1));
      await widget.product.addToCart();
      setIsCartAdding(false);
    }

    removeProductCartClick ({
      required Cart cart,
      required LineItem lineItem
    }) async {
      if (isCartButtonLoading) {
        return false;
      }
      setIsCartAdding(true);
      // TODO: remove delay
      // await Future.delayed(Duration(seconds: 1));
      await cart.removeLineItem(lineItem.id);
      setIsCartAdding(false);
    }

    goProductPage () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => ProductPage(
            id: widget.product.id,
          ),
        ),
      );
    }

    Widget ProductAddCartButton () {

      Widget addCartContent () {
        if (isCartButtonLoading) {
          return ProductButtonLoading();
        }
        return Text("В корзину");
      };

      Widget addedCartContent () {
        if (isCartButtonLoading) {
          return ProductButtonLoading();
        }
        return Text("В корзине");
      };

      return StreamBuilder(
        stream: cartBloc.cart, 
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData & 
          (snapshot.data is Cart)) {
            Cart cart = snapshot.data;
            LineItem? lineItem = cart.checkGetProductInCart(
              widget.product.id
            );
            if (lineItem != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      )
                    ),
                    onPressed: () async {  await removeProductCartClick(
                      cart: cart,
                      lineItem: lineItem,
                    ); },
                    child: addedCartContent(),
                  ),
                ]
              );
            }
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {  await addProductCartClick(); },
                child: addCartContent(),
              ),
            ]
          );

        }
      );
      
    }

    Widget productNameBlock () {
      return Container(
        // height: 35.0,
        margin: EdgeInsets.only(top: 5.0),
        child: Text(
          widget.product.name,
          maxLines: 2,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      );
    }

    Widget productPriceBlock () {
      Widget priceContent;
      Product product = widget.product;
      if (product.hasSalePrice()) {
        priceContent =
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            Text( 
              "${product.sale_price} ₽",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              )
            ),
            SizedBox(width: 4.0),
            Text( 
              "${product.price} ₽",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red,
                decorationThickness: 1.3,
              )
            ),
          ],
        );
      } else {
        priceContent = 
        Text( 
          "${product.price} ₽",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          )
        );
      }
      return priceContent;
    }

    Widget productDescriptionBlock () {
      return Text(
        widget.product.description
      );
    }

    Widget productCardContentBlock () {
      return Expanded(
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 8.0,
                  bottom: 2.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productPriceBlock(),
                        productNameBlock(),
                      ]
                    ),
                    // productDescriptionBlock,
                    ProductAddCartButton(),
                  ]
                ),
              ),
            ),
          ],
        ),
      );
    }


    Widget productCardImage () {
      return GestureDetector(
        onTap: () { goProductPage(); },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), 
              topRight: Radius.circular(10.0),
            ),
          ),
          height: 130,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), 
              topRight: Radius.circular(10.0),
            ),
            child: Image(
              // height: 130,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Text("error while loading image");
              },
              image: CachedNetworkImageProvider(
                // "http://placehold.it/500x500",
                widget.product.imgsrc[0], 
              ),
            ),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 0.0),
              blurRadius: 14.0,
              spreadRadius: -13.0,
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: EdgeInsets.all(0),  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            productCardImage(),
            productCardContentBlock(),
          ]
        ),
      );
    }
}

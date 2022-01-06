import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; import 'package:myapp/src/blocs/cart_bloc.dart'; import 'package:myapp/src/models/cart_model.dart'; // blocs
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/cart/ProductCartQuantityBlock.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/products/ProductButtonLoading.dart';

class ProductPageContent extends StatefulWidget {
  final Product product;
  final Function handleUpdateProduct;

  ProductPageContent({
    required this.product,
    required this.handleUpdateProduct,
    ScrollController? scrollController,
  });

  @override 
  _ProductPageContentState createState() => _ProductPageContentState();

}

class _ProductPageContentState extends State<ProductPageContent> {

  bool _productProcessingCart = false;

  setProductProcessingCart(bool isProcessing) {
    setState(() => _productProcessingCart = isProcessing);
  }

  refreshProductPage() async {
    print('updating product page');
    // await Future.delayed(Duration(seconds:1));
    await widget.handleUpdateProduct();
  }

  addCart () async {
    if (_productProcessingCart) {
      return;
    }
    setProductProcessingCart(true);
    // TODO: remove delayed
    // await Future.delayed(Duration(seconds: 1));
    await widget.product.addToCart();
    setProductProcessingCart(false);
  }

  removeCart ({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_productProcessingCart) {
      return;
    }
    setProductProcessingCart(true);
    // TODO: remove delayed
    // await Future.delayed(Duration(seconds: 1));
    await cart.removeLineItem(lineItemId);
    setProductProcessingCart(false);
  }

  removeQuantity({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_productProcessingCart) {
      return;
    }
    setProductProcessingCart(true);
    await cart.removeLineItemQuantity(lineItemId);
    setProductProcessingCart(false);
  }

  addQuantity({
    required Cart cart,
    required String lineItemId,
  }) async {
    if (_productProcessingCart) {
      return;
    }
    setProductProcessingCart(true);
    await cart.addLineItemQuantity(lineItemId);
    setProductProcessingCart(false);
  }



  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Expanded(
          child: Container(
            // color: Colors.green,
            padding: EdgeInsets.only(
              top: 14.0,
              left: 14.0,
              right: 14.0,
            ),
            // height: mainContentHeight,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                MainSliverRefreshControl(
                  handleOnRefresh: () async => await refreshProductPage(),
                ),
                SliverToBoxAdapter(
                  child: productPageImage(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.0),
                ),
                SliverToBoxAdapter(
                  child: productPagePrice(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.0),
                ),
                SliverToBoxAdapter(
                  child: productPageName(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.0),
                ),
                SliverToBoxAdapter(
                  child: productPageDescription(),
                ),
              ],
            ),
          ),
        ),

        Container(
          height: 80.0,
          color: Colors.grey.withOpacity(0.1),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 14.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50.0,
                child: productCartBlock(
                  context: context,
                ),
              ),
            ]
          ),
        ),

      ]
    );
  }

  Widget productPageImage() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0
      ),
      child: Image(
        image: CachedNetworkImageProvider(
          widget.product.imgsrc[0],
          // "http://placehold.it/500x500",
        )
      ),
    );
  }

  Widget productPagePrice() {
    return Container(
      child: Text(
        "${widget.product.price} ₽",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
        )
      ),
    );
  }

  Widget productPageName() {
    return Container(
      child: Text(
        "${widget.product.name}",
        style: Theme.of(context).textTheme.headline6
      ),
    );
  }

  Widget productPageDescription() {
    return Container(
      child: Text(
        "${widget.product.description}",
        style: Theme.of(context).textTheme.subtitle1
      ),
    );
  }

  Widget productCartBlock ({
    required BuildContext context,
  }) {
    return StreamBuilder(
      stream: cartBloc.cart,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData & 
        (snapshot.data is Cart)) {
          Cart cart = snapshot.data;
          LineItem? lineItem = cart.checkGetProductInCart(widget.product.id);
          if (lineItem != null) {
            return Row(
              children: [
                productAddCartButton(
                  isInCart: true,
                  buttonClickHandle: () async {
                    Navigator.pushNamed(
                      context,
                      '/cart',
                    );
                    /*
                    await removeCart(
                      cart: cart,
                      lineItemId: lineItem.id
                    );
                    */
                  }
                ),
                SizedBox(width: 9.0),
                ProductCartQuantityBlock(
                  handleAddQuantity: () async => await addQuantity(
                    cart: cart,
                    lineItemId: lineItem.id,
                  ),
                  handleRemoveQuantity: () async => await removeQuantity(
                    cart: cart,
                    lineItemId: lineItem.id,
                  ),
                  quantity: lineItem.quantity.toString(),
                  useButtonBackgroundColor: true,
                ),
              ],
            );
          }
        }
        return Row(
          children: [
            productAddCartButton(
              isInCart: false,
              buttonClickHandle: () async => await addCart(),
            ),
          ],
        );
      }
    );
  }

  Widget productAddCartButton ({
    required bool isInCart,
    required Function buttonClickHandle,
  }) {

    String buttonTitle;
    String buttonSubtitle;
    Color buttonBackgroundColor;

    if (isInCart) {
      buttonTitle = "В корзине";
      buttonSubtitle = "Перейти";
      buttonBackgroundColor = Colors.green;
    } else {
       buttonTitle = "В корзину";
       buttonSubtitle = '${widget.product.price.toString()} ₽';     
       buttonBackgroundColor = Theme.of(context).primaryColor;
    }

    Widget buttonContent;
    if (_productProcessingCart) {
      buttonContent = ProductButtonLoading();
    } else {
      buttonContent = 
      Container(
        padding: EdgeInsets.symmetric(
          // vertical: 7.0,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonTitle,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              buttonSubtitle,
            ),
          ]
        ),
      );
    }

    return Container(
      // width: double.infinity,
      child: Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              buttonBackgroundColor,
            )
          ),
          onPressed: () async => await buttonClickHandle(), 
          child: buttonContent,
        ),
      ),
    );
  }

}



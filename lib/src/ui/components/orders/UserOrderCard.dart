import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/orders_model.dart';

class UserOrderCard extends StatelessWidget {
  final Order order;
  final Function cardTap;

  UserOrderCard({
    required this.order,
    required this.cardTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => cardTap(order.id),
        child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 14.0,
        ),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0)
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderDateBlock(),
            SizedBox(height: 5.0),
            OrderStatusBlock(),
            SizedBox(height: 5.0),
            OrderDeliveryMethodBlock(),
            SizedBox(height: 5.0),
            OrderDeliveryAddressBlock(),
            SizedBox(height: 5.0),
            OrderCartItemsImages(),
          ]
        )
      ),
    );
  }

  Widget OrderDateBlock() {
    DateTime? date = order.date_created;
    String dateEmptyString = "Заказ от []";
    String dateString = "Заказ от ${date?.day}.${date?.month}.${date?.year}";
    return Text(
      date == null ?
      dateEmptyString:
      dateString,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      )
    );
  }

  Widget OrderStatusBlock() {
    String orderStatusText = "${order.status.name}";
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
          color: order.status.color.toColorClass(),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0)
          )
      ),
      child: Text(
        orderStatusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500
        ),
      )
    );
  }

  Widget OrderDeliveryMethodBlock() {
    String deliveryMethod = "${order.delivery_method.name}";
    return Text(
      deliveryMethod,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget OrderDeliveryAddressBlock() {
    String deliveryAddress = "${order.delivery_address?.address_display}";
    return Text(
      deliveryAddress,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget OrderCartItemsImages() {
    List<Widget> imagesList = order.cart.line_items.map<Widget>(
      (lineItem) {
        return Container(
          margin: EdgeInsets.only(
            right: 8.0
          ),
          width: 70.0,
          height: 80.0,
          child: Image(
            image: CachedNetworkImageProvider(
              lineItem.product.imgsrc[0],
            )
          ),
        );
      }
    ).toList();
    return Container(
      height: 80.0,
      child: ListView(
        // physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: imagesList,
      ),
    );
  }

}

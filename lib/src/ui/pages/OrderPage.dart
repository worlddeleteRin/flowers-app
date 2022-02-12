import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/SectionTitle.dart';
import 'package:myapp/src/ui/components/common/SimpleErrorTile.dart';
import 'package:myapp/src/ui/components/common/SimpleLoadingTile.dart';
import 'package:myapp/src/utils/datetime.dart';
import 'package:rxdart/rxdart.dart';

class OrderPage extends StatelessWidget {

  final String orderId;

  OrderPage({
    required this.orderId
  });

  refetchOrder() async {
    Order? order = await orderBloc.fetchOrder(orderId);
    print('from order page order is ${order}');
    if (order is Order) {
      currentOrderSink.add(order);
    }
    return order;
  }

  final BehaviorSubject<Order> currentOrderFetcher = BehaviorSubject();
  Stream<Order> get currentOrder => currentOrderFetcher.stream;
  Sink<Order> get currentOrderSink => currentOrderFetcher.sink;
  Order? get currentOrderLastValue => currentOrderFetcher.valueOrNull;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Детали заказа'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 10.0,
          ),
          child: FutureBuilder(
            future: refetchOrder(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return SimpleErrorTile(
                  title: "Error while loading order"
                );
              }
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: currentOrder,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return SimpleErrorTile(
                        title: "Error while loading order"
                      );
                    }
                    if (snapshot.hasData &
                    (snapshot.data is Order)) {
                      Order order = snapshot.data;
                      return OrderPageContent(
                        context: context,
                        order: order
                      );
                    }
                    return Text('no info from orders stream ${snapshot.data}');
                  }
                );
              }
              return SimpleLoadingTile();
            }
          ),
        ),
      )
    );
  }

  Widget OrderPageContent ({
    required BuildContext context,
    required Order order,
  }) {

    return CustomScrollView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics()
      ),
      slivers: [
        MainSliverRefreshControl(
          handleOnRefresh: () async => 
          await refetchOrder(),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              OrderDateBlock(order),
              SizedBox(height: 15.0),
              SectionTitle(
                  context: context,
                  title: "Статус заказа"
              ),
              SizedBox(height: 7.0),
              OrderStatusBlock(order),
              SizedBox(height: 15.0),
              SectionTitle(
                  context: context,
                  title: "Время доставки"
              ),
              SizedBox(height: 7.0),
              OrderDeliveryDatetime(order),
              SizedBox(height: 15.0),
              SectionTitle(
                  context: context,
                  title: "Способ доставки"
              ),
              SizedBox(height: 7.0),
              OrderDeliveryMethodBlock(order),
              SizedBox(height: 15.0),
              SectionTitle(
                  context: context,
                  title: "Адрес доставки"
              ),
              SizedBox(height: 7.0),
              OrderDeliveryAddressBlock(order),
              SizedBox(height: 15.0),
              SectionTitle(
                  context: context,
                  title: "Состав заказа"
              ),
              SizedBox(height: 7.0),
              OrderCartItemsImages(order),
            ]
          )
        )
      ]
    );

  }

  Widget OrderDateBlock(Order order) {
    DateTime? date = order.date_created;
    String dateEmptyString = "Заказ от []";
    String dateString = "Заказ от ${date?.day}.${date?.month}.${date?.year}";
    return Text(
      date == null ?
      dateEmptyString:
      dateString,
      style: TextStyle(
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      )
    );
  }

  Widget OrderStatusBlock(Order order) {
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

  Widget OrderDeliveryMethodBlock(Order order) {
    String deliveryMethod = "${order.delivery_method.name}";
    return Text(
      deliveryMethod,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget OrderDeliveryAddressBlock(Order order) {
    String deliveryAddress = "${order.delivery_address?.address_display}";
    return Text(
      deliveryAddress,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget OrderDeliveryDatetime(Order order) {
    String deliveryDatetime = "--";
    DateTime? delivery_datetime = order.delivery_datetime;
    if (delivery_datetime is DateTime) {
      deliveryDatetime = getNiceDatetime(delivery_datetime);
    }
    return Text(
      deliveryDatetime,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget OrderCartItemsImages(Order order) {
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

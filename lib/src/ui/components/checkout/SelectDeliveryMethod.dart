
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/ui/components/common/SimpleCheckboxListTile.dart';

class SelectDeliveryMethod extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: appBloc.checkoutInfo,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutInfo)) {
          CheckoutInfo checkoutInfo = snapshot.data;
          return SelectDeliveryMethodContent(
            delivery_methods: checkoutInfo.delivery_methods
          );
        }
        return Text('no checkout info ${snapshot.data}');
      }
    );
  }

  Widget SelectDeliveryMethodContent({
    required List<DeliveryMethod> delivery_methods
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String activeId = "";
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          String? active = checkoutFormInfo.delivery_method?.id;
          if (active is String) { activeId = active; };
          List<Widget> deliveryMethodsList = delivery_methods.map<Widget>(
            (deliveryMethod) {
            return Container(
              child: SimpleCheckBoxListTile(
                title: "${deliveryMethod.name}",
                value: deliveryMethod.id == activeId,
                onChanged: (bool? value) {
                  checkoutFormInfo.delivery_method = deliveryMethod;
                  orderBloc.checkoutFormInfo.sink.add(checkoutFormInfo);
                }
              ),
            );
          }).toList();
          return Column(
            children: deliveryMethodsList
          );
        }
        return Text('test content');
      }
    );

  }
}

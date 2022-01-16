
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/ui/components/common/SimpleCheckboxListTile.dart';

class SelectPaymentMethod extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: appBloc.checkoutInfo,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutInfo)) {
          CheckoutInfo checkoutInfo = snapshot.data;
          return SelectPaymentMethodContent(
            payment_methods: checkoutInfo.payment_methods
          );
        }
        return Text('no checkout info ${snapshot.data}');
      }
    );
  }

  Widget SelectPaymentMethodContent({
    required List<PaymentMethod> payment_methods
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String activeId = "";
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          String? active = checkoutFormInfo.payment_method?.id;
          if (active is String) { activeId = active; };
          List<Widget> paymentMethodsList = payment_methods.map<Widget>(
            (paymentMethod) {
            return Container(
              child: SimpleCheckBoxListTile(
                title: "${paymentMethod.name}",
                value: paymentMethod.id == activeId,
                onChanged: (bool? value) {
                  checkoutFormInfo.payment_method = paymentMethod;
                  orderBloc.checkoutFormInfo.sink.add(checkoutFormInfo);
                }
              ),
            );
          }).toList();
          return Column(
            children: paymentMethodsList 
          );
        }
        return Text('test content');
      }
    );

  }
}

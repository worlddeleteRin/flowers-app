
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleErrorTile.dart';
import 'package:rxdart/rxdart.dart';

class PopupOrderDeliveryDatetime extends StatelessWidget { 

  final BehaviorSubject<DateTime> _orderDeliveryDatetime = 
  BehaviorSubject();

  Stream<DateTime> get orderDeliveryDatetime =>
  _orderDeliveryDatetime.stream;

  Sink<DateTime> get orderDeliveryDatetimeSink =>
  _orderDeliveryDatetime.sink;

  DateTime? get orderDeliveryDatetimeLastValue =>
  _orderDeliveryDatetime.valueOrNull;

  closePopup({
    required BuildContext context
  }) {
    Navigator.pop(context);
  }

  saveOrderDeliveryDatetime ({
    required CheckoutFormInfo checkoutFormInfo,
  }) {
    DateTime? orderDeliveryDatetime = orderDeliveryDatetimeLastValue;
    if (!(orderDeliveryDatetime is DateTime)) {return null;};
    checkoutFormInfo.delivery_datetime = orderDeliveryDatetime;
    orderBloc.checkoutFormInfo.sink.add(
      checkoutFormInfo 
    );
  }

  @override
  Widget build(BuildContext context) {

      return PopupOrderDeliveryDatetimeContent(
        context: context
      );
  }

  Widget PopupOrderDeliveryDatetimeContent({
    required BuildContext context
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          DateTime? delivery_datetime = checkoutFormInfo.delivery_datetime;
          DateTime initialValue = DateTime.now();
          if (delivery_datetime is DateTime) {
            orderDeliveryDatetimeSink.add(delivery_datetime);
            initialValue = delivery_datetime;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.0),
              Container(
                height: 300.0,
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  initialDateTime: initialValue,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  onDateTimeChanged: (DateTime newDate) {
                    print('datetime changes, new is ${newDate}');
                    orderDeliveryDatetimeSink.add(newDate);
                  }
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: SimpleBottomActionContainer(
                  handleClick: () {
                    saveOrderDeliveryDatetime(
                      checkoutFormInfo: checkoutFormInfo, 
                    );
                    closePopup(context: context);
                  },
                  buttonTitle: "Выбрать"
                )
              ),
            ]
          );
        }
        return SimpleErrorTile(
          title: "Ошибка при загрузке данных"
        );
      }
    );
  }

}

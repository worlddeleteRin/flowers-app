
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleErrorTile.dart';
import 'package:rxdart/rxdart.dart';

class PopupOrderPostcard extends StatelessWidget { 

  final _orderPostcard = 
  BehaviorSubject<String>.seeded('');

  Stream<String> get orderPostcard =>
  _orderPostcard.stream;

  Sink<String> get orderPostcardSink =>
  _orderPostcard.sink;

  String? get orderPostcardLastValue =>
  _orderPostcard.valueOrNull;

  closePopup({
    required BuildContext context
  }) {
    Navigator.pop(context);
  }

  saveOrderPostcard ({
    required CheckoutFormInfo checkoutFormInfo,
  }) {
    String? orderPostcard = orderPostcardLastValue;
    if (!(orderPostcard is String)) {return null;};
    checkoutFormInfo.postcard_text = orderPostcard;
    orderBloc.checkoutFormInfo.sink.add(
      checkoutFormInfo 
    );
  }

  @override
  Widget build(BuildContext context) {

      return PopupOrderPostcardsContent (
        context: context
      );
  }

  Widget PopupOrderPostcardsContent ({
    required BuildContext context
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          String postcard_text = checkoutFormInfo.postcard_text;
          orderPostcardSink.add(postcard_text);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.0),
              Container( 
                margin: EdgeInsets.symmetric(
                  horizontal: 14.0
                ),
                height: 160.0,
                child: TextFormField(
                  initialValue: checkoutFormInfo.postcard_text,
                  decoration: const InputDecoration(
                    hintText: 'Укажите текст открытки',
                    border: InputBorder.none,
                  ),
                  onChanged: (String? newValue) {
                    if (!(newValue is String)) { return;};
                    orderPostcardSink.add(newValue);
                  },
                  maxLines: 4,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: SimpleBottomActionContainer(
                  handleClick: () {
                    saveOrderPostcard(
                      checkoutFormInfo: checkoutFormInfo, 
                    );
                    closePopup(context: context);
                  },
                  buttonTitle: "Готово"
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

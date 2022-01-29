
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:rxdart/rxdart.dart';

class PopupAddOrderComments extends StatelessWidget { 

  final _orderComment = 
  BehaviorSubject<String>.seeded('');

  Stream<String> get orderComment =>
  _orderComment.stream;

  Sink<String> get orderCommentSink =>
  _orderComment.sink;

  String? get orderCommentLastValue =>
  _orderComment.valueOrNull;

  closePopup({
    required BuildContext context
  }) {
    Navigator.pop(context);
  }

  saveOrderComment ({
    required CheckoutFormInfo checkoutFormInfo,
  }) {
    String? orderComment = orderCommentLastValue;
    if (!(orderComment is String)) {return null;};
    checkoutFormInfo.custom_message = orderComment;
    orderBloc.checkoutFormInfo.sink.add(
      checkoutFormInfo 
    );
  }

  @override
  Widget build(BuildContext context) {

      return PopupAddOrderCommentsContent (
        context: context
      );
  }

  Widget PopupAddOrderCommentsContent ({
    required BuildContext context
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;

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
                  initialValue: checkoutFormInfo.custom_message,
                  decoration: const InputDecoration(
                    hintText: 'Укажите комментарий к заказу',
                    border: InputBorder.none,
                  ),
                  onChanged: (String? newValue) {
                    if (!(newValue is String)) { return;};
                    orderCommentSink.add(newValue);
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
                    saveOrderComment(
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
        return Text('test content');
      }
    );
  }

}

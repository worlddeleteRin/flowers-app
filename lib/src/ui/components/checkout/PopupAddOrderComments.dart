
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleCheckboxListTile.dart';
import 'package:myapp/src/ui/pages/CreateUserAddress.dart';

class PopupAddOrderComments extends StatelessWidget { 

  closePopup({
    required BuildContext context
  }) {
    return null;
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
                height: 180.0,
                child: CommentInput(),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: SimpleBottomActionContainer(
                  handleClick: () => closePopup(
                    context: context,
                  ),
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

  Widget CommentInput() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Укажите комментарий к заказу',
        border: InputBorder.none,
      ),
      maxLines: 4,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/appbar/PhoneBadge.dart';
import 'package:myapp/src/ui/components/checkout/PopupAddOrderComments.dart';
import 'package:myapp/src/ui/components/checkout/PopupOrderDeliveryDatetime.dart';
import 'package:myapp/src/ui/components/checkout/PopupOrderPostcard.dart';
import 'package:myapp/src/ui/components/checkout/SelectDeliveryAddress.dart';
import 'package:myapp/src/ui/components/checkout/SelectDeliveryMethod.dart';
import 'package:myapp/src/ui/components/checkout/SelectPaymentMethod.dart';
import 'package:myapp/src/ui/components/checkout/SelectRecipient.dart';
import 'package:myapp/src/ui/components/common/DraggableBaseSelectBottomSheet.dart';
import 'package:myapp/src/ui/components/common/SelectableListTile.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleErrorTile.dart';
import 'package:myapp/src/utils/datetime.dart';

class CheckoutPage extends StatelessWidget {

  String get_recipient_type_label (String type, RecipientPerson recipientPerson) {
    if (type == RecipientTypes.user) {
      return RecipientTypes.get_type_label(type);
    }
    if (type == RecipientTypes.other_person) {
      return "${recipientPerson.name} ${recipientPerson.phone}";
    }
    return "Выбрать";
  }

  createOrder({
    required BuildContext context
  }) async {
    bool isSuccess = await orderBloc.createOrder();
    if (isSuccess) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('заказ создан')
        ),
      );
    }
  }

  openSelectBottomSheet({
    required BuildContext context,
    required StatelessWidget contentWidget,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
      ),
      builder: (BuildContext context) {
        return DraggableBaseSelectBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              // padding: MediaQuery.of(context).viewInsets,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: contentWidget,
            );
            // contentWidget;
          },
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {

    if (!appBloc.checkoutInfoFetched) {
      appBloc.fetchCheckoutInfo();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Оформление заказа"),
        actions: [
            PhoneBadge(context: context)   
        ]
      ),
      body: SafeArea(
        child: CheckoutPageContent(
          context: context
        )
      ),
    );
  }

  Widget CheckoutPageContent({
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: Column(
        children: [
          Expanded(
            child: CheckoutPageBody(
              context: context
            )
          ),
          StreamBuilder(
            stream: orderBloc.checkoutFormInfoStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &
              (snapshot.data is CheckoutFormInfo)) {
                  CheckoutFormInfo checkoutFormInfo = snapshot.data;
                  return SimpleBottomActionContainer(
                    disabled: !checkoutFormInfo.isValid(),
                    handleClick: () async => 
                    await createOrder(
                      context: context
                    ), 
                    buttonTitle: "Оформить заказ"
                  );
              }
              return SimpleErrorTile(
                  title: "Cant load container"
              );
            }           
          )

        ]
      ),
    );
  }

  Widget CheckoutPageBody({
    required BuildContext context
  }) {
    return Container(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: orderBloc.checkoutFormInfoStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &
                (snapshot.data is CheckoutFormInfo)) {
                  CheckoutFormInfo checkoutFormInfo = snapshot.data;
                  return CheckoutSelectItems(
                    context: context,
                    checkoutFormInfo: checkoutFormInfo
                  );
                }
                return Text('checkout info');

              }
            ),
          ),
        ]
      )
    );
  }

  Widget CheckoutSelectItems({
    required BuildContext context,
    required CheckoutFormInfo checkoutFormInfo,
  }) {
    String? delivery_method = checkoutFormInfo.delivery_method?.name;
    String? payment_method = checkoutFormInfo.payment_method?.name;
    String? delivery_address = checkoutFormInfo.delivery_address?.address_display;
    String order_comment = checkoutFormInfo.custom_message;
    String postcard_text = checkoutFormInfo.postcard_text;
    String recipient_type = checkoutFormInfo.recipient_type;
    DateTime? delivery_datetime = checkoutFormInfo.delivery_datetime;
    RecipientPerson recipient_person = checkoutFormInfo.recipient_person;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: SelectRecipient(),
          ), 
          title: "Получатель",
          trailingBody: Text(
            get_recipient_type_label(
              recipient_type,
              recipient_person
            ),
            textAlign: TextAlign.end,
          )
        ),
        // delivery method
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: SelectDeliveryMethod(),
          ), 
          title: "Способ доставки",
          trailingBody: Text(
            delivery_method == null ?
            'Выбрать':
            '$delivery_method',
            textAlign: TextAlign.end,
          )
        ),
        // eof delivery method
        // delivery date
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: PopupOrderDeliveryDatetime()
          ),
          title: "Время доставки",
          trailingBody: Text(
            delivery_datetime == null ?
            'Выбрать':
            '${getNiceDatetime(delivery_datetime)}',
            textAlign: TextAlign.end,
          )
        ),
        // eof delivery date
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: SelectDeliveryAddress(),
          ), 
          title: "Адрес доставки",
          trailingBody: Text(
            delivery_address == null ? 
            'Выбрать':
            '$delivery_address',
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          )
        ),
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: PopupAddOrderComments(),
          ), 
          title: "Заметки к заказу",
          trailingBody: Text(
            order_comment.length == 0 ?    
            'Добавить':
            '$order_comment',
            maxLines: 1,
            textAlign: TextAlign.end,
          )
        ),
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: PopupOrderPostcard(),
          ), 
          title: "Текст к открытке",
          trailingBody: Text(
            postcard_text.length == 0 ?    
            'Добавить':
            '$postcard_text',
            maxLines: 1,
            textAlign: TextAlign.end,
          )
        ),
        SizedBox(height: 10.0),
        Text(
          "Оплата",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          )
        ),
        SelectableListTile(
          handleTap: () => openSelectBottomSheet(
            context: context,
            contentWidget: SelectPaymentMethod(),
          ), 
          title: "Способ оплаты",
          trailingBody: Text(
            payment_method == null ?
            'Выбрать':
            '$payment_method',
            textAlign: TextAlign.end,
          )
        ),
      ]
    );
  }

}

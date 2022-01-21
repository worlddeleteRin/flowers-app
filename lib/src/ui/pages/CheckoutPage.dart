import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/checkout/SelectDeliveryAddress.dart';
import 'package:myapp/src/ui/components/checkout/SelectDeliveryMethod.dart';
import 'package:myapp/src/ui/components/checkout/SelectPaymentMethod.dart';
import 'package:myapp/src/ui/components/common/DraggableBaseSelectBottomSheet.dart';
import 'package:myapp/src/ui/components/common/SelectableListTile.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';

class CheckoutPage extends StatelessWidget {

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
      builder: (BuildContext context) {
        return DraggableBaseSelectBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return contentWidget;
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
          SimpleBottomActionContainer(
            handleClick: () async => 
            await createOrder(
              context: context
            ), 
            buttonTitle: "Оформить заказ"
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      /*
        SelectableListTile(
          handleTap: () => {}, 
          title: "Получатель",
          trailingBody: Text('Заказ для меня')
        ),
      */
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
        /*
        SelectableListTile(
          handleTap: () => {}, 
          title: "Время доставки",
          trailingBody: Text('Выбрать')
        ),
        */
        SelectableListTile(
          handleTap: () => {}, 
          title: "Заметки к заказу",
          trailingBody: Text(
            'Добавить',
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

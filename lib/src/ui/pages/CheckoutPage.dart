import 'package:flutter/material.dart';
import 'package:myapp/src/ui/components/common/SelectableListTile.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Оформление заказа"),
        ),
        body: CheckoutPageContent(
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
          CheckoutBottomSheet(
            handleClick: () => {},
          ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableListTile(
                  handleTap: () => {}, 
                  title: "Получатель",
                  trailingBody: Text('Заказ для меня')
                ),
                SelectableListTile(
                  handleTap: () => {}, 
                  title: "Адрес доставки",
                  trailingBody: Text('Выбрать')
                ),
                SelectableListTile(
                  handleTap: () => {}, 
                  title: "Время доставки",
                  trailingBody: Text('Выбрать')
                ),
                SelectableListTile(
                  handleTap: () => {}, 
                  title: "Заметки к заказу",
                  trailingBody: Text('Добавить')
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
                  handleTap: () => {}, 
                  title: "Способ оплаты",
                  trailingBody: Text('Выбрать')
                ),
              ]
            ),
          ),
        ]
      )
    );
  }

  Widget CheckoutBottomSheet({
    required handleClick,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.0,
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ElevatedButton(
              onPressed: () => handleClick(),
              child: Text(
                "Оформить заказ",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )
              )
            ),
          )
        ),
      ]
    );
  }

}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/SimpleCheckboxListTile.dart';

class SelectRecipient extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return SelectRecipientContent();
  }

  Widget SelectRecipientContent() {
    List<Map<String,String>> recipientVariants = [
      {"name" : RecipientTypes.user },
      {"name" : RecipientTypes.other_person }
    ];
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          String activeType = checkoutFormInfo.recipient_type;
          List<Widget> paymentMethodsList = recipientVariants.map<Widget>(
            (type) {
            String name = "";
            String? currentType = type["name"];
            if (currentType is String) {
              name = currentType;
            }
            return Container(
              child: SimpleCheckBoxListTile(
                title: RecipientTypes.get_type_label(name),
                value: name == activeType,
                onChanged: (bool? value) {
                  checkoutFormInfo.recipient_type = name;
                  orderBloc.checkoutFormInfo.sink.add(checkoutFormInfo);
                }
              ),
            );
          }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Column(
                children: paymentMethodsList 
              ),
              SizedBox(height: 10.0),
              if (checkoutFormInfo.recipient_type == RecipientTypes.other_person)
                RecipientFormBlock(
                  checkoutFormInfo: checkoutFormInfo
                )
            ]
          );
        }
        return Text('test content');
      }
    );
  }
  
  Widget RecipientFormBlock ({
    required CheckoutFormInfo checkoutFormInfo
  }) {
    return Container( 
      margin: EdgeInsets.symmetric(
        horizontal: 14.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Имя получателя",
              border: InputBorder.none,
              icon: Icon(
                Icons.account_box,
                size: 25.0,
                color: Colors.black,
              ),
            ),
            onChanged: (String? value) {
              if (!(value is String)) { return;};
              checkoutFormInfo.recipient_person.name = value;
              orderBloc.checkoutFormInfo.sink.add(
                checkoutFormInfo
              );
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "7978 111 11 11",
              border: InputBorder.none,
              icon: Icon(
                Icons.phone_iphone,
                size: 25.0,
                color: Colors.black,
              ),
            ),
            autofillHints: [AutofillHints.telephoneNumber],
            maxLength: 11,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          )
        ]
      ),
    );
  }

}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleCheckboxListTile.dart';
import 'package:myapp/src/ui/pages/CreateUserAddress.dart';

class SelectDeliveryAddress extends StatelessWidget { 

  goCreateAddressPage({
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return CreateUserAddress();
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!(userBloc.userDeliveryAddressesFetched)) {
      userBloc.fetchUserDeliveryAddresses();
    }

    return StreamBuilder(
      stream: userBloc.userDeliveryAddresses,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is List<UserDeliveryAddress>)) {
          List<UserDeliveryAddress> userAddresses = snapshot.data;
          return SelectDeliveryAddressContent(
            userAddresses: userAddresses,
          );
        }
        return Text('no checkout info ${snapshot.data}');
      }
    );
  }

  Widget SelectDeliveryAddressContent({
    required List<UserDeliveryAddress> userAddresses 
  }) {
    return StreamBuilder(
      stream: orderBloc.checkoutFormInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String activeId = "";
        if (snapshot.hasData &
        (snapshot.data is CheckoutFormInfo)) {
          CheckoutFormInfo checkoutFormInfo = snapshot.data;
          String? active = checkoutFormInfo.delivery_address?.id;
          if (active is String) { activeId = active; };
          List<Widget> deliveryAddressesList = userAddresses.map<Widget>(
            (userAddress) {
            return Container(
              child: SimpleCheckBoxListTile(
                title: "${userAddress.address_display}",
                value: userAddress.id == activeId,
                onChanged: (bool? value) {
                  checkoutFormInfo.delivery_address = userAddress;
                  orderBloc.checkoutFormInfo.sink.add(checkoutFormInfo);
                }
              ),
            );
          }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.0),
              Container( 
                height: 150.0,
                child: ListView(
                  children: deliveryAddressesList
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: SimpleBottomActionContainer(
                  handleClick: () => goCreateAddressPage(
                    context: context,
                  ),
                  buttonTitle: "Добавить адрес"
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

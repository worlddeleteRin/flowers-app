import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/common/SimpleMenuTile.dart';
import 'package:myapp/src/ui/pages/CreateUserAddress.dart';
import 'package:myapp/src/ui/pages/EditUserAddress.dart';

class ProfileDeliveryAddresses extends StatelessWidget {
  goCreateAddressPage({
    required BuildContext context
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

  goEditAddressPage({
    required BuildContext context,
    required UserDeliveryAddress address
  }) {
     Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return EditUserAddress(
            address: address
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!userBloc.userDeliveryAddressesFetched) {
      userBloc.fetchUserDeliveryAddresses();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Мои адреса")
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: userBloc.userDeliveryAddresses,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &
            (snapshot.data is List<UserDeliveryAddress>)) {
              List<UserDeliveryAddress> userDeliveryAddresses = 
              snapshot.data;
              return ProfileDeliveryAddressesContent(
                context: context,
                userDeliveryAddresses: userDeliveryAddresses
              );
            }
            return Text('no user addresses info');
          }
        )
      ),
    );
  }

  Widget ProfileDeliveryAddressesContent({
    required BuildContext context,
    required List<UserDeliveryAddress> userDeliveryAddresses,
  }) {

    return Container(
     margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
     child: Column(
      children: [
          Expanded(
             child: CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                MainSliverRefreshControl(
                  handleOnRefresh: () async => 
                  await userBloc.fetchUserDeliveryAddresses()
                ),
                SliverToBoxAdapter(
                  child: userDeliveryAddresses.length > 0 ?
                  AddressesList(
                    userDeliveryAddresses: userDeliveryAddresses,
                  ):
                  Text('Вы еще не добавили ни одного адреса')
                ),
              ]
            ),
          ),
          SimpleBottomActionContainer(
            handleClick: () => goCreateAddressPage(
              context: context
            ),
            buttonTitle: "Добавить адрес"
          ),
        ],
      ),
    );

  }

  Widget AddressesList({
    required List<UserDeliveryAddress> userDeliveryAddresses,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userDeliveryAddresses.length,
      itemBuilder: (BuildContext context, int index) {
        UserDeliveryAddress address = userDeliveryAddresses[index];
        return Container(
          margin: EdgeInsets.only(
            top: 10.0,
          ),
          child: SimpleMenuTile(
            title: "${address.city} ${address.address_display}",
            handleTap: () {
              print('city is ${address.city}');
              goEditAddressPage(
                context: context,
                address: address,
              );
            },
          ),
        );
      }
    );
  }

}

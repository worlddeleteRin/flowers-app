import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/SimpleMenuTile.dart';

class ProfileDeliveryAddresses extends StatelessWidget {
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
            child: AddressesList(
              userDeliveryAddresses: userDeliveryAddresses,
            )
          ),
        ]
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
        return SimpleMenuTile(
          title: "${address.address_display}",
          handleTap: () => {},
        );
      }
    );
  }

}

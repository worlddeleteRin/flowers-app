import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/orders/UserOrderCard.dart';

class ProfileOrdersPage extends StatelessWidget {

  refreshUserOrders () async {
    await userBloc.fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    print('user orders fetched are: ${userBloc.userOrdersFetched}');
    if (!(userBloc.userOrdersFetched)) {
      userBloc.fetchUserOrders();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Мои заказы'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 10.0,
          ),
          child: StreamBuilder(
            stream: userBloc.userOrders,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('error occurred');
              }
              if (snapshot.hasData &
              (snapshot.data is List<Order>)) {
                List<Order> ordersList = snapshot.data;
                return ProfileOrdersPageContent(
                  context: context,
                  orders: ordersList
                );
              }
              return Text('no info from orders stream');
            }
          ),
        ),
      )
    );
  }

  Widget ProfileOrdersPageContent({
    required BuildContext context,
    required List<Order> orders,
  }) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics()
      ),
      slivers: [
        MainSliverRefreshControl(
          handleOnRefresh: () async => 
          await refreshUserOrders(),
        ),
        SliverToBoxAdapter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index)  {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 7.0,
                ),
                child: UserOrderCard(
                  order: orders[index] 
                ),
              );
            }
          ),
        )
      ]
    );

  }

}

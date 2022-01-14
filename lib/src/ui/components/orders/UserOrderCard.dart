import 'package:flutter/material.dart';
import 'package:myapp/src/models/orders_model.dart';

class UserOrderCard extends StatelessWidget {
  final Order order;
  UserOrderCard({
    required this.order
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('${order.status.name}'),
          Text('${order.payment_method.name}'),
          Text('${order.delivery_method.name}'),
          Text('${order.cart.total_amount}'),
        ]
      )
    );
  }
}

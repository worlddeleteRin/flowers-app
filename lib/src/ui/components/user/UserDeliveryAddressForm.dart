import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';

class UserDeliveryAddressForm extends StatelessWidget {
  final UserDeliveryAddress address;
  final GlobalKey<FormState> formKey;
  final Sink<UserDeliveryAddress> addressSink;
  UserDeliveryAddressForm({
    required this.address,
    required this.formKey,
    required this.addressSink,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text('form is here'),
            Text('addresss city is ${address.city}'),
            // city input
            TextFormField(
              initialValue: address.city,  
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
              onChanged: (value) {
                address.city = value;
                addressSink.add(
                  address
                );
              },
            ),
            // street input
            TextFormField(
              initialValue: address.street,  
            ),
            // submit button
            ElevatedButton(
              onPressed: () {
                formKey.currentState!.validate();
              },
              child: Text('validate form')
            ),
          ]
        )
      )
    );
  }

}

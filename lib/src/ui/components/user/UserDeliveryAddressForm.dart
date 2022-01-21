import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';

class UserDeliveryAddressForm extends StatelessWidget {
  final UserDeliveryAddress address;
  final GlobalKey<FormState> formKey;
  final Sink<UserDeliveryAddress> addressSink;
  final bool showRemove;
  final Function? handleRemove;
  UserDeliveryAddressForm({
    required this.address,
    required this.formKey,
    required this.addressSink,
    this.showRemove = false,
    this.handleRemove,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // city input
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Город',
              ),
              initialValue: address.city,  
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название города';
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
              decoration: const InputDecoration(
                hintText: 'Улица',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название улицы';
                }
                return null;
              },
              onChanged: (value) {
                address.street = value;
                addressSink.add(
                  address
                );
              },
            ),

            // house_number  input
            TextFormField(
              initialValue: address.house_number,  
              decoration: const InputDecoration(
                hintText: 'Номер дома',
              ),
              onChanged: (value) {
                address.house_number = value;
                addressSink.add(
                  address
                );
              },
            ),

            // flat_number input
            TextFormField(
              initialValue: address.flat_number,  
              decoration: const InputDecoration(
                hintText: 'Номер квартиры',
              ),
              onChanged: (value) {
                address.flat_number = value;
                addressSink.add(
                  address
                );
              },
            ),

            // flat_number input
            TextFormField(
              initialValue: address.floor_number,  
              decoration: const InputDecoration(
                hintText: 'Этаж',
              ),
              onChanged: (value) {
                address.floor_number = value;
                addressSink.add(
                  address
                );
              },
            ),

            // comment input
            TextFormField(
              initialValue: address.comment,  
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Комментарий к заказу',
              ),
              onChanged: (value) {
                address.floor_number = value;
                addressSink.add(
                  address
                );
              },
            ),

            // show remove
            if (showRemove)
              RemoveContainer()
          ]
        )
      )
    );
  }

  Widget RemoveContainer() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.0
      ),
      child: ElevatedButton(
        onPressed: () {
          this.handleRemove!();
        },
        child: Text('Удалить адрес'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(Colors.red),
        )
      ),
    );
  }

}

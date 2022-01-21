import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:myapp/src/ui/components/user/UserDeliveryAddressForm.dart';
import 'package:rxdart/rxdart.dart';

class CreateUserAddress extends StatelessWidget {
/*
  @override
  _EditUserAddressState createState() => _EditUserAddressState();
}
*/
  bool validateFormInput () {
    FormState? currentState = _formKey.currentState;
    if (!(currentState is FormState)) {return false;};
    if (currentState.validate()) {return true;}
    return false;
  }
  saveUserAddress ({
    required BuildContext context
  }) async {
    UserDeliveryAddress? newAddress = this.currentUserAddressLastValue;
    bool isFormValid = validateFormInput();
    if (!isFormValid) {return null;};
    if (!(newAddress is UserDeliveryAddress)) { return null;};
    print('new address is ${newAddress.toJson()}');
    bool isSuccess = await userBloc.createUserDeliveryAddress(
      address: newAddress 
    );
    if (isSuccess) {
      userBloc.fetchUserDeliveryAddresses();
      Navigator.of(context).pop();
    }
  }

// class _EditUserAddressState extends State<EditUserAddress> {
  final _formKey = GlobalKey<FormState>();

  final _currentUserAddress = 
  BehaviorSubject<UserDeliveryAddress>();

  Stream<UserDeliveryAddress> get currentUserAddress =>
  _currentUserAddress.stream;

  Sink<UserDeliveryAddress> get currentUserAddressSink =>
  _currentUserAddress.sink;

  UserDeliveryAddress? get currentUserAddressLastValue =>
  _currentUserAddress.valueOrNull;


  @override  
  Widget build(BuildContext context) {
    UserDeliveryAddress newAddress = UserDeliveryAddress();
    currentUserAddressSink.add(newAddress);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Создание адреса')
      ),
      body: StreamBuilder(
        stream: currentUserAddress,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &
          (snapshot.data is UserDeliveryAddress)) {
            UserDeliveryAddress address = snapshot.data;
            return EditUserAddressContent(
              context: context,
              address: address,
            );
          }
          return Text('no data');
        }
      ),
    );
  }

  Widget EditUserAddressContent({
    required BuildContext context,
    required UserDeliveryAddress address,
  }) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 14.0,
      vertical: 10.0,
    ),
    child: Column(
        children: [
          Expanded(
            child: UserDeliveryAddressForm(
              formKey: _formKey, 
              address: address,
              addressSink: currentUserAddressSink,
            ),
          ),
          SimpleBottomActionContainer(
            handleClick: () => saveUserAddress(
              context: context
            ),
            buttonTitle: "Сохранить"
          ),
        ],
      ),
    );
  }
}

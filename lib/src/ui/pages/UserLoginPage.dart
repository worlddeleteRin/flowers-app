import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('login page')
        ),
        body: LoginPageContent(context: context)
      ),
    );
  }

  Widget LoginPageContent({
    required BuildContext context,
  }) {
    return Column(
      children: [
        StreamBuilder(
          stream: userBloc.loginFormUsernameStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            String itemValue = "somevaluehere";
            if (snapshot.hasData && 
            (snapshot.data is String)) {
              itemValue = snapshot.data; 
              print('item value is $itemValue');
            }
            return TextFormField(
              initialValue: itemValue,
              onChanged: (value) {
                userBloc.loginFormUsername.sink.add(value);  
              },
            );
          }
        ),
        TextFormField(
        ),
        ElevatedButton(
          onPressed: () => {},
          child: Text('login user')
        ),

        StreamBuilder(
          stream: userBloc.user,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && 
            (snapshot.data is User)) {
              User user = snapshot.data;
              return Text(
                "user is ${user.name}, ${user.username}"
              );
            }
            return Text('no user data');
          }
        ),
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/pages/UserAccountPage.dart';
import 'package:myapp/src/ui/pages/UserLoginPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.user,
      builder: (BuildContext conext, AsyncSnapshot snapshot) {
        if (snapshot.hasData &
        (snapshot.data is User)) {
          User user = snapshot.data;
          return UserAccountPage(
            user: user
          );
        }
        return LoginPage();
      }
    );
  }
}

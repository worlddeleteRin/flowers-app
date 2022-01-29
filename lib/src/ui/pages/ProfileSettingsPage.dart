import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/SimpleBottomActionContainer.dart';
import 'package:rxdart/subjects.dart';

class ProfileSettingsPage extends StatelessWidget {

  final BehaviorSubject<User> _currentUser = BehaviorSubject<User>();
  Stream<User> get currentUser => _currentUser.stream;
  Sink<User> get currentUserSink => _currentUser.sink;
  User? get currentUserLastValue => _currentUser.valueOrNull;

  saveUser ({
    required BuildContext context
  }) async {
    User? currentUser = currentUserLastValue;
    if (!(currentUser is User)) {return null;};
    bool isSuccess = await userBloc.updateUserMe(currentUser: currentUser);
    if (isSuccess) {
      print('user updated');
      showSnackbar(context: context);
      Navigator.of(context).pop();
    }
    print('need to save user ${currentUser.toJson()}');
  }

  showSnackbar ({required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Text('Профиль сохранен'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Настройки профиля"),
        ),
        body: StreamBuilder(
          stream: userBloc.user,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('you are not logged in');
            }
            if (snapshot.hasData &
            (snapshot.data is User)) {
              User user = snapshot.data;
              User userCopy = User.fromJson(user.toJson());
              _currentUser.sink.add(userCopy);
              User? currentUser = currentUserLastValue;
              if (currentUser is User)  {
                return ProfileSettingsPageContent(
                  context: context,
                  user: currentUser 
                );
              } else {
                return Text('loading...');
              }
            }
            return Text('loading...');
          }
        )
      )
    );
  }

  ProfileSettingsPageContent({
    required BuildContext context,
    required User user,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 14.0
              ),
              child: Column(
                children: [
                  InputUsernameBlock(
                    user: user
                  ),
                  SizedBox(height: 10.0),
                  InputNameBlock(
                    user: user
                  ),
                  SizedBox(height: 10.0),
                  InputEmailBlock(
                    user: user
                  ),
                  SizedBox(height: 10.0),
                ]
              )
            )
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 14.0
          ),
          child: SimpleBottomActionContainer(
            handleClick: () => saveUser(
              context: context
            ),
            buttonTitle: "Сохранить"
          )
        ),
      ],
    );
  }

  InputUsernameBlock({
    required User user
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "7978 111 11 11",
        // border: InputBorder.none,
        labelText: "Номер телефона",
        icon: Icon(
          Icons.phone_iphone,
          size: 25.0,
          color: Colors.black,
        ),
      ),
      initialValue: user.username,
      enabled: false,
      onChanged: (String? value) {
        if (!(value is String)) { return;};
        /*
        checkoutFormInfo.recipient_person.phone = value;
        orderBloc.checkoutFormInfo.sink.add(
          checkoutFormInfo
        );
        */
      },
    );
  }

  InputNameBlock ({
    required User user
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Ваше Имя",
        labelText: "Имя",
        icon: Icon(
          Icons.account_circle_rounded,
          size: 25.0,
          color: Colors.black,
        ),
      ),
      initialValue: user.name,
      onChanged: (String? value) {
        if (!(value is String)) { return;};
        user.name = value;
        _currentUser.sink.add(user);
      },
    );
  }

  InputEmailBlock ({
    required User user
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Ваша почта",
        labelText: "Почта",
        icon: Icon(
          Icons.email_rounded,
          size: 25.0,
          color: Colors.black,
        ),
      ),
      initialValue: user.email,
      onChanged: (String? value) {
        if (!(value is String)) { return;};
        user.email = value;
        _currentUser.sink.add(user);
      },
    );
  }

}

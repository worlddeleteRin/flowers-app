import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/TitleBig.dart';
import 'package:myapp/src/ui/pages/CallOtpPage.dart';

class LoginPage extends StatelessWidget {
  final bool showAppBar; 
  LoginPage({
    this.showAppBar = false
  });

  loginUser ({
    required BuildContext context,
  }) async {
    bool is_success = await userBloc.loginUser();
    if (is_success) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) {
            return CallOtpPage();
          }
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            showAppBar ?
            "Авторизация":
            ""
          )
        ),
        backgroundColor: Colors.white,
        /*
        appBar: AppBar(
          title: Text('Авторизация')
        ),
        */
        body: SafeArea(
          child: LoginPageContent(context: context)
        ),
    );
  }

  Widget LoginPageContent({
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: Column(
        children: [
          
          Expanded(
            child: LoginFormContent()
          ),

          BottomSection(
            handleClick: () async => await loginUser(
              context: context
            ),
          )

        ]
      ),
    );
  }

  Widget LoginFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleBig(
          title: "Вход в аккаунт"
        ),
        SizedBox(height: 10.0),
        Text(
          "Введите Ваш номер телефона. Вам позвонит случайный номер, последние 4 цифры которого необходимо будет указать в качестве кода",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          )
        ),
        SizedBox(height: 15.0),
        LoginInputBuilder(),
      ]
    );
  }
  // Widget Login
  Widget LoginInputBuilder() {
    return StreamBuilder(
      stream: userBloc.userLoginForm,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String itemValue = "7";
        if (snapshot.hasData && 
        (snapshot.data is UserLoginForm)) {
          UserLoginForm userLoginForm = snapshot.data;
          itemValue = userLoginForm.username; 
          print('item value is ${userLoginForm.username}');
          return TextFormField(
            autofocus: true,
            autofillHints: [AutofillHints.telephoneNumber],
            maxLength: 11,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hintText: "7978 111 11 11",
              border: InputBorder.none,
              icon: Icon(
                Icons.add,
                size: 33.0,
                color: Colors.black,
              ),
            ),
            style: TextStyle(
              fontSize: 33.0,
            ), 
            initialValue: itemValue,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              userLoginForm.username = value;
              userBloc.userLoginForm.sink.add(userLoginForm);  
            },
          );
        }
        return TextFormField(
          initialValue: itemValue,
        );
      }
    );
  }

  Widget BottomSection({
    required Function handleClick 
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () => handleClick(),
              child: Text(
                "Продолжить",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )
              )
            ),
          )
        ),
      ]
    );
  }

}

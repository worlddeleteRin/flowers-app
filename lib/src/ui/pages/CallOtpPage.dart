import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:myapp/src/ui/components/common/TitleBig.dart';

class CallOtpPage extends StatelessWidget {

  loginForAccessToken ({
    required BuildContext context
  }) async {
    bool is_success = await userBloc.loginForAccessToken();
    if (is_success) {
      Navigator.of(context).popUntil((Route route) => route.isFirst);
    }
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CallOtpPageContent(context: context)
      ),
    );
  }

  Widget CallOtpPageContent({
    required BuildContext context
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
            handleClick: () async => await loginForAccessToken(
              context: context
            )
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
          title: "Код авторизации"
        ),
        SizedBox(height: 10.0),
        Text(
          "Введите последние 4 цифры номера телефона, который Вам позвонил",
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

  Widget LoginInputBuilder() {
    return StreamBuilder(
      stream: userBloc.userLoginForm,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String itemValue = "";
        if (snapshot.hasData && 
        (snapshot.data is UserLoginForm)) {
          UserLoginForm userLoginForm = snapshot.data;
          itemValue = userLoginForm.otp; 
          print('item value is ${userLoginForm.otp}');
          return TextFormField(
            autofocus: true,
            // autofillHints: [AutofillHints.telephoneNumber],
            decoration: InputDecoration(
              hintText: "****",
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 38.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 10.0,
            ), 
            maxLength: 4,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            initialValue: itemValue,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userLoginForm.otp = value;
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
                "Подтвердить",
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

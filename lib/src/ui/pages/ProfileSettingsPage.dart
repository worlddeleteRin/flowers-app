import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Настройки профиля"),
        ),
        body: ProfileSettingsPageContent(
          context: context
        )
      )
    );
  }

  ProfileSettingsPageContent({
    required BuildContext context,
  }) {
    return Center(
      child: Text("profile settings page is here")
    );
  }

}

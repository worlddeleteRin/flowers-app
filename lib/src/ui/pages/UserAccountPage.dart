import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/user_model.dart';
// import 'package:myapp/src/ui/components/common/SelectableListTile.dart';
import 'package:myapp/src/ui/components/common/SimpleMenuTile.dart';
import 'package:myapp/src/ui/components/common/TitleBig.dart';
import 'package:myapp/src/ui/components/user/ProfileDeliveryAddresses.dart';
import 'package:myapp/src/ui/pages/ProfileOrdersPage.dart';
import 'package:myapp/src/ui/pages/ProfileSettingsPage.dart';

class UserAccountPage extends StatelessWidget {
  final User user;
  UserAccountPage({
    required this.user
  });

  goPage({
    required BuildContext context,
    required StatelessWidget page
  }) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return page;
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) { 
    return SafeArea(
      child: Scaffold(
        body: UserAccountPageContent(
          context: context,
        ),
      )
    );
  }

  Widget UserAccountPageContent({
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 17.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileMainHeader(context: context),
          SizedBox(height: 30.0),
          ProfileMainMenu(context: context),
        ]
      ),
    );
  }

  Widget ProfileMainHeader({
    required BuildContext context
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBig(
          title: "Мой профиль",
          fontSize: 27.0,
        ),
        SizedBox(height: 10.0),
        TitleBig(
          title: "+${user.username}",
          fontSize: 18.0,
        ),
        SizedBox(height: 10.0),
        BonusesRow(), 
      ]
    );
  }

  Widget BonusesRow() {
    return Row(
      children: [
        Wrap(
          spacing: 3.0,
          direction: Axis.horizontal,
           crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.stars,
              color: Colors.red,
            ),
            TitleBig(
              title: "${user.bonuses}",
              fontSize: 20.0,
            ),
            Text("бонусов")
          ]
        ),
        SizedBox(width: 15.0),
        Wrap(
          spacing: 3.0,
          direction: Axis.horizontal,
           crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.arrow_circle_up,
              color: Colors.red,
            ),
            TitleBig(
              title: "${user.bonuses_rank}",
              fontSize: 20.0,
            ),
            Text("ранг")
          ]
        ),
      ]
    );
  }

  Widget ProfileMainMenu({
    required BuildContext context,
  }) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        SimpleMenuTile(
          handleTap: () => goPage(
            context: context,
            page: ProfileSettingsPage(),
          ),
          title: "Настройки",
        ),
        SimpleMenuTile(
          handleTap: () => goPage(
            context: context,
            page: ProfileOrdersPage(),
          ),
          title: "Заказы",
        ),
        SimpleMenuTile(
          handleTap: () => goPage(
            context: context,
            page: ProfileDeliveryAddresses()
          ),
          title: "Мои адреса",
        ),
        SimpleMenuTile(
          handleTap: () => userBloc.logoutUser(),
          title: "Выйти из аккаунта",
        ),
      ]
    );
  }

}


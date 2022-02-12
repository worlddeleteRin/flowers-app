import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/SimpleErrorTile.dart';
import 'package:myapp/src/ui/components/common/SimpleMenuTile.dart';
import 'package:myapp/src/utils/urls.dart';

Widget ContactsList ({
  required BuildContext context
}) {

  return StreamBuilder(
    stream: appBloc.commonInfo,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasError) {
        return SimpleErrorTile(
          title: "Ошибка во время загрузка контактов"
        );
      }
      if (snapshot.hasData && 
      (snapshot.data is CommonInfo)) {
        CommonInfo commonInfo = snapshot.data;
        return ContactsBlock(
          context: context,
          commonInfo: commonInfo
        );
      }
      return Text('loading...');
    }
  );

}

Widget ContactsBlock({
  required BuildContext context,
  required CommonInfo commonInfo
}) {
  List<Widget> contactWidgets = [];
  Widget contactsPhone = SimpleMenuTile(
    handleTap: () => launchCallURL(
      url: commonInfo.delivery_phone
    ),
    title: "Позвонить (${commonInfo.delivery_phone_display})",
  );
  contactWidgets.add(contactsPhone);
  for (final social in commonInfo.socials) {
    Widget socialWidget = SimpleMenuTile(
      handleTap: () => launchWebURL(
        url: social.link
      ),
      title: "${social.label}"
    );
    contactWidgets.add(socialWidget);
  }
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 14.0,
      horizontal: 14.0
    ),
    child: Wrap(
      runSpacing: 10.0,
      children: contactWidgets
    )
  );
}

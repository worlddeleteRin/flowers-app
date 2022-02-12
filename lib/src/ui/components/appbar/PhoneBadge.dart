import 'package:flutter/material.dart';
import 'package:myapp/src/ui/components/common/ContactsList.dart';
import 'package:myapp/src/ui/components/common/DraggableBaseSelectBottomSheet.dart';

class PhoneBadge extends StatelessWidget {
  final BuildContext context;
  final Color iconColor;
  final Color backgroundColor;

  void openContactsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableBaseSelectBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ContactsList(context: context);
          }
        );
      }
    );
  }

  PhoneBadge({
    required this.context,
    this.iconColor: Colors.black,
    this.backgroundColor: Colors.transparent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.phone),
        onPressed: () => openContactsPopup(context)
      )
    );
  }
}


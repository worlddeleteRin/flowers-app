import 'package:flutter/material.dart';

Widget DraggableBaseSelectBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
return DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    expand: false,
    builder: (context, ScrollController scrollController) {
      return SingleChildScrollView(
        controller: scrollController,
        // crossAxisAlignment: CrossAxisAlignment.start,
        child: builder(context),
      );
    }
  );
}

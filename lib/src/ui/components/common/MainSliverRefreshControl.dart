import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MainSliverRefreshControl ({
  required Function handleOnRefresh,
}) {
    return CupertinoSliverRefreshControl(
      onRefresh: () async {
        await handleOnRefresh();
      },
    );
  }

import 'package:flutter/material.dart';

Widget SimpleCheckBox({
  required bool value,
  required Function onChanged,
}) {
  return Checkbox(
    value: value,
    onChanged: (value) => onChanged(value)
  );
}

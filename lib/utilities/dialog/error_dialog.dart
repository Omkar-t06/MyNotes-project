import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGerenicDialog(
    context: context,
    title: 'An error ocurred',
    content: text,
    optionBuilder: () => {
      'Ok': null,
    },
  );
}

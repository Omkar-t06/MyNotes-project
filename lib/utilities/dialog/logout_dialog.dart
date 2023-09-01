import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGerenicDialog(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to Logout?',
    optionBuilder: () => {
      'Log Out': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}

import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGerenicDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'We have sent you a password reset link.Please check your email for more information.',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}

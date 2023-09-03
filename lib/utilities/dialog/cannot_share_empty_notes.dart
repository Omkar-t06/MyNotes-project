import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGerenicDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}

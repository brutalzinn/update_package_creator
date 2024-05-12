import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<String?> showSimpleTextInput(BuildContext context, String title,
      {String initialText = ""}) async {
    final texts = await showTextInputDialog(
      context: context,
      title: title,
      textFields: [
        DialogTextField(hintText: title, initialText: initialText),
      ],
    );
    final text = texts == null ? null : texts[0];
    return text;
  }

  static void showSimpleAlert(BuildContext context, String title,
      {String message = ""}) async {
    await showOkAlertDialog(context: context, title: title, message: message);
  }
}

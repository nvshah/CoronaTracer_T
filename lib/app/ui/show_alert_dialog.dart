import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

///Display simple Alert Dialog
Future<void> showAlertDialog({
  @required BuildContext context,
  @required final title,
  @required final content,
  @required final defaultActionText,
}) async {
  if (Platform.isIOS) {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        FlatButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

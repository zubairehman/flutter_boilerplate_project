import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

abstract class Message {
  SizedBox showMessage(String message, BuildContext context);
}

class SuccessMessage extends Message {
  @override
  SizedBox showMessage(String message, BuildContext context, {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createSuccess(
            message: message,
            title: AppLocalizations.of(context).translate('message_success'),
            duration: Duration(milliseconds: duration),
          ).show(context);
        }
      });
    }

    return const SizedBox.shrink();
  }
}

class ErrorMessage extends Message {
  @override
  SizedBox showMessage(String message, BuildContext context, {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('message_error'),
            duration: Duration(milliseconds: duration),
          ).show(context);
        }
      });
    }

    return const SizedBox.shrink();
  }
}

class InfomationMessage extends Message {
  @override
  SizedBox showMessage(String message, BuildContext context, {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createInformation(
            message: message,
            title: AppLocalizations.of(context).translate('message_infomation'),
            duration: Duration(milliseconds: duration),
          ).show(context);
        }
      });
    }

    return const SizedBox.shrink();
  }
}

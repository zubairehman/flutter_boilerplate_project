import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Message {
  SizedBox showMessage(String message, BuildContext context);
}

class SuccessMessage extends Message {
  @override
  SizedBox showMessage(String message, BuildContext context,
      {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createSuccess(
            message: message,
            title: AppLocalizations.of(context)!.message_success,
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
  SizedBox showMessage(String message, BuildContext context,
      {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context)!.message_error,
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
  SizedBox showMessage(String message, BuildContext context,
      {int duration = 3000}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (message.isNotEmpty) {
          FlushbarHelper.createInformation(
            message: message,
            title: AppLocalizations.of(context)!.message_information,
            duration: Duration(milliseconds: duration),
          ).show(context);
        }
      });
    }

    return const SizedBox.shrink();
  }
}

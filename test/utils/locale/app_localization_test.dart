import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('translate returns key when translation is missing', () {
    final localizations = AppLocalizations(const Locale('en'));
    localizations.localizedStrings = {'known': 'Known'};

    expect(localizations.translate('missing_key'), 'missing_key');
  });
}
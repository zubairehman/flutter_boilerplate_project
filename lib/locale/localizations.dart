// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple "rough and ready" example of localizing a Flutter app.
// Spanish and English (locale language codes 'en' and 'es') are
// supported.

// The pubspec.yaml file must include flutter_localizations in its
// dependencies section. For example:
//
// dependencies:
//   flutter:
//   sdk: flutter
//  flutter_localizations:
//    sdk: flutter

// If you run this app with the device's locale set to anything but
// English or Spanish, the app's locale will be English. If you
// set the device's locale to Spanish, the app's locale will be
// Spanish.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Boilerplate Project',
      'login_et_user_email': 'Enter user email',
      'login_et_user_password': 'Enter password',
      'login_btn_forgot_password': 'Forgot Password?',
      'login_btn_sign_in': 'Sign In',
      'login_validation_error': 'Please fill in all fields',
      'posts_title': 'Posts',
      'posts_not_found': 'No Posts Found',
      'settings_title': 'Settings',
    },
    'es': {
      'title': 'Proyecto repetitivo',
      'login_et_user_email': 'Ingrese el email del usuario',
      'login_et_user_password': 'introducir la contraseña',
      'login_btn_forgot_password': 'Se te olvidó tu contraseña',
      'login_btn_sign_in': 'Registrarse',
      'login_validation_error': 'Por favor rellena todos los campos',
      'posts_title': 'Mensajes',
      'posts_not_found': 'No se han encontrado publicacionesd',
      'settings_title': 'Ajustes',
    },
  };

  String get title => _localizedValues[locale.languageCode]['title'];
  String get login_et_user_email =>
      _localizedValues[locale.languageCode]['login_et_user_email'];
  String get login_et_user_password =>
      _localizedValues[locale.languageCode]['login_et_user_password'];
  String get login_btn_forgot_password =>
      _localizedValues[locale.languageCode]['login_btn_forgot_password'];
  String get login_btn_sign_in =>
      _localizedValues[locale.languageCode]['login_btn_sign_in'];
  String get login_validation_error =>
      _localizedValues[locale.languageCode]['login_validation_error'];
  String get posts_title =>
      _localizedValues[locale.languageCode]['posts_title'];
  String get posts_not_found =>
      _localizedValues[locale.languageCode]['posts_not_found'];
  String get settings_title =>
      _localizedValues[locale.languageCode]['settings_title'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  static List<Locale> get supportedLocales => [
        Locale('en', ''),
        Locale('es', ''),
      ];

  @override
  bool isSupported(Locale locale) {
    return supportedLocales
        .map((l) => l.languageCode)
        .toList()
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

import 'package:boilerplate/presentation/home/home.dart' show showLanguageDialog;
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/settings/about_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SettingsDialog extends StatelessWidget {
  final ThemeStore themeStore;
  final LanguageStore languageStore;
  final SettingsStore settingsStore;

  const SettingsDialog({
    super.key,
    required this.themeStore,
    required this.languageStore,
    required this.settingsStore,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('home_tv_settings')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLanguageRow(context),
          const Divider(height: 0),
          _buildThemeRow(context),
          const Divider(height: 0),
          _buildAboutRow(context),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).translate('settings_btn_close')),
        ),
      ],
    );
  }

  Widget _buildLanguageRow(BuildContext context) {
    return Observer(
      builder: (_) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.language),
        title: Text(AppLocalizations.of(context).translate('home_tv_choose_language')),
        subtitle: Text(languageStore.getLanguage() ?? languageStore.locale),
        onTap: () {
          Navigator.of(context).pop();
          showLanguageDialog(
            context: context,
            themeStore: themeStore,
            languageStore: languageStore,
          );
        },
      ),
    );
  }

  Widget _buildThemeRow(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Observer(
      builder: (_) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.brightness_6),
        title: Text(localizations.translate('settings_tv_theme')),
        subtitle: Text(
          themeStore.darkMode
              ? localizations.translate('settings_tv_theme_dark')
              : localizations.translate('settings_tv_theme_light'),
        ),
        onTap: () {
          themeStore.changeBrightnessToDark(!themeStore.darkMode);
        },
      ),
    );
  }

  Widget _buildAboutRow(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.info_outline),
      title: Text(AppLocalizations.of(context).translate('home_tv_about')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).pop();
        showAboutDialog(
          context: context,
          settingsStore: settingsStore,
        );
      },
    );
  }
}

Future<void> showSettingsDialog({
  required BuildContext context,
  required ThemeStore themeStore,
  required LanguageStore languageStore,
  required SettingsStore settingsStore,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => SettingsDialog(
      themeStore: themeStore,
      languageStore: languageStore,
      settingsStore: settingsStore,
    ),
  );
}
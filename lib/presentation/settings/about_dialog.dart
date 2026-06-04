import 'package:boilerplate/core/widgets/app_icon_widget.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AppAboutDialog extends StatefulWidget {
  final SettingsStore settingsStore;

  const AppAboutDialog({
    super.key,
    required this.settingsStore,
  });

  @override
  State<AppAboutDialog> createState() => _AppAboutDialogState();
}

class _AppAboutDialogState extends State<AppAboutDialog> {
  @override
  void initState() {
    super.initState();
    widget.settingsStore.loadAboutInfo();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.translate('home_tv_about')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(child: AppIconWidget(image: 'assets/icons/ic_launcher.png')),
            const SizedBox(height: 16),
            Center(
              child: Text(
                localizations.translate('settings_et_app_name'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(localizations.translate('settings_et_about_description')),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Observer(
              builder: (_) {
                if (widget.settingsStore.loading) {
                  return Text(localizations.translate('settings_tv_loading'));
                }
                if (widget.settingsStore.errorMessage != null) {
                  return Text(localizations.translate('settings_tv_error_loading_info'));
                }
                return Text(widget.settingsStore.aboutInfo ?? '');
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.translate('settings_btn_close')),
        ),
      ],
    );
  }
}

Future<void> showAppAboutDialog({
  required BuildContext context,
  required SettingsStore settingsStore,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => AppAboutDialog(settingsStore: settingsStore),
  );
}
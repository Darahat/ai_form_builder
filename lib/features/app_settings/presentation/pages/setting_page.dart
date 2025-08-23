import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/app_settings/provider/settings_provider.dart';
import 'package:ai_form_builder/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Flutter setting page
class SettingsPage extends ConsumerWidget {
  /// flutter setting constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsControllerProvider);
    final logger = ref.watch(appLoggerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) {
          final isDarkMode = settings.themeMode == ThemeMode.dark;
          logger.debug(settings.themeMode.name);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                AppLocalizations.of(context)!.appearance,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: isDarkMode,
                onChanged: (value) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<Locale>(
                value: settings.locale,
                onChanged: (Locale? newLocale) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateLocale(newLocale);
                },
                items:
                    AppLocalizations.supportedLocales
                        .map<DropdownMenuItem<Locale>>((Locale locale) {
                          return DropdownMenuItem<Locale>(
                            value: locale,
                            child: Text(locale.languageCode),
                          );
                        })
                        .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

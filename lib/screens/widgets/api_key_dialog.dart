import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/api_key_settings.dart';
import '../../features/try_on_controller.dart';
import '../../l10n/app_localizations.dart';

class ApiKeyDialog extends ConsumerStatefulWidget {
  const ApiKeyDialog({super.key});

  @override
  ConsumerState<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends ConsumerState<ApiKeyDialog> {
  final _input = TextEditingController();
  bool _obscured = true;
  bool _saving = false;
  String? _error;

  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _save({bool clear = false}) async {
    if (_saving) return;
    if (!clear && _input.text.trim().isEmpty) {
      setState(() => _error = l10n.enterNewKey);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final saved = await ref
        .read(tryOnControllerProvider.notifier)
        .saveApiKey(clear ? '' : _input.text);
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error =
            ref.read(tryOnControllerProvider).message ?? l10n.saveKeyFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = ref.watch(apiKeySettingsProvider).asData?.value;
    final busy =
        _saving || ref.watch(tryOnControllerProvider.select((s) => s.busy));
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        backgroundColor: const Color(0xFF111722),
        icon: const Icon(Icons.key_rounded, color: Color(0xFF7CF5E8)),
        title: Text(l10n.keySettings),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                keys == null
                    ? l10n.readingConfiguration
                    : keys.hasKey
                    ? l10n.keyConfigured
                    : l10n.keyNotConfigured,
                style: const TextStyle(color: Color(0xFF8D98AA), fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.keyStorageBody,
                style: TextStyle(color: Color(0xFF8D98AA), fontSize: 13),
              ),
              if (keys?.storageMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  keys!.storageMessage!,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              TextField(
                key: const ValueKey('api-key-input'),
                controller: _input,
                enabled: !busy,
                obscureText: _obscured,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!busy) unawaited(_save());
                },
                decoration: InputDecoration(
                  labelText: l10n.apiKeyLabel,
                  hintText: 'dct_…',
                  errorText: _error,
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    tooltip: _obscured ? l10n.showKey : l10n.hideKey,
                    onPressed: busy
                        ? null
                        : () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              if (keys?.hasKey == true)
                TextButton.icon(
                  onPressed: busy ? null : () => _save(clear: true),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: Text(l10n.clearKey),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: busy || keys?.enabled != true ? null : _save,
            child: Text(_saving ? l10n.savingKey : l10n.saveKey),
          ),
        ],
      ),
    );
  }
}

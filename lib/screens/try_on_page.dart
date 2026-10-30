import 'dart:async';
import 'dart:io';

import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../features/try_on_controller.dart';
import '../features/try_on_state.dart';
import '../l10n/app_localizations.dart';
import '../features/api_key_settings.dart';
import 'widgets/api_key_dialog.dart';

const _ink = Color(0xFFF4F7FB);
const _muted = Color(0xFF8D98AA);
const _canvas = Color(0xFF080B12);
const _panel = Color(0xFF111722);
const _cyan = Color(0xFF7CF5E8);
const _violet = Color(0xFF8B7CFF);

class TryOnPage extends ConsumerStatefulWidget {
  const TryOnPage({super.key});

  @override
  ConsumerState<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends ConsumerState<TryOnPage>
    with WidgetsBindingObserver {
  TryOnController get _controller => ref.read(tryOnControllerProvider.notifier);
  AppLocalizations get l10n => AppLocalizations.of(context);
  bool _consented = false;
  bool _showOriginal = false;
  bool _picking = false;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isFullscreen) unawaited(_restoreSystemUi());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.setForeground(true));
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_controller.setForeground(false));
    }
  }

  Future<void> _toggleFullscreen() async {
    if (_isFullscreen) {
      await _leaveFullscreen();
      return;
    }
    setState(() => _isFullscreen = true);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _leaveFullscreen() async {
    if (mounted) setState(() => _isFullscreen = false);
    await _restoreSystemUi();
  }

  Future<void> _restoreSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _toggle() async {
    final state = ref.read(tryOnControllerProvider);
    if (state.isInSession) {
      await _controller.stop();
      return;
    }
    if (!_consented) {
      final agreed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _panel,
          icon: const Icon(Icons.videocam_outlined, color: _cyan),
          title: Text(l10n.consentTitle),
          content: Text(l10n.consentBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.decline),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.agreeAndStart),
            ),
          ],
        ),
      );
      if (agreed != true || !mounted) return;
      _consented = true;
    }
    await _controller.start();
  }

  Future<void> _pick() async {
    final state = ref.read(tryOnControllerProvider);
    if (_picking || state.busy) return;
    setState(() => _picking = true);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1536,
        maxHeight: 1536,
        imageQuality: 88,
        requestFullMetadata: false,
      );
      if (image != null && mounted) {
        await _controller.selectGarment(image.path, image.name);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cannotReadImage)));
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _editPrompt() async {
    final input = TextEditingController(
      text: ref.read(tryOnControllerProvider).prompt,
    );
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panel,
        title: Text(l10n.editPromptTitle),
        content: TextField(
          controller: input,
          autofocus: true,
          maxLines: 5,
          maxLength: 600,
          decoration: InputDecoration(
            hintText: l10n.promptHint,
            helperText: l10n.promptExample,
            helperMaxLines: 2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text),
            child: Text(l10n.apply),
          ),
        ],
      ),
    );
    Future<void>.delayed(const Duration(milliseconds: 400), input.dispose);
    if (value != null && mounted) {
      if (value.trim().isEmpty &&
          ref.read(tryOnControllerProvider).garmentPath == null) {
        return;
      }
      await _controller.setPrompt(value.trim());
    }
  }

  Future<void> _editApiKey() => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ApiKeyDialog(),
  );

  String _status(TryOnState state) => switch (state.connection) {
    VtonConnectionState.connecting => l10n.statusConnecting,
    VtonConnectionState.connected => l10n.statusPreparing,
    VtonConnectionState.generating => l10n.statusLive,
    VtonConnectionState.reconnecting => l10n.statusReconnecting,
    _ => state.busy ? l10n.statusPreparing : l10n.statusReady,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tryOnControllerProvider);
    final keys = ref.watch(apiKeySettingsProvider).asData?.value;
    return Scaffold(
      backgroundColor: _canvas,
      body: _isFullscreen ? _fullscreenBody(state) : _normalBody(state, keys),
    );
  }

  Widget _normalBody(TryOnState state, ApiKeyStatus? keys) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _header(state, keys),
        const SizedBox(height: 30),
        _intro(),
        const SizedBox(height: 22),
        _videoStage(state),
        const SizedBox(height: 26),
        if (state.message != null) ...[
          _messageCard(state),
          const SizedBox(height: 18),
        ],
        _styleHeader(state),
        const SizedBox(height: 12),
        _styleRail(state),
        if (state.garmentPath != null) ...[
          const SizedBox(height: 14),
          _garmentCard(state),
        ],
        const SizedBox(height: 20),
        _promptCard(state),
        const SizedBox(height: 18),
        _startButton(state),
        const SizedBox(height: 12),
        Text(
          l10n.cloudFooter,
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );

  Widget _fullscreenBody(TryOnState state) => ColoredBox(
    color: Colors.black,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: _videoStage(state, fullscreen: true)),
        Positioned(
          top: 18,
          left: 18,
          child: _glassIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: l10n.backToFittingRoom,
            onPressed: _leaveFullscreen,
          ),
        ),
      ],
    ),
  );

  Widget _header(TryOnState state, ApiKeyStatus? keys) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: const LinearGradient(colors: [_cyan, _violet]),
        ),
        child: const Icon(Icons.auto_awesome_rounded, color: _canvas, size: 21),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.brandLabel,
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              l10n.appName,
              style: TextStyle(
                color: _ink,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      if (keys?.enabled == true) ...[
        _glassIconButton(
          icon: Icons.key_rounded,
          tooltip: l10n.keySettings,
          onPressed: state.busy ? null : _editApiKey,
        ),
        const SizedBox(width: 8),
      ],
      _glassIconButton(
        icon: Icons.info_outline_rounded,
        tooltip: l10n.usageInfo,
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: _panel,
            title: Text(l10n.usageTitle),
            content: Text(l10n.usageBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.gotIt),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _intro() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.introTitle,
        style: TextStyle(
          color: _ink,
          fontSize: 29,
          height: 1.18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      SizedBox(height: 10),
      Text(l10n.introSubtitle, style: TextStyle(color: _muted, fontSize: 15)),
    ],
  );

  Widget _videoStage(TryOnState state, {bool fullscreen = false}) => Container(
    height: fullscreen ? null : 370,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(fullscreen ? 0 : 28),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF182A35), Color(0xFF0E121C), Color(0xFF171329)],
      ),
      border: fullscreen
          ? null
          : Border.all(color: Colors.white.withValues(alpha: 0.08)),
      boxShadow: fullscreen
          ? null
          : [
              BoxShadow(
                color: _cyan.withValues(alpha: 0.08),
                blurRadius: 30,
                spreadRadius: -10,
              ),
            ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (!state.isInSession)
          _emptyVideoState()
        else
          _showOriginal
              ? const VtonLocalPreview(fit: VtonVideoFit.cover, mirror: true)
              : const VtonRemoteView(fit: VtonVideoFit.cover),
        Positioned(top: 16, left: 16, child: _statusPill(state)),
        if (state.isInSession)
          Positioned(
            top: 14,
            right: 14,
            child: _glassIconButton(
              icon: fullscreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              tooltip: fullscreen ? l10n.exitFullscreen : l10n.fullscreen,
              onPressed: _toggleFullscreen,
            ),
          ),
        if (state.busy)
          const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(color: _cyan, strokeWidth: 2.2),
            ),
          ),
        if (state.isLive)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _glassButton(
                  icon: Icons.compare_arrows_rounded,
                  label: _showOriginal ? l10n.viewTryOn : l10n.viewCamera,
                  onPressed: () =>
                      setState(() => _showOriginal = !_showOriginal),
                ),
                _glassIconButton(
                  icon: Icons.cameraswitch_outlined,
                  tooltip: l10n.switchCamera,
                  onPressed: state.busy ? null : _controller.switchCamera,
                ),
              ],
            ),
          ),
        if (state.quality == VtonConnectionQuality.poor ||
            state.quality == VtonConnectionQuality.unusable)
          Positioned(
            top: 58,
            left: 18,
            child: Text(
              l10n.networkUnstable,
              style: TextStyle(color: Color(0xFFFFDCA0), fontSize: 12),
            ),
          ),
      ],
    ),
  );

  Widget _emptyVideoState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _cyan.withValues(alpha: 0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(color: _cyan.withValues(alpha: 0.18), blurRadius: 28),
            ],
          ),
          child: const Icon(Icons.view_in_ar_rounded, size: 42, color: _cyan),
        ),
        const SizedBox(height: 22),
        Text(
          l10n.emptyVideoTitle,
          style: TextStyle(
            color: _ink,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.emptyVideoSubtitle,
          style: TextStyle(color: _muted, fontSize: 13),
        ),
      ],
    ),
  );

  Widget _statusPill(TryOnState state) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 7,
            color: state.isLive ? _cyan : Colors.white54,
          ),
          const SizedBox(width: 7),
          Text(
            _status(state),
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (state.isLive)
            Text(
              '  ${state.elapsed.inMinutes.toString().padLeft(2, '0')}:${(state.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
        ],
      ),
    ),
  );

  Widget _styleHeader(TryOnState state) => Row(
    children: [
      Expanded(
        child: Text(
          l10n.styleHeading,
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      TextButton.icon(
        onPressed: state.busy || _picking ? null : _pick,
        icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
        label: Text(_picking ? l10n.openingGallery : l10n.uploadGarment),
      ),
    ],
  );

  Widget _styleRail(TryOnState state) => SizedBox(
    height: 118,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: localizedOutfitPresets(l10n).length,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (context, index) => _preset(state, index),
    ),
  );

  Widget _preset(TryOnState state, int index) {
    const colors = [
      Color(0xFF537BC1),
      Color(0xFFE8E4D8),
      Color(0xFF7F8794),
      Color(0xFF8FB9CE),
    ];
    final selected = state.presetIndex == index;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: state.busy ? null : () => _controller.selectPreset(index),
        borderRadius: BorderRadius.circular(19),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 116,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? _cyan.withValues(alpha: 0.14) : _panel,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected ? _cyan : Colors.white.withValues(alpha: 0.07),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.checkroom_rounded, color: colors[index], size: 35),
              const SizedBox(height: 12),
              Text(
                localizedOutfitPresets(l10n)[index].name,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _garmentCard(TryOnState state) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(state.garmentPath!),
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox(
              width: 54,
              height: 54,
              child: Icon(Icons.checkroom),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            state.garmentName ?? l10n.myGarment,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _ink),
          ),
        ),
        const Icon(Icons.check_circle, color: _cyan, size: 22),
      ],
    ),
  );

  Widget _promptCard(TryOnState state) => InkWell(
    onTap: state.busy ? null : _editPrompt,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _violet.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.tune_rounded, size: 18, color: _violet),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.promptLabel,
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  state.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _ink, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _muted),
        ],
      ),
    ),
  );

  Widget _startButton(TryOnState state) => FilledButton.icon(
    onPressed: _picking || (state.busy && !state.isInSession) ? null : _toggle,
    icon: Icon(state.isInSession ? Icons.stop_rounded : Icons.bolt_rounded),
    label: Text(
      state.isInSession ? l10n.stopTryOn : l10n.startTryOn,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  );

  Widget _messageCard(TryOnState state) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF271F2D),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFB18DFF).withValues(alpha: 0.25),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded, size: 18, color: _violet),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            state.message!,
            style: const TextStyle(color: _ink, fontSize: 13),
          ),
        ),
        if (state.message == l10n.permissionRequired)
          TextButton(
            onPressed: openAppSettings,
            child: Text(l10n.openSettings),
          ),
      ],
    ),
  );

  Widget _glassIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.34),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
    ),
    child: IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: _ink, size: 21),
    ),
  );

  Widget _glassButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
    ),
    child: TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 17, color: _ink),
      label: Text(label, style: const TextStyle(color: _ink, fontSize: 12)),
    ),
  );
}

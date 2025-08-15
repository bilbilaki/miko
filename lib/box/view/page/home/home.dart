import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_links/app_links.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/box/core/util/sync.dart';
import 'package:miko/box/core/util/url.dart';
import 'package:miko/box/data/model/canvas_result.dart';
//import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:miko/box/data/model/chat/history/share.dart';
import 'package:miko/box/core/util/chat_title.dart';
import 'package:miko/box/core/util/tool_func/tool.dart';
import 'package:miko/box/data/model/chat/config.dart';
import 'package:miko/box/data/model/chat/history/history.dart';
import 'package:miko/box/data/model/chat/history/view.dart';
import 'package:miko/box/data/model/chat/type.dart';
import 'package:miko/box/data/res/build_data.dart';
import 'package:miko/box/data/res/l10n.dart';
import 'package:miko/box/data/res/migrations.dart';
import 'package:miko/box/data/res/openai.dart';
import 'package:miko/box/data/store/all.dart';
import 'package:miko/box/data/store/dummy.dart';
import 'package:miko/box/data/store/setting.dart';
import 'package:miko/box/view/page/home/bottom/prompt_generator.dart';
import 'package:miko/box/view/page/home/settings_drawer.dart';
import 'package:miko/box/view/page/settings/setting.dart';
import 'package:miko/box/view/widget/canvas_free.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:siri_wave/siri_wave.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:openai_dart/openai_dart.dart' hide Image;
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:screenshot/screenshot.dart';
part '../../widget/audio.dart';
part 'chat.dart';
part 'history.dart';
part 'var.dart';
part 'ctrl.dart';
part 'enum.dart';
part 'search.dart';
part 'appbar.dart';
part 'bottom/bottom.dart';
part 'bottom/settings.dart';
part 'bottom/picked_files.dart';
part 'url_scheme.dart';
part 'req.dart';
part 'md_copy.dart';
part 'trash.dart';

final aiSettings = AiSettings();

const int kTtsSampleRate =
    24000; // OpenAI TTS default for pcm16. Adjust if your API returns a different rate.
SettingStore get ss => SettingStore.instance;

bool _looksLikeWavBytes(Uint8List b) {
  if (b.length < 12) return false;
  // 'RIFF' .... 'WAVE'
  return b[0] == 0x52 &&
      b[1] == 0x49 &&
      b[2] == 0x46 &&
      b[3] == 0x46 &&
      b[8] == 0x57 &&
      b[9] == 0x41 &&
      b[10] == 0x56 &&
      b[11] == 0x45;
}

Uint8List _pcm16ToWav(
  Uint8List pcm, {
  int sampleRate = kTtsSampleRate,
  int channels = 1,
}) {
  final dataLen = pcm.length;
  final byteRate = sampleRate * channels * 2; // 16-bit (2 bytes)
  final blockAlign = channels * 2;
  final riffChunkSize = 36 + dataLen;

  final header = BytesBuilder();

  // Helper writers
  void writeStr(String s) => header.add(ascii.encode(s));
  void write32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.little);
    header.add(b.buffer.asUint8List());
  }

  void write16(int v) {
    final b = ByteData(2)..setUint16(0, v, Endian.little);
    header.add(b.buffer.asUint8List());
  }

  // RIFF header
  writeStr('RIFF');
  write32(riffChunkSize);
  writeStr('WAVE');

  // fmt chunk
  writeStr('fmt ');
  write32(16); // PCM fmt chunk size
  write16(1); // AudioFormat = 1 (PCM)
  write16(channels); // NumChannels
  write32(sampleRate);
  write32(byteRate);
  write16(blockAlign);
  write16(16); // BitsPerSample

  // data chunk
  writeStr('data');
  write32(dataLen);

  final out = BytesBuilder();
  out.add(header.toBytes());
  out.add(pcm);
  return out.toBytes();
}

Uint8List _ensureWavBytes(
  Uint8List bytes, {
  int sampleRate = kTtsSampleRate,
  int channels = 1,
}) {
  return _looksLikeWavBytes(bytes)
      ? bytes
      : _pcm16ToWav(bytes, sampleRate: sampleRate, channels: channels);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static void afterRestore() {
    _allHistories = Stores.history.fetchAll();
    _historyRN.notify();
    _chatRN.notify();
    _switchChat();
    Cfg.setTo();
  }
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin<HomePage>, TickerProviderStateMixin {
  Timer? _refreshTimeTimer;
//  final _appLink = AppLinks();

  @override
  void dispose() {
    // Do NOT dispose these, it's global and will be reused
    // inputCtrl.dispose();
    // _chatScrollCtrl.dispose();
    // _historyScrollCtrl.dispose();

    _refreshTimeTimer?.cancel();
    // The context used inside the keyboard listener will be invalid after
    // [_HomePageState.dispose], so this must be disposed here
    _keyboardSendListener?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
   // RNodes.dark.value = context.isDark;
   // _isDesktop.value = !context.isMobile;
    super.didChangeDependencies();
    _homeBottomRN.notify();
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirm(
      onPop: (_) => ExitConfirm.exitApp(),
      child: Scaffold(
        appBar: _CustomAppBar(),
        endDrawer: AiSettingsDrawerHive(),
        endDrawerEnableOpenDragGesture: true,
        body: _Body(),
        bottomNavigationBar: _HomeBottom(isHome: true),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _allHistories = Stores.history.fetchAll();
    _refreshTimeTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) _timeRN.notify();
    });
  // _initUrlScheme();
    // AudioCard.listenAudioPlayer();

    /// Keep this here.
    /// - If there is not chat history, [_switchChat] will create one
    /// - If the init help haven't shown, [_switchChat] will show it
    /// - Init help uses [l10n] to gen msg, so [l10n] must be ready
    /// - [l10n] is ready after first layout
    _switchChat();
    _listenKeyboard();
    _historyRN.notify();
    //_removeDuplicateHistory(context);

    // if (Stores.setting.autoCheckUpdate.get()) {
    //   AppUpdateIface.doUpdate(
    //     url: Urls.appUpdateCfg,
    //     context: context,
    //     build: BuildData.build,
    //   );
    // }

    _migrate();
  }

  void _migrate() async {
    final lastVer = PrefProps.lastVer.get();
    const now = BuildData.build;

    await MigrationFns.appendV1ToUrl(lastVer, now, context: context);

    PrefProps.lastVer.set(now);
  }

  void _listenKeyboard() {
    _keyboardSendListener = KeyboardCtrlListener(
      key: PhysicalKeyboardKey.enter,
      callback: () {
        // If the current page is not chat, do nothing
        if (context.stillOnPage != true) return false;

        if (inputCtrl.text.isEmpty) return false;
        _onCreateRequest(context, _curChatId.value);
        return true;
      },
    );
  }

  // Future<void> _initUrlScheme() async {
  //   DeepLinks.register(_AppLink.handle);

  //   if (isWeb) {
  //     final uri = await _appLink.getInitialLink();
  //     if (uri == null) return;
  //     DeepLinks.process(uri, context);
  //   } else {
  //     _appLink.uriLinkStream.listen(
  //       (uri) {
  //         final ctx = mounted ? context : null;
  //         DeepLinks.process(uri, ctx);
  //       },
  //       onError: (err) {
  //         final msg = l10n.invalidLinkFmt(err);
  //         Loggers.app.warning(msg);
  //         context.showRoundDialog(title: l10n.attention, child: Text(msg));
  //       },
  //     );
  //   }
  // }
}

final class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    const history = _HistoryPage();
    const chat = _ChatPage();

    return _isDesktop.listenVal((isWide) {
      if (isWide) {
        return LayoutBuilder(
          builder: (context, cons) {
            final w = math.max(200.0, math.min(400.0, cons.maxWidth * 0.3));
            return Row(
              children: [
                SizedBox(width: w, height: cons.maxHeight, child: history),
                const Expanded(child: chat),
              ],
            );
          },
        );
      }

      return PageView(
        controller: _pageCtrl,
        onPageChanged: (value) {
          _curPage.value = HomePageEnum.fromIdx(value);
        },
        children: const [history, chat],
      );
    });
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_theme.dart';

/// Ortam sesleri: Mixkit’in HTTPS üzerindeki önizleme MP3 URL’leri + [AudioPlayer] (
/// `just_audio`). İnternet ve tarayıcı CORS politikası gerekir; web’de ilk oynatma
/// için kullanıcı etkileşimi (oturumu başlat) genelde şarttır.
abstract final class _AmbienceUrls {
  static const rain =
      'https://assets.mixkit.co/sfx/preview/mixkit-light-rain-loop-2393.mp3';
  static const forest =
      'https://assets.mixkit.co/sfx/preview/mixkit-forest-birds-ambience-loop-1252.mp3';
  static const ocean =
      'https://assets.mixkit.co/sfx/preview/mixkit-sea-waves-loop-1186.mp3';
  static const fire =
      'https://assets.mixkit.co/sfx/preview/mixkit-campfire-crackles-loop-1335.mp3';
  static const wind =
      'https://assets.mixkit.co/sfx/preview/mixkit-winter-wind-loop-1174.mp3';
}

class MeditationView extends StatefulWidget {
  const MeditationView({super.key});

  @override
  State<MeditationView> createState() => _MeditationViewState();
}

class _MeditationViewState extends State<MeditationView>
    with TickerProviderStateMixin {
  static const int _totalSessionSeconds = 4 * 60 + 12;

  late AnimationController _breathController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Ticker? _sessionCountdownTicker;

  bool _vibrationOn = true;
  bool _wasExhaling = false;
  bool _sessionActive = false;
  bool _muted = false;

  int _remainingSeconds = _totalSessionSeconds;

  String selectedSound = 'Yağmur';

  final List<Map<String, dynamic>> sounds = [
    {
      'name': 'Yağmur',
      'icon': Icons.water_drop,
      'url': _AmbienceUrls.rain,
    },
    {
      'name': 'Orman',
      'icon': Icons.park,
      'url': _AmbienceUrls.forest,
    },
    {
      'name': 'Okyanus',
      'icon': Icons.waves,
      'url': _AmbienceUrls.ocean,
    },
    {
      'name': 'Ateş',
      'icon': Icons.local_fire_department,
      'url': _AmbienceUrls.fire,
    },
    {
      'name': 'Rüzgar',
      'icon': Icons.wind_power,
      'url': _AmbienceUrls.wind,
    },
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _breathController.addListener(_onBreathTick);
  }

  void _onBreathTick() {
    if (!_sessionActive) return;
    final v = _breathController.value;
    final isExhaling = v > 0.5;
    if (_vibrationOn && isExhaling && !_wasExhaling) {
      HapticFeedback.mediumImpact();
    }
    _wasExhaling = isExhaling;
  }

  String? _urlForSelectedSound() {
    for (final s in sounds) {
      if (s['name'] == selectedSound) return s['url'] as String?;
    }
    return null;
  }

  Future<void> _playAmbience() async {
    final url = _urlForSelectedSound();
    if (url == null) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setVolume(_muted ? 0 : 1);
      await _audioPlayer.play();
    } catch (e, st) {
      debugPrint('Meditasyon sesi: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              kIsWeb
                  ? 'Web’de ses açılamadı (ağ / CORS / tarayıcı kısıtı). Diğer platformları deneyin.'
                  : 'Ses yüklenemedi. İnternet bağlantınızı kontrol edin.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _stopAmbience() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  void _disposeSessionCountdownTicker() {
    _sessionCountdownTicker?.dispose();
    _sessionCountdownTicker = null;
  }

  /// Geri sayım: Timer.periodic yerine Ticker (Flutter vsync ile güvenilir).
  void _onSessionCountdownTick(Duration elapsed) {
    if (!mounted || !_sessionActive) return;
    final passed = elapsed.inSeconds;
    final left =
        (_totalSessionSeconds - passed).clamp(0, _totalSessionSeconds);
    if (left != _remainingSeconds) {
      setState(() => _remainingSeconds = left);
    }
    if (left <= 0 && _sessionActive) {
      _disposeSessionCountdownTicker();
      _onSessionTimeUp();
    }
  }

  void _startSession() {
    _disposeSessionCountdownTicker();
    setState(() {
      _sessionActive = true;
      _remainingSeconds = _totalSessionSeconds;
    });
    _breathController
      ..reset()
      ..repeat();
    _sessionCountdownTicker = createTicker(_onSessionCountdownTick);
    _sessionCountdownTicker!.start();
    _playAmbience();
  }

  Future<void> _onSessionTimeUp() async {
    await _teardownPlayback();
    if (!mounted) return;
    setState(() {
      _sessionActive = false;
      _remainingSeconds = _totalSessionSeconds;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meditasyon süresi tamamlandı.')),
    );
  }

  Future<void> _teardownPlayback() async {
    _disposeSessionCountdownTicker();
    _breathController.stop();
    await _stopAmbience();
  }

  Future<void> _endSessionAndLeave() async {
    await _teardownPlayback();
    if (!mounted) return;
    setState(() {
      _sessionActive = false;
      _remainingSeconds = _totalSessionSeconds;
    });
    Navigator.of(context).maybePop();
  }

  Future<void> _toggleMute() async {
    setState(() => _muted = !_muted);
    try {
      await _audioPlayer.setVolume(_muted ? 0 : 1);
    } catch (_) {}
  }

  @override
  void dispose() {
    _disposeSessionCountdownTicker();
    _breathController.removeListener(_onBreathTick);
    _breathController.dispose();
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  double _breathScale(double v) {
    if (v <= 0.5) {
      return 0.88 + (v / 0.5) * 0.12;
    }
    return 1.0 - ((v - 0.5) / 0.5) * 0.12;
  }

  String _formatClock(int totalSeconds) {
    final m = (totalSeconds ~/ 60).clamp(0, 99);
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  (String, String) _timerDigits() {
    final t = _sessionActive ? _remainingSeconds : _totalSessionSeconds;
    final m = (t ~/ 60).toString().padLeft(2, '0');
    final s = (t % 60).toString().padLeft(2, '0');
    return (m, s);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final bg = isDarkMode
        ? AppTheme.meditationPageBackgroundDark
        : AppTheme.meditationPageBackgroundLight;
    final foreground = isDarkMode
        ? AppTheme.meditationTextPrimaryDark
        : AppTheme.meditationTextPrimaryLight;
    final subtle = isDarkMode
        ? AppTheme.meditationTextMutedDark
        : AppTheme.meditationTextMutedLight;

    final endBg = isDarkMode
        ? AppTheme.meditationEndButtonBackgroundDark
        : AppTheme.meditationEndButtonBackgroundLight;
    final endFg = isDarkMode
        ? AppTheme.meditationEndButtonForegroundDark
        : AppTheme.meditationEndButtonForegroundLight;

    final (minStr, secStr) = _timerDigits();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: foreground),
          onPressed: () async {
            await _teardownPlayback();
            if (context.mounted) Navigator.of(context).maybePop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _muted ? Icons.volume_off_outlined : Icons.volume_up_outlined,
              color: foreground,
            ),
            onPressed: _toggleMute,
          ),
        ],
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NORMAL MOD',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: subtle,
              ),
            ),
            Text(
              'Nefes Alanı',
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, child) {
                final v = _breathController.value;
                final exhaling = v > 0.5;
                final phaseTitle = !_sessionActive
                    ? 'Hazırsın'
                    : (exhaling ? 'Nefes ver...' : 'Nefes al...');
                final scale = _sessionActive ? _breathScale(v) : 1.0;

                return Column(
                  children: [
                    Text(
                      phaseTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _sessionActive
                          ? 'Sakinleşmek için ritmi izle.'
                          : 'Meditasyonu başlatmak için aşağıdaki butona dokun.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: subtle,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  ],
                );
              },
              child: _BreathOrb(isDarkMode: isDarkMode),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimerBox(
                  value: minStr,
                  label: 'DAKİKA',
                  isDarkMode: isDarkMode,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.meditationTimerSeparator,
                      height: 1.2,
                    ),
                  ),
                ),
                _TimerBox(
                  value: secStr,
                  label: 'SANİYE',
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            if (!_sessionActive) ...[
              const SizedBox(height: 8),
              Text(
                'Süre: ${_formatClock(_totalSessionSeconds)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: subtle),
              ),
            ],
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.meditationCardSurfaceDark
                    : AppTheme.meditationCardSurfaceLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.meditationVibrationCircleDark
                          : AppTheme.meditationVibrationCircleLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.vibration_rounded,
                      color: AppTheme.meditationSwitchTrackActive,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titreşim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Nefes verirken titret',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _vibrationOn,
                    activeColor: AppTheme.meditationSwitchThumb,
                    activeTrackColor: AppTheme.meditationSwitchTrackActive,
                    onChanged: (on) {
                      setState(() => _vibrationOn = on);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Rahatlatıcı Sesler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: foreground,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sounds.length,
                itemBuilder: (context, index) {
                  final sound = sounds[index];
                  final isSelected = selectedSound == sound['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedSound = sound['name'] as String);
                      if (_sessionActive) _playAmbience();
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDarkMode
                                ? AppTheme.meditationSoundChipSelectedDark
                                : AppTheme.meditationSoundChipSelectedLight)
                            : (isDarkMode
                                ? AppTheme.meditationSoundChipUnselectedDark
                                : AppTheme.meditationSoundChipUnselectedLight),
                        borderRadius: BorderRadius.circular(18),
                        border: isSelected
                            ? Border.all(
                                color: AppTheme.meditationSoundChipBorder
                                    .withOpacity(0.55),
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sound['icon'] as IconData,
                            color: isSelected
                                ? (isDarkMode
                                    ? AppTheme.meditationSoundIconSelectedDark
                                    : AppTheme.meditationSoundIconSelectedLight)
                                : (isDarkMode
                                    ? AppTheme.meditationSoundIconUnselectedDark
                                    : AppTheme.meditationSoundIconUnselectedLight),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sound['name'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? (isDarkMode
                                      ? AppTheme.meditationSoundIconSelectedDark
                                      : AppTheme.meditationSoundIconSelectedLight)
                                  : (isDarkMode
                                      ? AppTheme.meditationSoundIconUnselectedDark
                                      : AppTheme.meditationSoundIconUnselectedLight),
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (!_sessionActive)
              FilledButton(
                onPressed: _startSession,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Oturumu Başlat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              FilledButton(
                onPressed: _endSessionAndLeave,
                style: FilledButton.styleFrom(
                  backgroundColor: endBg,
                  foregroundColor: endFg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Oturumu Bitir',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BreathOrb extends StatelessWidget {
  const _BreathOrb({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final coreColor = isDarkMode
        ? AppTheme.meditationBreathCoreDark
        : AppTheme.meditationBreathCoreLight;
    final glowColor =
        AppTheme.meditationBreathGlowBase.withOpacity(0.38);

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          ...List.generate(3, (i) {
            final inset = 12.0 + i * 14.0;
            return Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(inset),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (i.isEven
                              ? AppTheme.meditationBreathRing
                              : AppTheme.meditationBreathRingAlt)
                          .withOpacity(0.12 + i * 0.06),
                      width: 1,
                    ),
                  ),
                ),
              ),
            );
          }),
          Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: coreColor,
              border: Border.all(
                color:
                    AppTheme.meditationBreathRing.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.eco_rounded,
              size: 52,
              color: isDarkMode
                  ? AppTheme.meditationBreathLeafDark
                  : AppTheme.meditationBreathLeafLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerBox extends StatelessWidget {
  const _TimerBox({
    required this.value,
    required this.label,
    required this.isDarkMode,
  });

  final String value;
  final String label;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final fg = isDarkMode
        ? AppTheme.meditationTextPrimaryDark
        : AppTheme.meditationTextPrimaryLight;
    final subtle = isDarkMode
        ? AppTheme.meditationTextMutedDark
        : AppTheme.meditationTextMutedLight;

    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppTheme.meditationCardSurfaceDark
            : AppTheme.meditationCardSurfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: subtle,
            ),
          ),
        ],
      ),
    );
  }
}

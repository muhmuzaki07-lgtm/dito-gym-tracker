import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/pin_hasher.dart';
import '../../providers/providers.dart';
import '../../providers/personalization_providers.dart';

/// Full-screen PIN pad shown when the app is locked. Also offers a
/// biometric (fingerprint/face) unlock button if the person enabled it
/// and the device supports it.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _entered = '';
  String? _error;
  final _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    if (settings.biometricEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
    }
  }

  Future<void> _tryBiometric() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!supported || !canCheck) return;
      final ok = await _localAuth.authenticate(
        localizedReason: 'Buka Dito Gym Tracker',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok) _unlock();
    } catch (_) {
      // Biometric unavailable/failed — person can still use PIN.
    }
  }

  void _unlock() {
    ref.read(isAppLockedProvider.notifier).state = false;
  }

  void _onDigit(String digit) {
    if (_entered.length >= 6) return;
    setState(() {
      _entered += digit;
      _error = null;
    });
    if (_entered.length >= 4) {
      _checkPin();
    }
  }

  void _checkPin() {
    final settings = ref.read(appSettingsProvider);
    final hash = settings.pinHash;
    if (hash != null && PinHasher.verify(_entered, hash)) {
      _unlock();
    } else if (_entered.length >= 6) {
      setState(() {
        _error = 'PIN salah';
        _entered = '';
      });
    }
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.gold, size: 48),
              const SizedBox(height: 16),
              const Text('Masukkan PIN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final filled = i < _entered.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.gold : AppColors.surfaceElevated,
                    ),
                  );
                }),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ],
              const SizedBox(height: 32),
              _PinPad(
                onDigit: _onDigit,
                onBackspace: _backspace,
                onBiometric: settings.biometricEnabled ? _tryBiometric : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;

  const _PinPad({
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildKey(String label, {VoidCallback? onTap, Widget? child}) {
      return SizedBox(
        width: 72,
        height: 72,
        child: Material(
          color: AppColors.surfaceElevated,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: child ??
                  Text(label,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      );
    }

    final rows = <List<Widget>>[
      [
        buildKey('1', onTap: () => onDigit('1')),
        buildKey('2', onTap: () => onDigit('2')),
        buildKey('3', onTap: () => onDigit('3')),
      ],
      [
        buildKey('4', onTap: () => onDigit('4')),
        buildKey('5', onTap: () => onDigit('5')),
        buildKey('6', onTap: () => onDigit('6')),
      ],
      [
        buildKey('7', onTap: () => onDigit('7')),
        buildKey('8', onTap: () => onDigit('8')),
        buildKey('9', onTap: () => onDigit('9')),
      ],
      [
        onBiometric != null
            ? buildKey('', onTap: onBiometric, child: const Icon(Icons.fingerprint, color: AppColors.gold))
            : const SizedBox(width: 72, height: 72),
        buildKey('0', onTap: () => onDigit('0')),
        buildKey('', onTap: onBackspace, child: const Icon(Icons.backspace_outlined)),
      ],
    ];

    return Column(
      children: rows
          .map((row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row,
                ),
              ))
          .toList(),
    );
  }
}

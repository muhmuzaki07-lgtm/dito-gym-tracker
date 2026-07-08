import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/pin_hasher.dart';
import '../../providers/providers.dart';

/// Lets the person set a new PIN (asked twice to confirm) or, if a PIN
/// hint step number is passed, could be extended for re-auth. Kept simple:
/// always sets a brand new PIN and enables the lock.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _first = '';
  String _second = '';
  bool _confirming = false;
  String? _error;

  void _onDigit(String d) {
    setState(() {
      _error = null;
      if (!_confirming) {
        if (_first.length < 6) _first += d;
        if (_first.length == 4) {
          // Allow up to 6 digits; move to confirm once they tap "done".
        }
      } else {
        if (_second.length < 6) _second += d;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (!_confirming) {
        if (_first.isNotEmpty) _first = _first.substring(0, _first.length - 1);
      } else {
        if (_second.isNotEmpty) _second = _second.substring(0, _second.length - 1);
      }
    });
  }

  void _proceedOrConfirm() async {
    if (!_confirming) {
      if (_first.length < 4) {
        setState(() => _error = 'PIN minimal 4 digit');
        return;
      }
      setState(() => _confirming = true);
      return;
    }

    if (_second != _first) {
      setState(() {
        _error = 'PIN tidak cocok, coba lagi';
        _second = '';
      });
      return;
    }

    final settings = ref.read(appSettingsProvider);
    settings.pinHash = PinHasher.hash(_first);
    settings.pinEnabled = true;
    await ref.read(workoutRepositoryProvider).saveSettings(settings);
    notifyDataChanged(ref);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN berhasil diatur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _confirming ? _second : _first;

    return Scaffold(
      appBar: AppBar(title: Text(_confirming ? 'Konfirmasi PIN' : 'Buat PIN Baru')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              _confirming ? 'Masukkan ulang PIN kamu' : 'Masukkan PIN 4-6 digit',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final filled = i < current.length;
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
            const Spacer(),
            _SimpleKeypad(onDigit: _onDigit, onBackspace: _backspace),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: current.length >= 4 ? _proceedOrConfirm : null,
                child: Text(_confirming ? 'Simpan PIN' : 'Lanjut'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleKeypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  const _SimpleKeypad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    Widget key(String label, {VoidCallback? onTap, Widget? child}) {
      return SizedBox(
        width: 64,
        height: 64,
        child: Material(
          color: AppColors.surfaceElevated,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: child ?? Text(label, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
      );
    }

    final rows = <List<Widget>>[
      ['1', '2', '3'].map((d) => key(d, onTap: () => onDigit(d))).toList(),
      ['4', '5', '6'].map((d) => key(d, onTap: () => onDigit(d))).toList(),
      ['7', '8', '9'].map((d) => key(d, onTap: () => onDigit(d))).toList(),
      [
        const SizedBox(width: 64, height: 64),
        key('0', onTap: () => onDigit('0')),
        key('', onTap: onBackspace, child: const Icon(Icons.backspace_outlined)),
      ],
    ];

    return Column(
      children: rows
          .map((row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: row),
              ))
          .toList(),
    );
  }
}

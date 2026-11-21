import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Campo de código de 6 dígitos (OTP) usado en la verificación por SMS.
///
/// Avanza automáticamente al siguiente dígito y retrocede al borrar.
class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.initialValue = '',
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final String initialValue;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  String get _value => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (i) => TextEditingController(
        text: i < widget.initialValue.length ? widget.initialValue[i] : '',
      ),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String text, int index) {
    if (text.length > 1) {
      // Pega un código completo: repartelo en los casilleros.
      final String digits = text.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      _focusNodes[widget.length - 1].requestFocus();
    } else if (text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (text.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 46,
          height: 56,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTypography.highlightedData.copyWith(fontSize: 24),
            onChanged: (text) => _handleChanged(text, index),
            decoration: const InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              hintText: '',
            ),
          ),
        );
      }),
    );
  }
}

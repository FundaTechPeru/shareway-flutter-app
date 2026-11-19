import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Campo de texto con etiqueta superior, icono izquierdo y sufijo opcional.
///
/// Si [obscureText] es `true` muestra automáticamente el ícono de ojo para
/// alternar la visibilidad de la contraseña.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.icon,
    this.suffixIcon,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Etiqueta pequeña sobre el campo.
  final String? label;
  final String? hint;
  final IconData? icon;

  /// Símbolo de reemplazo cuando el campo está oculto.
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.label),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: _obscured,
          style: AppTypography.body,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon == null
                ? null
                : Icon(widget.icon, size: 20),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 46, minHeight: 20),
            suffixIcon: _buildSuffix(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffixIcon != null) return widget.suffixIcon;
    if (!widget.obscureText) return null;

    return IconButton(
      onPressed: () => setState(() => _obscured = !_obscured),
      tooltip: _obscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
      icon: Icon(
        _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
      ),
      color: AppColors.ink2,
    );
  }
}

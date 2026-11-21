import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../driver/domain/driver_api_models.dart';
import '../../shared/data/shareway_api_client.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';

class ShareWaySplashScreen extends StatelessWidget {
  const ShareWaySplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ShareWayColors.primary,
    body: Stack(
      children: [
        const Positioned.fill(
          child: CustomPaint(painter: _SplashWavesPainter()),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShareWayMark(size: 78),
              const SizedBox(height: 14),
              const Text(
                'ShareWay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Viajes compartidos y programados',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 34,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SplashDot(active: true),
              SizedBox(width: 6),
              _SplashDot(),
              SizedBox(width: 6),
              _SplashDot(),
            ],
          ),
        ),
      ],
    ),
  );
}

class ShareWayWelcomeScreen extends StatelessWidget {
  const ShareWayWelcomeScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            children: [
              const Center(child: ShareWayWordmark()),
              const SizedBox(height: 28),
              const _RouteIllustration(),
              const SizedBox(height: 22),
              Text(
                'Tu viaje compartido, sin improvisar',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Coordina tus viajes con anticipación y comparte la ruta con personas que van por tu misma zona.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              const _WelcomeBenefit(
                icon: Icons.calendar_month_rounded,
                title: 'Programa con anticipación',
                subtitle: 'Elige ruta, día y rango horario.',
              ),
              const SizedBox(height: 12),
              const _WelcomeBenefit(
                icon: Icons.verified_user_outlined,
                title: 'Conductores verificados',
                subtitle: 'Revisión de licencia y documentos.',
              ),
              const SizedBox(height: 12),
              const _WelcomeBenefit(
                icon: Icons.groups_2_outlined,
                title: 'Precio compartido',
                subtitle: 'Consulta el precio estimado antes de confirmar.',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onCreateAccount,
                child: const Text('Crear cuenta'),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: onSignIn,
                child: const Text('Ya tengo cuenta'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({
    super.key,
    required this.onRegister,
    required this.onContinue,
  });

  final Future<void> Function({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  })
  onRegister;
  final Future<DriverAccountSnapshot> Function({
    required String email,
    required String password,
  })
  onContinue;

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  bool _isDriver = true;
  bool _acceptTerms = false;
  bool _hidePassword = true;
  bool _phoneStep = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isDriver) {
      setState(
        () => _error = 'Esta versión de ShareWay está enfocada en conductores.',
      );
      return;
    }
    if (!_acceptTerms) {
      setState(
        () =>
            _error = 'Lee y acepta los términos del prototipo para continuar.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onRegister(
        fullName: _fullName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
      );
      if (mounted) setState(() => _phoneStep = true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error is ShareWayApiException && error.statusCode == 409
              ? 'Ya existe una cuenta con ese correo.'
              : _registrationError(error);
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _continuePrototype() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final account = await widget.onContinue(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) Navigator.of(context).pop(account);
    } catch (error) {
      if (mounted) setState(() => _error = _registrationError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showTerms() async {
    final terms = await rootBundle.loadString(
      'docs/terminos-y-condiciones-shareway.md',
    );
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Términos de ShareWay',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Borrador académico del prototipo',
                  style: TextStyle(color: ShareWayColors.warning, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      terms,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          if (_phoneStep) {
            setState(() {
              _phoneStep = false;
              _error = null;
            });
          } else {
            Navigator.of(context).maybePop();
          }
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: Text(_phoneStep ? 'Verificar celular' : 'Crear cuenta'),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _phoneStep
              ? _buildPhoneStep(context)
              : _buildRegistration(context),
        ),
      ),
    ),
  );

  Widget _buildRegistration(BuildContext context) => Form(
    key: _formKey,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Pasajero')),
            ButtonSegment(value: true, label: Text('Conductor')),
          ],
          selected: {_isDriver},
          onSelectionChanged: (selection) => setState(() {
            _isDriver = selection.first;
            _error = null;
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _isDriver
              ? 'Si conduces, luego completaremos tu licencia y contacto de emergencia.'
              : 'El registro de pasajeros se habilitará en el módulo correspondiente.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (_error != null) ...[
          _RegistrationMessage(message: _error!),
          const SizedBox(height: 12),
        ],
        TextFormField(
          controller: _fullName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          decoration: const InputDecoration(
            labelText: 'Nombre completo',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
          validator: (value) => value == null || value.trim().length < 3
              ? 'Ingresa tu nombre completo.'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: 'Correo',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
          validator: (value) {
            final email = value?.trim() ?? '';
            return email.contains('@') && email.contains('.')
                ? null
                : 'Ingresa un correo válido.';
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[+0-9 ()-]')),
          ],
          decoration: const InputDecoration(
            labelText: 'Celular',
            prefixIcon: Icon(Icons.phone_outlined),
            hintText: '+51 987 654 321',
          ),
          validator: (value) {
            final phone = (value ?? '').replaceAll(RegExp(r'[^+0-9]'), '');
            return RegExp(r'^\+?\d{9,15}$').hasMatch(phone)
                ? null
                : 'Ingresa un número de 9 a 15 dígitos.';
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _password,
          obscureText: _hidePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
              icon: Icon(
                _hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: (value) {
            final password = value ?? '';
            if (password.length < 8 ||
                !RegExp(r'[A-Za-z]').hasMatch(password) ||
                !RegExp(r'\d').hasMatch(password)) {
              return 'Usa 8 caracteres como mínimo, una letra y un número.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (value) =>
                  setState(() => _acceptTerms = value ?? false),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  children: [
                    const Text('Leí los '),
                    InkWell(
                      onTap: _showTerms,
                      child: const Text(
                        'Términos del prototipo',
                        style: TextStyle(
                          color: ShareWayColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(' (borrador académico).'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: _busy ? null : _submitRegistration,
          child: _busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Continuar'),
        ),
      ],
    ),
  );

  Widget _buildPhoneStep(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      Text(
        'Verifica tu celular',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 6),
      Text(
        'Enviaremos un código de 6 dígitos por SMS al ${_phone.text.trim()}.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 22),
      TextField(
        controller: _code,
        enabled: false,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          hintText: '·  ·  ·  ·  ·  ·',
          hintStyle: TextStyle(fontSize: 22, letterSpacing: 8),
        ),
      ),
      const SizedBox(height: 14),
      const _RegistrationMessage(
        message: 'El proveedor de SMS aún no está conectado; no se enviará ningún código real.',
      ),
      const SizedBox(height: 20),
      FilledButton(onPressed: null, child: const Text('Verificar')),
      const SizedBox(height: 10),
      OutlinedButton(
        onPressed: _busy ? null : _continuePrototype,
        child: _busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Continuar en modo prototipo'),
      ),
      const SizedBox(height: 10),
      TextButton(
        onPressed: () => setState(() {
          _phoneStep = false;
          _error = null;
        }),
        child: const Text('Cambiar número'),
      ),
    ],
  );
}

class _WelcomeBenefit extends StatelessWidget {
  const _WelcomeBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ShareWayColors.primarySoft,
        ),
        child: Icon(icon, color: ShareWayColors.primaryDark, size: 19),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ],
  );
}

class _RouteIllustration extends StatelessWidget {
  const _RouteIllustration();

  @override
  Widget build(BuildContext context) => Container(
    height: 174,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xFFE5EFF2),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const CustomPaint(painter: _RouteIllustrationPainter()),
  );
}

class _SplashWavesPainter extends CustomPainter {
  const _SplashWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.07);
    for (var index = 0; index < 2; index++) {
      final top = size.height * (0.18 + index * 0.42);
      final wave = Path()
        ..moveTo(0, top)
        ..cubicTo(
          size.width * 0.34,
          top + 70,
          size.width * 0.68,
          top - 70,
          size.width,
          top,
        )
        ..lineTo(size.width, top + 46)
        ..cubicTo(
          size.width * 0.68,
          top - 24,
          size.width * 0.34,
          top + 116,
          0,
          top + 46,
        )
        ..close();
      canvas.drawPath(wave, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashWavesPainter oldDelegate) => false;
}

class _RouteIllustrationPainter extends CustomPainter {
  const _RouteIllustrationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFCAD9DE)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    for (var x = -size.height; x < size.width + size.height; x += 36) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.4, size.height),
        grid,
      );
    }
    for (var y = 20.0; y < size.height; y += 38) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 14), grid);
    }
    final route = Path()
      ..moveTo(size.width * 0.12, size.height * 0.72)
      ..lineTo(size.width * 0.35, size.height * 0.48)
      ..lineTo(size.width * 0.57, size.height * 0.56)
      ..lineTo(size.width * 0.78, size.height * 0.25)
      ..lineTo(size.width * 0.9, size.height * 0.18);
    canvas.drawPath(
      route,
      Paint()
        ..color = ShareWayColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    for (final point in [
      Offset(size.width * 0.12, size.height * 0.72),
      Offset(size.width * 0.35, size.height * 0.48),
      Offset(size.width * 0.57, size.height * 0.56),
    ]) {
      canvas.drawCircle(point, 7, Paint()..color = Colors.white);
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = ShareWayColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.18),
      8,
      Paint()..color = ShareWayColors.accent,
    );
    final car = TextPainter(
      text: const TextSpan(text: '🚘', style: TextStyle(fontSize: 20)),
      textDirection: TextDirection.ltr,
    )..layout();
    car.paint(canvas, Offset(size.width * 0.53, size.height * 0.43));
  }

  @override
  bool shouldRepaint(covariant _RouteIllustrationPainter oldDelegate) => false;
}

class _SplashDot extends StatelessWidget {
  const _SplashDot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    width: active ? 12 : 5,
    height: 5,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: active ? 0.95 : 0.6),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class _RegistrationMessage extends StatelessWidget {
  const _RegistrationMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ShareWayColors.warning.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      message,
      style: const TextStyle(color: ShareWayColors.warning, fontSize: 12),
    ),
  );
}

String _registrationError(Object error) {
  if (error is ShareWayApiException) {
    return error.message;
  }
  return 'No se pudo conectar con ShareWay. Revisa la conexión e inténtalo otra vez.';
}

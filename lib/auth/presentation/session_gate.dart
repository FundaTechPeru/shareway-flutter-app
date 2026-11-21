import 'dart:async';

import 'package:flutter/material.dart';

import '../../driver/data/driver_api_repository.dart';
import '../../driver/domain/driver_api_models.dart';
import '../../driver/presentation/driver_controller.dart';
import '../../driver/presentation/driver_shell.dart';
import 'auth_entry_screens.dart';
import '../../shared/data/shareway_api_client.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';

class DriverSessionGate extends StatefulWidget {
  const DriverSessionGate({
    super.key,
    required this.repository,
    required this.demoController,
  });

  final DriverApiRepository repository;
  final DriverController demoController;

  @override
  State<DriverSessionGate> createState() => _DriverSessionGateState();
}

class _DriverSessionGateState extends State<DriverSessionGate> {
  DriverAccountSnapshot? _account;
  bool _loading = true;
  bool _showSplash = true;
  bool _showWelcome = true;
  String? _startupMessage;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _restoreSession();
    _splashTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  Future<void> _restoreSession() async {
    try {
      final account = await widget.repository.restoreSession();
      if (!mounted) return;
      setState(() {
        _account = account;
        _startupMessage = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _startupMessage = _friendlyMessage(error);
        _loading = false;
      });
    }
  }

  Future<void> _signIn(String email, String password) async {
    final account = await widget.repository.signIn(
      email: email,
      password: password,
    );
    if (!mounted) return;
    setState(() {
      _account = account;
      _startupMessage = null;
    });
  }

  Future<void> _openRegistration() async {
    final account = await Navigator.of(context).push<DriverAccountSnapshot>(
      MaterialPageRoute(
        builder: (_) => DriverRegistrationScreen(
          onRegister: widget.repository.registerAccount,
          onContinue: widget.repository.signIn,
        ),
      ),
    );
    if (!mounted || account == null) return;
    setState(() {
      _account = account;
      _showWelcome = false;
      _startupMessage = null;
    });
  }

  Future<void> _activateDriver({
    required String licenseNumber,
    required EmergencyContactData emergencyContact,
  }) async {
    final account = await widget.repository.registerDriverProfile(
      licenseNumber: licenseNumber,
      emergencyContact: emergencyContact,
    );
    if (!mounted) return;
    setState(() => _account = account);
  }

  Future<void> _signOut() async {
    await widget.repository.signOut();
    if (!mounted) return;
    setState(() {
      _account = null;
      _startupMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const ShareWaySplashScreen();
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final account = _account;
    if (account == null) {
      if (_showWelcome) {
        return ShareWayWelcomeScreen(
          onCreateAccount: _openRegistration,
          onSignIn: () => setState(() => _showWelcome = false),
        );
      }
      return DriverLoginScreen(
        onSignIn: _signIn,
        startupMessage: _startupMessage,
        onCreateAccount: _openRegistration,
        onBackToWelcome: () => setState(() => _showWelcome = true),
      );
    }
    if (account.role == 'PASSENGER') {
      return DriverActivationScreen(
        account: account,
        onActivate: _activateDriver,
        onSignOut: _signOut,
      );
    }
    if (!account.isDriver) {
      return _UnsupportedRoleScreen(onSignOut: _signOut);
    }
    return DriverShell(
      controller: widget.demoController,
      account: account,
      apiRepository: widget.repository,
      onSignOut: _signOut,
    );
  }
}

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({
    super.key,
    required this.onSignIn,
    required this.onCreateAccount,
    required this.onBackToWelcome,
    this.startupMessage,
  });

  final Future<void> Function(String email, String password) onSignIn;
  final VoidCallback onCreateAccount;
  final VoidCallback onBackToWelcome;
  final String? startupMessage;

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSignIn(_email.text, _password.text);
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 54, 24, 32),
            shrinkWrap: true,
            children: [
              const Center(child: ShareWayWordmark()),
              const SizedBox(height: 38),
              Text(
                'Hola de nuevo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Ingresa con tu cuenta ShareWay para continuar.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (widget.startupMessage != null) ...[
                _MessageBanner(message: widget.startupMessage!, isError: true),
                const SizedBox(height: 12),
              ],
              if (_error != null) ...[
                _MessageBanner(message: _error!, isError: true),
                const SizedBox(height: 12),
              ],
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (!email.contains('@') || !email.contains('.')) {
                          return 'Ingresa un correo válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingresa tu contraseña.'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: widget.onCreateAccount,
                child: const Text('Crear cuenta'),
              ),
              TextButton(
                onPressed: widget.onBackToWelcome,
                child: const Text('Volver a bienvenida'),
              ),
              const SizedBox(height: 14),
              const Text(
                'El acceso se valida con el API Gateway de ShareWay.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DriverActivationScreen extends StatefulWidget {
  const DriverActivationScreen({
    super.key,
    required this.account,
    required this.onActivate,
    required this.onSignOut,
  });

  final DriverAccountSnapshot account;
  final Future<void> Function({
    required String licenseNumber,
    required EmergencyContactData emergencyContact,
  })
  onActivate;
  final Future<void> Function() onSignOut;

  @override
  State<DriverActivationScreen> createState() => _DriverActivationScreenState();
}

class _DriverActivationScreenState extends State<DriverActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _license = TextEditingController();
  final _contactName = TextEditingController();
  final _contactPhone = TextEditingController();
  final _relationship = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _license.dispose();
    _contactName.dispose();
    _contactPhone.dispose();
    _relationship.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onActivate(
        licenseNumber: _license.text,
        emergencyContact: EmergencyContactData(
          name: _contactName.text.trim(),
          phone: _contactPhone.text.trim(),
          relationship: _relationship.text.trim(),
        ),
      );
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Registro de conductor'),
      actions: [
        IconButton(
          tooltip: 'Cerrar sesión',
          onPressed: widget.onSignOut,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          Text(
            'Activa tu perfil de conductor',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 7),
          Text(
            'Cuenta: ${widget.account.fullName} · ${widget.account.email}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          if (_error != null) ...[
            _MessageBanner(message: _error!, isError: true),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: _license,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'Número de licencia'),
            validator: (value) {
              final license = value?.trim() ?? '';
              if (!RegExp(r'^[A-Za-z0-9]{8,12}$').hasMatch(license)) {
                return 'Usa entre 8 y 12 letras o números.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contactName,
            decoration: const InputDecoration(
              labelText: 'Contacto de emergencia',
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contactPhone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Celular de contacto'),
            validator: (value) {
              final phone = value?.trim() ?? '';
              if (!RegExp(r'^\+?\d{9,15}$').hasMatch(phone)) {
                return 'Ingresa de 9 a 15 dígitos.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _relationship,
            decoration: const InputDecoration(labelText: 'Parentesco'),
            validator: _required,
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Crear perfil de conductor'),
          ),
          const SizedBox(height: 9),
          const Text(
            'Tu perfil quedará pendiente de verificación hasta que revisen tus documentos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class _UnsupportedRoleScreen extends StatelessWidget {
  const _UnsupportedRoleScreen({required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 40),
            const SizedBox(height: 12),
            const Text('Esta cuenta no puede abrir la vista de conductor.'),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onSignOut, child: const Text('Salir')),
          ],
        ),
      ),
    ),
  );
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? ShareWayColors.error : ShareWayColors.primary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'Completa este dato.' : null;

String _friendlyMessage(Object error) {
  if (error is ShareWayApiException) {
    if (error.statusCode == 401) return 'Correo o contraseña incorrectos.';
    if (error.statusCode == 409) return 'Este perfil ya fue registrado.';
    return error.message;
  }
  if (error is TimeoutException) {
    return 'El servidor tardó demasiado en responder. Inténtalo otra vez.';
  }
  return 'No se pudo conectar con ShareWay. Revisa la URL del Gateway y tu conexión.';
}

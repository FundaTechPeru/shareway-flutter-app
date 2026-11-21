import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../data/driver_api_repository.dart';
import '../domain/driver_api_models.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';

class DriverSetupScreen extends StatefulWidget {
  const DriverSetupScreen({
    super.key,
    this.initialStep = 0,
    this.apiRepository,
    this.account,
    this.onSaved,
  });

  final int initialStep;
  final DriverApiRepository? apiRepository;
  final DriverAccountSnapshot? account;
  final Future<void> Function()? onSaved;

  @override
  State<DriverSetupScreen> createState() => _DriverSetupScreenState();
}

class _DriverSetupScreenState extends State<DriverSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Carlos Huamán Quispe');
  final _dni = TextEditingController(text: '70514821');
  final _license = TextEditingController(text: 'Q845871236');
  final _phone = TextEditingController(text: '+51 986 204 318');
  final _email = TextEditingController(text: 'c.huaman@correo.pe');
  final _brand = TextEditingController(text: 'Toyota');
  final _model = TextEditingController(text: 'Yaris');
  final _year = TextEditingController(text: '2019');
  final _color = TextEditingController(text: 'Gris plata');
  final _plate = TextEditingController(text: 'BKL-482');

  late int _step = widget.initialStep.clamp(0, 2).toInt();
  int _seats = 4;
  DriverVehicleData? _remoteVehicle;
  List<DriverDocumentData> _remoteDocuments = const [];
  bool _loadingRemoteData = false;
  bool _saving = false;
  String? _remoteError;
  String? _uploadingDocumentType;
  final Map<String, String> _documents = {
    'Brevete': 'Aprobado',
    'SOAT': 'En revisión',
    'Tarjeta de propiedad': 'En revisión',
  };

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    if (account != null) {
      _name.text = account.fullName;
      _license.text = account.licenseNumber;
      _phone.text = account.phone;
      _email.text = account.email;
    }
    if (widget.apiRepository != null) _loadRemoteData();
  }

  @override
  void dispose() {
    _name.dispose();
    _dni.dispose();
    _license.dispose();
    _phone.dispose();
    _email.dispose();
    _brand.dispose();
    _model.dispose();
    _year.dispose();
    _color.dispose();
    _plate.dispose();
    super.dispose();
  }

  Future<void> _loadRemoteData() async {
    final repository = widget.apiRepository;
    if (repository == null) return;
    setState(() {
      _loadingRemoteData = true;
      _remoteError = null;
    });
    try {
      final vehiclesFuture = repository.listVehicles();
      final documentsFuture = repository.listDocuments();
      final vehicles = await vehiclesFuture;
      final documents = await documentsFuture;
      if (!mounted) return;
      setState(() {
        _remoteVehicle = vehicles.isEmpty ? null : vehicles.first;
        _remoteDocuments = documents;
        final vehicle = _remoteVehicle;
        if (vehicle != null) {
          _brand.text = vehicle.brand;
          _model.text = vehicle.model;
          _year.text = '${vehicle.year}';
          _color.text = vehicle.color;
          _plate.text = vehicle.plate;
          _seats = vehicle.seats.clamp(1, 8);
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _remoteError = 'No se pudieron cargar tus datos.');
      }
    } finally {
      if (mounted) setState(() => _loadingRemoteData = false);
    }
  }

  Future<void> _uploadRemoteDocument(String label, String apiType) async {
    final repository = widget.apiRepository;
    if (repository == null) return;
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (file == null) return;
    final reportedSize = file.lengthSync();
    if (reportedSize != null && reportedSize > 5 * 1024 * 1024) {
      _showMessage('El archivo supera el máximo permitido de 5 MB.');
      return;
    }
    final bytes = await file.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      _showMessage('El archivo supera el máximo permitido de 5 MB.');
      return;
    }
    final extension = (file.extension ?? '').toLowerCase();
    final mimeType = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => null,
    };
    if (mimeType == null) {
      _showMessage('Selecciona un archivo PDF, JPG o PNG.');
      return;
    }
    setState(() {
      _uploadingDocumentType = apiType;
      _remoteError = null;
    });
    try {
      await repository.uploadDocument(
        type: apiType,
        filename: file.name,
        bytes: bytes,
        mimeType: mimeType,
      );
      await _loadRemoteData();
      _showMessage('$label cargado y enviado a revisión.');
    } catch (_) {
      if (mounted) {
        setState(
          () => _remoteError = 'No se pudo cargar $label. Inténtalo otra vez.',
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingDocumentType = null);
    }
  }

  Future<void> _saveRemoteVehicle() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final repository = widget.apiRepository;
    if (repository == null) return;
    setState(() {
      _saving = true;
      _remoteError = null;
    });
    try {
      final year = int.tryParse(_year.text.trim());
      if (year == null) throw const FormatException('Año inválido');
      await repository.saveVehicle(
        DriverVehicleData(
          id: _remoteVehicle?.id,
          plate: _plate.text.trim().toUpperCase(),
          brand: _brand.text.trim(),
          model: _model.text.trim(),
          year: year,
          color: _color.text.trim(),
          seats: _seats,
        ),
      );
      await widget.onSaved?.call();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Vehículo sincronizado con ShareWay.')),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _remoteError = 'No se pudo guardar el vehículo. Revisa los datos e inténtalo otra vez.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _continue() {
    if (widget.apiRepository != null && _step == 2) {
      _saveRemoteVehicle();
      return;
    }
    if (_step == 0 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Registro actualizado en esta demostración.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Tus datos', 'Documentos', 'Vehículo'];
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de conductor')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Paso ${_step + 1} de 3',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      titles[_step],
                      style: const TextStyle(
                        color: ShareWayColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_step + 1) / 3,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(8),
                  color: ShareWayColors.primary,
                  backgroundColor: ShareWayColors.pale,
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
                children: [
                  if (_step == 0) _personalDetails(context),
                  if (_step == 1)
                    widget.apiRepository == null
                        ? _documentsStep(context)
                        : _remoteDocumentsStep(context),
                  if (_step == 2) _vehicleStep(context),
                  if (_remoteError != null) ...[
                    const SizedBox(height: 12),
                    _InfoBanner(text: _remoteError!),
                  ],
                  if (_loadingRemoteData) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Atrás'),
                      ),
                    ),
                    const SizedBox(width: 9),
                  ],
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _saving ? null : _continue,
                      child: Text(
                        _saving
                            ? 'Guardando…'
                            : _step == 2
                            ? 'Guardar y enviar a revisión'
                            : 'Continuar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalDetails(BuildContext context) {
    final account = widget.account;
    if (widget.apiRepository != null && account != null) {
      final contact = account.emergencyContact;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos de tu cuenta',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Text(
            'Estos datos vienen del perfil autenticado.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 13),
          _ReadOnlyInfo(label: 'Nombre', value: account.fullName),
          _ReadOnlyInfo(label: 'Correo', value: account.email),
          _ReadOnlyInfo(label: 'Celular', value: account.phone),
          _ReadOnlyInfo(label: 'Licencia', value: account.licenseNumber),
          if (contact != null) ...[
            _ReadOnlyInfo(label: 'Contacto de emergencia', value: contact.name),
            _ReadOnlyInfo(label: 'Celular de emergencia', value: contact.phone),
            _ReadOnlyInfo(label: 'Parentesco', value: contact.relationship),
          ],
          const SizedBox(height: 8),
          const _InfoBanner(
            text: 'El API actual permite consultar estos datos, pero no editarlos desde esta pantalla.',
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tus datos de conductor',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 5),
        Text(
          'Completa tus datos para habilitar tu cuenta de conductor.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _input('Nombre completo', _name, required: true),
        _input('DNI', _dni, keyboardType: TextInputType.number, required: true),
        _input('N.° de licencia', _license, required: true),
        _input(
          'Celular',
          _phone,
          keyboardType: TextInputType.phone,
          required: true,
        ),
        _input(
          'Correo',
          _email,
          keyboardType: TextInputType.emailAddress,
          required: true,
        ),
        const SizedBox(height: 8),
        const _InfoBanner(
          text: 'Usaremos estos datos para verificar tu identidad y habilitación.',
        ),
      ],
    );
  }

  Widget _documentsStep(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Sube tus documentos',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 5),
      Text(
        'Foto o PDF · hasta 12 MB',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 15),
      for (final entry in _documents.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: _DocumentCard(
            name: entry.key,
            status: entry.value,
            fileName: entry.value == 'Pendiente'
                ? null
                : '${entry.key.toLowerCase().replaceAll(' ', '_')}.pdf',
            onUpload: () =>
                setState(() => _documents[entry.key] = 'En revisión'),
          ),
        ),
      const SizedBox(height: 5),
      const _InfoBanner(
        text: 'Los archivos de esta pantalla son de muestra. La carga real se conectará al servicio de conductores.',
      ),
    ],
  );

  Widget _remoteDocumentsStep(BuildContext context) {
    const requiredDocs = [
      ('Licencia de conducir', 'DRIVERS_LICENSE'),
      ('DNI', 'NATIONAL_ID'),
      ('Antecedentes penales', 'CRIMINAL_RECORD'),
      ('Tarjeta de propiedad', 'VEHICLE_REGISTRATION'),
    ];
    String labelStatus(String apiStatus) => switch (apiStatus) {
      'APPROVED' => 'Aprobado',
      'REJECTED' => 'Rechazado',
      _ => 'En revisión',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sube tus documentos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 5),
        Text(
          'PDF, JPG o PNG · máximo 5 MB',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 15),
        for (final item in requiredDocs)
          Builder(
            builder: (context) {
              DriverDocumentData? document;
              for (final candidate in _remoteDocuments) {
                if (candidate.type == item.$2) {
                  document = candidate;
                  break;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _DocumentCard(
                  name: item.$1,
                  status: document == null
                      ? 'Pendiente'
                      : labelStatus(document.status),
                  fileName: document == null || document.filename.isEmpty
                      ? null
                      : document.filename,
                  canPreview: false,
                  uploadBusy: _uploadingDocumentType == item.$2,
                  onUpload: () {
                    _uploadRemoteDocument(item.$1, item.$2);
                  },
                ),
              );
            },
          ),
        const SizedBox(height: 5),
        const _InfoBanner(
          text: 'El servicio devuelve el estado y el nombre del archivo. Todavía no hay una ruta para descargarlo o mostrar una vista previa.',
        ),
      ],
    );
  }

  Widget _vehicleStep(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Registra tu vehículo',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 5),
      Text(
        'Estos datos aparecerán a los pasajeros antes de abordar.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: _input('Marca', _brand, required: true)),
          const SizedBox(width: 9),
          Expanded(child: _input('Modelo', _model, required: true)),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _input(
              'Año',
              _year,
              keyboardType: TextInputType.number,
              required: true,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(child: _input('Color', _color, required: true)),
        ],
      ),
      _input('Placa', _plate, required: true),
      Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(
            children: [
              const Icon(
                Icons.airline_seat_recline_normal_rounded,
                color: ShareWayColors.primary,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Asientos para pasajeros',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: _seats > 1 ? () => setState(() => _seats--) : null,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              Text(
                '$_seats',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: _seats < 8 ? () => setState(() => _seats++) : null,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      const _InfoBanner(
        text: 'Un cambio de vehículo puede requerir una nueva verificación.',
      ),
    ],
  );

  Widget _input(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool required = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (value) => value == null || value.trim().isEmpty
                ? 'Completa este dato.'
                : null
          : null,
    ),
  );
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.name,
    required this.status,
    required this.fileName,
    required this.onUpload,
    this.canPreview = true,
    this.uploadBusy = false,
  });

  final String name;
  final String status;
  final String? fileName;
  final VoidCallback onUpload;
  final bool canPreview;
  final bool uploadBusy;

  @override
  Widget build(BuildContext context) {
    final isApproved = status == 'Aprobado';
    final color = isApproved
        ? ShareWayColors.success
        : status == 'En revisión'
        ? ShareWayColors.warning
        : status == 'Rechazado'
        ? ShareWayColors.error
        : ShareWayColors.muted;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, color: color, size: 19),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        fileName ?? 'Aún no cargado',
                        style: const TextStyle(
                          color: ShareWayColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(label: status, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: fileName == null || !canPreview
                      ? null
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Vista previa de $fileName (demo).'),
                          ),
                        ),
                  icon: const Icon(Icons.visibility_outlined, size: 15),
                  label: const Text('Ver archivo'),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: uploadBusy ? null : onUpload,
                  icon: uploadBusy
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file_rounded, size: 15),
                  label: Text(
                    uploadBusy
                        ? 'Subiendo…'
                        : fileName == null
                        ? 'Subir'
                        : 'Reemplazar',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyInfo extends StatelessWidget {
  const _ReadOnlyInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: TextFormField(
      initialValue: value.isEmpty ? 'No registrado' : value,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
    ),
  );
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ShareWayColors.primarySoft,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: ShareWayColors.primaryDark,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: ShareWayColors.primaryDark,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}

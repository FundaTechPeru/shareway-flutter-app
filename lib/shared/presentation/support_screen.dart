import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/shareway_components.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  static const _topics = [
    ('Pagos y cobros', Icons.credit_card_rounded),
    ('Cancelaciones y penalidades', Icons.cancel_outlined),
    ('Código de abordaje', Icons.qr_code_2_rounded),
    ('Seguridad en el viaje', Icons.shield_outlined),
    ('Mi cuenta', Icons.person_outline_rounded),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = _topics
        .where((topic) => topic.$1.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda y soporte')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            '¿En qué te ayudamos?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Busca un tema: pagos, cancelación…',
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Sobre tu último viaje',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const IconTile(icon: Icons.route_rounded),
              title: const Text(
                'Mié 7 oct · Lince a San Isidro',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Reportar un problema con este viaje',
                style: TextStyle(fontSize: 10),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showTopic('Ayuda con tu último viaje'),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Temas frecuentes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < topics.length; index++) ...[
                  ListTile(
                    leading: Icon(
                      topics[index].$2,
                      color: ShareWayColors.primary,
                      size: 19,
                    ),
                    title: Text(
                      topics[index].$1,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                    onTap: () => _showTopic(topics[index].$1),
                  ),
                  if (index < topics.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
                if (topics.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No encontramos temas con ese nombre.',
                      style: TextStyle(
                        color: ShareWayColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.call_rounded, color: ShareWayColors.error, size: 18),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '¿Estás en peligro? Llama al 105. Soporte no atiende emergencias.',
                    style: TextStyle(
                      color: ShareWayColors.error,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _showTopic('Chat con soporte'),
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text('Chatear con soporte'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showTopic('Llamada a soporte'),
            icon: const Icon(Icons.call_outlined, size: 18),
            label: const Text('Llamar'),
          ),
        ],
      ),
    );
  }

  void _showTopic(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title estará disponible al conectar el centro de soporte.',
        ),
      ),
    );
  }
}

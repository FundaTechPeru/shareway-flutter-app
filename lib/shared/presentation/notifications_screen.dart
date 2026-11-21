import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/shareway_components.dart';

enum _NoticeKind { trip, payment, account }

class _Notice {
  const _Notice({
    required this.title,
    required this.detail,
    required this.when,
    required this.icon,
    required this.kind,
    this.isNew = false,
  });

  final String title;
  final String detail;
  final String when;
  final IconData icon;
  final _NoticeKind kind;
  final bool isNew;
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _notices = [
    _Notice(
      title: 'Tu auto llega en 10 minutos',
      detail: 'Toyota Yaris gris plata · BKL-482',
      when: '7:01 a. m.',
      icon: Icons.directions_car_rounded,
      kind: _NoticeKind.trip,
      isNew: true,
    ),
    _Notice(
      title: 'El precio de tu viaje cambió',
      detail: 'Revisa el nuevo precio antes de salir.',
      when: '6:48 a. m.',
      icon: Icons.payments_outlined,
      kind: _NoticeKind.payment,
      isNew: true,
    ),
    _Notice(
      title: 'Reserva confirmada',
      detail: 'Mié 7 oct · Lince a San Isidro',
      when: '6:15 a. m.',
      icon: Icons.check_circle_outline_rounded,
      kind: _NoticeKind.trip,
    ),
    _Notice(
      title: 'Califica tu viaje del 30 sep',
      detail: 'Te quedan 20 horas para calificar.',
      when: 'Ayer, 8:05 a. m.',
      icon: Icons.star_outline_rounded,
      kind: _NoticeKind.trip,
    ),
    _Notice(
      title: 'Nueva solicitud recurrente',
      detail: 'Lun 12 oct · Lince a San Isidro',
      when: 'Dom, 4:00 p. m.',
      icon: Icons.repeat_rounded,
      kind: _NoticeKind.account,
    ),
  ];

  final Set<int> _readNotices = {};
  int _selectedFilter = 0;

  List<int> get _visibleNoticeIndexes {
    final kinds = [
      null,
      _NoticeKind.trip,
      _NoticeKind.payment,
      _NoticeKind.account,
    ];
    return List.generate(_notices.length, (index) => index)
        .where(
          (index) =>
              kinds[_selectedFilter] == null ||
              _notices[index].kind == kinds[_selectedFilter],
        )
        .toList();
  }

  void _markAllRead() => setState(
    () => _readNotices.addAll(List.generate(_notices.length, (index) => index)),
  );

  @override
  Widget build(BuildContext context) {
    final indexes = _visibleNoticeIndexes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
        actions: [
          IconButton(
            onPressed: _markAllRead,
            tooltip: 'Marcar como leídos',
            icon: const Icon(Icons.done_all_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                for (var index = 0; index < 4; index++) ...[
                  ChoiceChip(
                    label: Text(['Todos', 'Viajes', 'Pagos', 'Cuenta'][index]),
                    selected: _selectedFilter == index,
                    onSelected: (_) => setState(() => _selectedFilter = index),
                  ),
                  if (index < 3) const SizedBox(width: 7),
                ],
              ],
            ),
          ),
          Expanded(
            child: indexes.isEmpty
                ? const Center(
                    child: Text(
                      'No hay avisos en esta categoría.',
                      style: TextStyle(
                        color: ShareWayColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hoy',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: _markAllRead,
                            child: const Text('Marcar como leídos'),
                          ),
                        ],
                      ),
                      for (
                        var position = 0;
                        position < indexes.length;
                        position++
                      ) ...[
                        if (position == 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              'Anteriores',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        _noticeTile(context, indexes[position]),
                      ],
                      const SizedBox(height: 10),
                      const Text(
                        'Aquí guardamos tus avisos aunque no lleguen cuando estás sin conexión.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ShareWayColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _noticeTile(BuildContext context, int index) {
    final notice = _notices[index];
    final unread = notice.isNew && !_readNotices.contains(index);
    final tint = notice.kind == _NoticeKind.payment
        ? ShareWayColors.accent
        : notice.kind == _NoticeKind.account
        ? ShareWayColors.muted
        : ShareWayColors.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _readNotices.add(index)),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              IconTile(
                icon: notice.icon,
                color: tint,
                background: tint.withValues(alpha: 0.12),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notice.detail,
                      style: const TextStyle(
                        color: ShareWayColors.secondaryInk,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notice.when,
                      style: const TextStyle(
                        color: ShareWayColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ShareWayColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

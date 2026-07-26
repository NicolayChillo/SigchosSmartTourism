import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../viewmodels/notifications_viewmodel.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NotificationsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: vm.items.isEmpty
          ? const EmptyStateWidget(
              title: 'Sin notificaciones',
              description:
                  'Aquí verás las notificaciones push que recibas mientras usas la app.',
              icon: Icons.notifications_none_outlined,
            )
          : ListView.separated(
              itemCount: vm.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = vm.items[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: ColoresApp.primario,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(n.body),
                  trailing: Text(
                    '${n.fecha.hour.toString().padLeft(2, '0')}:${n.fecha.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
    );
  }
}

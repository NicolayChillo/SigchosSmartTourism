import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime fecha;

  const AppNotification({
    required this.title,
    required this.body,
    required this.fecha,
  });
}

/// Historial de notificaciones push recibidas durante la sesión actual
/// (no se persiste; el envío real se hace de forma manual desde Firebase
/// Console para efectos de esta demo académica).
class NotificationsViewModel extends ChangeNotifier {
  final List<AppNotification> _items = [];
  List<AppNotification> get items => List.unmodifiable(_items);
  int get unreadCount => _items.length;

  /// [autoInit] en false evita registrar el servicio real de notificaciones
  /// push (Firebase Messaging), útil en tests de widgets que no inicializan
  /// Firebase.
  NotificationsViewModel({bool autoInit = true}) {
    if (autoInit) {
      NotificationService.instance.init(onMessage: _handleMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _items.insert(
      0,
      AppNotification(
        title: notification.title ?? 'Sigchos Smart Tourist',
        body: notification.body ?? '',
        fecha: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

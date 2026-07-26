import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'sigchos_notifications',
  'Sigchos Smart Tourist',
  description: 'Notificaciones de la app de turismo de Sigchos',
  importance: Importance.high,
);

/// Debe ser una función top-level (no un método de clase) porque FCM la
/// ejecuta en un isolate aparte cuando llega una notificación en segundo
/// plano o con la app cerrada.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init({void Function(RemoteMessage message)? onMessage}) async {
    if (_initialized) return;
    _initialized = true;

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings: initSettings);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
      onMessage?.call(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onMessage?.call(message);
    });

    unawaited(_saveTokenForCurrentUser());
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      _saveTokenForCurrentUser();
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> _saveTokenForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({'fcmToken': token});
    } catch (_) {
      // Falla silenciosa: el token no es crítico para el funcionamiento de la app.
    }
  }
}

void unawaited(Future<void> future) {}

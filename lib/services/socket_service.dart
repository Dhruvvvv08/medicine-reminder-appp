import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/services/notification_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;

  factory SocketService() => _instance;
  SocketService._internal();

  void initializeSocket() {
    if (_isInitialized) return;

    String token = SharedPref.pref?.getString(Preferences.token) ?? "";
    String userId = SharedPref.pref?.getString(Preferences.id) ?? "";

    print('🔌 Initializing socket with userId: $userId');

    socket = IO.io('http://13.126.206.90:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': token},
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 10000,
      'reconnectionAttempts': 20,
    });

    _setupSocketListeners();
    socket.connect();
    _isInitialized = true;
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      print('🟢 Socket Connected: ${socket.id}');
      _joinUserRoom();
    });

    socket.onDisconnect((_) {
      print('🔴 Socket Disconnected');
    });

    socket.onError((error) {
      print('⚠️ Socket Error: $error');
    });

    socket.onReconnect((_) {
      print('🔄 Socket Reconnected');
      _joinUserRoom();
    });

    socket.onConnectError((error) {
      print('❌ Connection Error: $error');
    });

    socket.on('notification', (data) {
      print('📩 Received notification data: $data');
      _handleNotification(data);
    });
  }

  void _joinUserRoom() {
    String userId = SharedPref.pref?.getString(Preferences.id) ?? "";
    if (userId.isNotEmpty) {
      socket.emit('join', {'userId': userId});
      print('✅ Joined room for user: $userId');
    } else {
      print('❌ User ID missing, cannot join room');
    }
  }

  Future<void> _handleNotification(dynamic data) async {
    try {
      String title = data['title'] ?? 'Medicine Reminder';
      String message = data['body'] ?? 'Time to take your medicine';
      String type = data['type'] ?? 'reminder';
      String reminderId = data['reminderId'] ?? '';
      print(reminderId);

      await _notificationService.showNotificationNow(
        title: title,
        body: message,
        reminderid: reminderId.toString(),
        payload:
            {
              
              'type': type,
              'reminderId': reminderId,
              'data': data.toString(),
            }.toString(),
      );

      print('✅ Notification shown');
    } catch (e, stackTrace) {
      print('❌ Notification error: $e');
      print(stackTrace);
    }
  }

  void reconnect() {
    if (!socket.connected) {
      socket.connect();
    }
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
    _isInitialized = false;
  }

  bool isConnected() => socket.connected;

  void emitEvent(String eventName, dynamic data) {
    if (socket.connected) {
      socket.emit(eventName, data);
    } else {
      print('❌ Cannot emit: Socket not connected');
    }
  }

  void cleanup() {
    disconnect();
    _isInitialized = false;
  }

  void sendTestEvent() {
    emitEvent('testEvent', {
      'message': 'Hello from Flutter!',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

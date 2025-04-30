import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/services/notification_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void initializeSocket() {
    if (_isInitialized) return;

    String token = SharedPref.pref!.getString(Preferences.token) ?? "";
    String userId = SharedPref.pref!.getString(Preferences.id) ?? "";

    print('🔌 Initializing socket with userId: $userId');

    socket = IO.io('http://192.168.29.249:3002', {
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': token},
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
      'reconnectionAttempts': 5,
    });

    _setupSocketListeners();
    socket.connect();
    _isInitialized = true;
  }

  void _setupSocketListeners() {
    // Connection event
    socket.onConnect((_) {
      print('🟢 Socket Connected: ${socket.id}');
      _joinUserRoom();
    });

    // Disconnect event
    socket.onDisconnect((_) {
      print('🔴 Socket Disconnected');
    });

    // Error handling
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

    // Notification event
    // socket.on('notification', (data) {
    //   print('📩 Received notification data: $data');
    //   if (data is Map) {
    //     print('📝 Notification details:');
    //     print('  - Title: ${data['title']}');
    //     print('  - Message: ${data['message']}');
    //     print('  - Type: ${data['type']}');
    //     print('  - ReminderId: ${data['reminderId']}');
    //   }
    //   _handleNotification(data);
    // });


    socket.onAny((event, handler){
  print("recicved event or$event ");
    });
  }

  void _joinUserRoom() {
    String userId = SharedPref.pref!.getString(Preferences.id) ?? "";
    if (userId.isNotEmpty) {
      print('👤 Attempting to join room for user: $userId');
      socket.emit('join', {'userId': userId});
      print('✅ Join request sent for user: $userId');
    } else {
      print('❌ Cannot join room: userId is empty');
    }
  }

  void _handleNotification(dynamic data) async {
    try {
      print('🔔 Processing notification...');
      
      if (data == null) {
        print('❌ Notification data is null');
        return;
      }

      String title = data['title'] ?? 'Medicine Reminder';
      String message = data['message'] ?? 'Time to take your medicine';
      String type = data['type'] ?? 'reminder';
      String reminderId = data['reminderId'] ?? '';

      print('📨 Sending notification:');
      print('  - Title: $title');
      print('  - Message: $message');
      print('  - Type: $type');
      print('  - ReminderId: $reminderId');

      await _notificationService.showNotificationNow(
        title: title,
        body: message,
        payload: {
          'type': type,
          'reminderId': reminderId,
          'data': data.toString(),
        }.toString(),
      );

      print('✅ Notification sent successfully');
    } catch (e, stackTrace) {
      print('❌ Error handling notification: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void reconnect() {
    if (!socket.connected) {
      print('🔄 Attempting to reconnect socket...');
      socket.connect();
    }
  }

  void disconnect() {
    if (socket.connected) {
      print('🔌 Disconnecting socket...');
      socket.disconnect();
    }
    _isInitialized = false;
  }

  bool isConnected() {
    return socket.connected;
  }

  // Method to emit events to the server if needed
  void emitEvent(String eventName, dynamic data) {
    if (socket.connected) {
      print('📤 Emitting event: $eventName with data: $data');
      socket.emit(eventName, data);
    } else {
      print('❌ Cannot emit event: Socket not connected');
    }
  }

  // Call this when user logs out
  void cleanup() {
    print('🧹 Cleaning up socket service...');
    disconnect();
    _isInitialized = false;
  }

  // Add a method to emit test event
  void sendTestEvent() {
    if (socket.connected) {
      print('📤 Sending test event');
      socket.emit('testEvent', {
        'message': 'Hello from Flutter!',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } else {
      print('❌ Socket not connected');
    }
  }
}

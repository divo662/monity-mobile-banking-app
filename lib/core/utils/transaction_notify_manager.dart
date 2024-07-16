import 'package:flutter/foundation.dart';

import '../services/notification_services_settings.dart';
import 'custom_inapp_notification_setting.dart';

class TransactionNotificationManager {
  final RealtimeService _realtimeService = RealtimeService();
  final NotificationService _notificationService = NotificationService();

  TransactionNotificationManager() {
    _notificationService.initNotification();
  }

  void startListening(String userId) {
    if (kDebugMode) {
      print("Starting to listen for transactions for user: $userId");
    }
    _realtimeService.listenForTransactionChanges(
      userId,
      _handleSenderNotification,
      _handleReceiverNotification,
    );
  }

  void _handleSenderNotification(Map<String, dynamic> transaction) {
    if (kDebugMode) {
      print("Handling sender notification: $transaction");
    }
    String recipientName = '${transaction['recipient_first_name']} ${transaction['recipient_last_name']}' ;
    if (kDebugMode) {
      print(recipientName);
    }
    double amount = transaction['amount'];
    if (kDebugMode) {
      print(amount);
    }
    _notificationService.showNotification(
      title: 'Money Sent',
      body: 'You sent \$${amount.toStringAsFixed(2)} to $recipientName',
    );
  }

  void _handleReceiverNotification(Map<String, dynamic> transaction) {
    if (kDebugMode) {
      print("Handling receiver notification: $transaction");
    }
    String senderName = '${transaction['sender_first_name']} ${transaction['sender_last_name']}';
    if (kDebugMode) {
      print(senderName);
    }
    double amount = transaction['amount'];
    if (kDebugMode) {
      print(amount);
    }
    _notificationService.showNotification(
      title: 'Money Received',
      body: 'You received \$${amount.toStringAsFixed(2)} from $senderName',
    );
  }

  void dispose() {
    _realtimeService.dispose();
  }
}

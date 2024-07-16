import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  StreamSubscription? _subscription;

  void listenForTransactionChanges(
      String userId,
      Function(Map<String, dynamic>) onSenderNotification,
      Function(Map<String, dynamic>) onReceiverNotification,
      ) {
    if (kDebugMode) {
      print("Subscribing to transaction changes for user: $userId");
    }
    _subscription = supabaseClient
        .from('realtime_transaction_logs')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> events) {
      if (kDebugMode) {
        print("Received ${events.length} events");
      }
      for (final event in events) {
        try {
          if (event['sender_profile_id'] == userId) {
            if (kDebugMode) {
              print("Event is for sender: $event");
            }
            onSenderNotification(event);
          } else if (event['recipient_profile_id'] == userId) {
            if (kDebugMode) {
              print("Event is for receiver: $event");
            }
            onReceiverNotification(event);
          }
        } catch (error) {
          if (kDebugMode) {
            print('Error handling transaction change: $error');
          }
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

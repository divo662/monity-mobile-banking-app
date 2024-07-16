import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

class ProfileInfoDb {
  Future<bool> addDataToProfileInfo({
    required String homeAddress,
    required String dateOfBirth,
    required String gender,
    required String nationality,
    required String stateOfOrigin,
    required String lga,
    required String bvn,
    required String phoneNumber,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final profileId = user.id;

      // Fetch user metadata (first_name, last_name, email)
      final firstName = user.userMetadata!['first_name'] as String?;
      final lastName = user.userMetadata!['last_name'] as String?;
      final email = user.email;

      // Generate random 11-digit account number
      String accountNumber = _generateAccountNumber();

      // Initial balance
      double initialBalance = 1000.0;

      final response = await supabase
          .from("profile_info")
          .upsert([
        {
          'profile_id': profileId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'home_address': homeAddress,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'nationality': nationality,
          'state_of_origin': stateOfOrigin,
          'lga': lga,
          'bvn': bvn,
          'phone_number': phoneNumber,
          'account_number': accountNumber,
          'balance': initialBalance,
        }
      ]);

      if (response == null) {
        throw Exception('Failed to connect to the database.');
      }

      if (response.error != null) {
        if (response.error!.code == '42P07') {
          throw Exception('A profile with this ID already exists.');
        } else {
          throw Exception('Failed to update profile info: ${response.error!.message}');
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding data to profile info: $e');
      }
      return false;
    }
  }

  String _generateAccountNumber() {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    List<int> digits = List.generate(11, (_) => random.nextInt(10));
    String accountNumber = digits.join();
    return accountNumber;
  }

  Future<bool> addPasscode(String passcode) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final userId = user.id;

      final response = await supabase
          .from("user_passcodes")
          .upsert([
        {
          'user_id': userId,
          'passcode': passcode,
        }
      ]);

      if (response == null) {
        throw Exception('Failed to connect to the database.');
      }

      if (response.error != null) {
        throw Exception('Failed to add passcode: ${response.error!.message}');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding passcode: $e');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfileInfo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final profileId = user.id;
      final response = await supabase
          .from('profile_info')
          .select()
          .eq('profile_id', profileId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Profile info not found for profile ID: $profileId');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile info: $e');
      }
      return null;
    }
  }

  Future<bool> topUpBalance(double amount) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final profileId = user.id;
      final response = await supabase
          .from('profile_info')
          .select('balance')
          .eq('profile_id', profileId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to fetch profile info.');
      }

      double currentBalance = response['balance'];
      double newBalance = currentBalance + amount;

      final updateResponse = await supabase
          .from('profile_info')
          .update({'balance': newBalance})
          .eq('profile_id', profileId);

      if (updateResponse.error != null) {
        throw Exception('Failed to update balance: ${updateResponse.error!.message}');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error topping up balance: $e');
      }
      return false;
    }
  }

  Future<double> getUserBalance(String accountNumber) async {
    try {
      final response = await supabase
          .from('profile_info')
          .select('balance')
          .eq('account_number', accountNumber)
          .single();

      if (response['balance'] != null) {
        return response['balance'];
      } else {
        throw Exception('Balance not found for the given account number');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user balance: $e');
      }
      throw Exception('Failed to fetch user balance: $e');
    }
  }

}

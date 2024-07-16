import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/form_text.dart';
import '../../../widgets/small_text.dart';
import '../../home directory/supabase/profile_info_db.dart';
import '../../home directory/screens/bottom_nav_bar.dart';
import '../widgets/receipt_widget.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _recipientFullName;
  bool _isLoading = false;
  bool _isSending = false;
  String senderAccountNumber = "";
  Map<String, Map<String, dynamic>>? _recipientInfoCache = {};
  String recipientAccountNumber = ""; //
  final profileInfoDb = ProfileInfoDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                NavigationHelper.navigateBack(
                  context,
                );
              },
              child: Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.transparent,
                    border:
                        Border.all(color: AppColor.primaryColor, width: 1.5.w)),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            SmallText(
              text: 'Transfer Money',
              color: AppColor.secondTextColor,
              fontWeight: FontWeight.bold,
              size: 24.sp,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText(
                text: 'Monity',
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
                size: 24.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
               Text(
                'Enter Account Number:',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppStrings.rubik,
                  color: AppColor.secondTextColor
                ),
              ),
              SizedBox(height: 8.h),
              FormText(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: _accountNumberController,
                maxLength: 11,
                hintText: "Input account number",
                hintStyle: TextStyle(
                    color: AppColor.greyColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik),
                // controller: _emailController,
              ),
               SizedBox(height: 16.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  DefaultButton(
                    onpressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      String accountNumber =
                          _accountNumberController.text.trim();
                      if (accountNumber.isEmpty) {
                        _showDialog('Empty Input',
                            'Please Input the recipient account number',
                            (){
                              NavigationHelper.navigateBack(context);
                            }
                           );
                      } else {
                        Map<String, dynamic>? recipientInfo =
                            await fetchRecipientInfo(accountNumber);
                        if (recipientInfo != null) {
                          setState(() {
                            _recipientFullName = recipientInfo['full_name'];
                          });
                        } else {
                          _showDialog('Recipient Not Found',
                              'The account number entered does not exist.',
                                  (){
                                NavigationHelper.navigateBack(context);
                              }
                          );
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    title: 'Confirm Account',
                    buttonWidth: double.infinity,
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 6.0,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              if (_recipientFullName != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 90.h,
                      width: 356.w,
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 8),
                      decoration: BoxDecoration(
                        color: AppColor.whiteTextColor,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(1, 1),
                            blurRadius: 1.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundImage:
                                const AssetImage(AppIcons.appIconSmaller),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            _recipientFullName!,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppStrings.rubik,
                              color: AppColor.secondTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 8.h),
                    FormText(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: _amountController,
                      hintText: 'Enter Amount',
                      hintStyle: TextStyle(
                        color: AppColor.greyColor5,
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        fontFamily: AppStrings.rubik,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FormText(
                      textColor: AppColor.textColor,
                      keyboardType: TextInputType.text,
                      controller: _passcodeController,
                      obscureText: true,
                      maxLength: 4,
                      textInputAction: TextInputAction.done,
                      hintText: 'Enter 4-digit passcode',
                      hintStyle: TextStyle(
                        color: AppColor.greyColor5,
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        fontFamily: AppStrings.rubik,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        DefaultButton(
                          onpressed: () async {
                            setState(() {
                              _isSending = true;
                            });

                            try {
                              // Fetch sender's account number using ProfileInfoDb
                              final profileInfoDb = ProfileInfoDb();
                              final profileInfo =
                                  await profileInfoDb.getUserProfileInfo();

                              if (profileInfo == null ||
                                  profileInfo['account_number'] == null) {
                                throw Exception(
                                    "Sender account number not found");
                              }

                              String senderAccountNumber =
                                  profileInfo['account_number'];
                              String recipientAccountNumber =
                                  _accountNumberController.text.trim();
                              double amount = double.tryParse(
                                      _amountController.text.trim()) ??
                                  0.0;
                              String passcode = _passcodeController.text.trim();

                              // Check if recipient info is already cached
                              Map<String, dynamic>? recipientInfo =
                                  _recipientInfoCache != null
                                      ? _recipientInfoCache![
                                          recipientAccountNumber]
                                      : null;

                              // If recipient info is not cached, fetch it
                              if (recipientInfo == null) {
                                recipientInfo = await fetchRecipientInfo(
                                    recipientAccountNumber);
                                if (recipientInfo == null) {
                                  _showSnackBar("Recipient account not found");
                                  setState(() {
                                    _isSending = false;
                                  });
                                  return;
                                } else {
                                  // Cache the recipient info
                                  _recipientInfoCache![recipientAccountNumber] =
                                      recipientInfo;
                                }
                              }
                              // Call sendMoney with cached recipient info
                              final success = await sendMoney(
                                  senderAccountNumber: senderAccountNumber,
                                  recipientAccountNumber:
                                      recipientAccountNumber,
                                  amount: amount,
                                  passcode: passcode,
                                  context: context);

                              if (success == true) {
                                // Show success dialog

                                return;
                              } else {
                                // Show error dialog for sending money
                                _showDialog('Error',
                                    'Failed to send money. Please try again later.',
                                        (){
                                      NavigationHelper.navigateBack(context);
                                    }
                                );
                              }
                            } catch (e) {
                              // Handle generic errors
                              _showSnackBar(
                                  "Failed to send money. Please try again later.");
                            } finally {
                              setState(() {
                                _isSending = false;
                              });
                            }
                          },
                          title: 'Send Money',
                          buttonWidth: double.infinity,
                        ),
                        if (_isSending)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 6.0,
                            ),
                          ),
                        if (_isSending)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 6.0,
                            ),
                          ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> fetchRecipientInfo(String accountNumber) async {
    if (accountNumber.isEmpty) {
      return null;
    }

    if (_recipientInfoCache!.containsKey(accountNumber)) {
      return _recipientInfoCache![accountNumber];
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call Supabase RPC function
      final response = await supabase.rpc("get_profile_info",
          params: {'account_number_param': accountNumber});

      // Log the response for debugging
      if (kDebugMode) {
        print('RPC Response: $response');
      }
      // Handle successful response
      if (response != null && response is List && (response).isNotEmpty) {
        final userData = response[0] as Map<String, dynamic>;
        final firstName = userData['first_name'] as String;
        final lastName = userData['last_name'] as String;
        final recipientInfo = {
          'full_name': '$firstName $lastName',
        };

        // Cache the fetched info
        _recipientInfoCache ??= {};
        _recipientInfoCache![accountNumber] = recipientInfo;

        return recipientInfo;
      } else {
        _showSnackBar("Recipient with account number $accountNumber not found");
        if (kDebugMode) {
          print('Recipient with account number $accountNumber not found');
        }
        return null;
      }
    } on AuthException catch (e) {
      _handleAuthError(e);
      if (kDebugMode) {
        print('Error fetching recipient account: $e');
      }
      return null;
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Unexpected error: $_");
      }
      _showSnackBar("No internet connection. Please check your network.");
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      _showSnackBar("An unexpected error occurred. Please try again later.");
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool?> sendMoney({
    required String recipientAccountNumber,
    required double amount,
    required String passcode,
    required BuildContext context,
    required String senderAccountNumber,
  }) async {
    try {
      // Fetch sender's account number using ProfileInfoDb
      final profileInfoDb = ProfileInfoDb();
      final profileInfo = await profileInfoDb.getUserProfileInfo();
      String senderAccountNumber = profileInfo!['account_number'];

      // Validate input parameters
      if (senderAccountNumber.isEmpty ||
          recipientAccountNumber.isEmpty ||
          amount <= 0 ||
          passcode.isEmpty) {
        _showSnackBar("Missing input value");
        throw Exception('Invalid input parameters');
      }

      // Validate the passcode first
      bool isPasscodeValid = await _validatePasscode(passcode);
      if (!isPasscodeValid) {
        _showSnackBar("Invalid passcode");
        return false;
      }

      // Fetch recipient info to validate account number
      Map<String, dynamic>? recipientInfo =
          _recipientInfoCache?[recipientAccountNumber];
      if (recipientInfo == null) {
        recipientInfo = await fetchRecipientInfo(recipientAccountNumber);
        if (recipientInfo == null) {
          _showSnackBar("Recipient account not found");
          return false;
        }
      }

      // Fetch sender's balance to check for sufficient funds
      double senderBalance =
          await profileInfoDb.getUserBalance(senderAccountNumber);
      if (senderBalance < amount) {
        _showSnackBar("Insufficient funds");
        return false;
      }

      // Call Supabase RPC function to update the balance
      final response = await supabase.rpc("update_balance", params: {
        'sender_account_number': senderAccountNumber,
        'recipient_account_number': recipientAccountNumber,
        'amount': amount,
      });

      // Log the response for debugging
      if (kDebugMode) {
        print('RPC Response: $response');
      }

      if (response == true) {
        String transactionReference = _generateTransactionReference();
        DateTime transactionDate = DateTime.now();
        await _storeTransactionDetails(
          senderName:
              "${profileInfo['first_name']} ${profileInfo['last_name']}",
          receiverName: recipientInfo['full_name'],
          amount: amount,
          transactionReference: transactionReference,
          transactionStatus: "Success",
          transactionDate: transactionDate,
        );

        _showSnackBar(
            'Money sent successfully to ${recipientInfo['full_name']}.');

        // Navigate to the ReceiptScreen
        NavigationHelper.navigateToPage(
          context,
          ReceiptScreen(
            senderName:
                "${profileInfo['first_name']} ${profileInfo['last_name']}",
            receiverName: recipientInfo['full_name'],
            amount: amount,
            transactionReference: transactionReference,
            transactionStatus: "Success",
            transactionDate: transactionDate,
            onpressed: () {
              NavigationHelper.navigateToPage(
                  context,
                  BottomNavbarScreen(
                    currentPage: 0,
                  ));
            },
          ),
        );
        return true;
      } else {
        _showSnackBar('Error sending money. Please try again later.');
        return false;
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('Error sending money: $e');
      }
      return false;
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Unexpected error: $_");
      }
      _showSnackBar("No internet connection. Please check your network.");
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      _showSnackBar("Unexpected error occurred. Please try again later.");
      return false;
    }
  }

  String _generateTransactionReference() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        20, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

// Passcode validation function
  Future<bool> _validatePasscode(String passcode) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final response = await Supabase.instance.client
          .from('user_passcodes')
          .select('passcode')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to fetch passcode.');
      }

      return response['passcode'] == passcode;
    } catch (e) {
      if (kDebugMode) {
        print('Error validating passcode: $e');
      }
      return false;
    }
  }

  void _handleAuthError(AuthException e) {
    String errorMessage = "An error occurred. Please try again later.";
    if (e.statusCode == '400') {
      errorMessage = "An error occurred. Please try again later.";
    } else if (e.message.contains('AuthRetryableFetchError')) {
      errorMessage = "Temporary network issue. Please try again later.";
    }
    _showSnackBar(errorMessage);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        content: Container(
          width: 190.w,
          height: 56.h,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(45),
            color: Colors.redAccent,
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  Future _showDialog(String message, String subtitle, VoidCallback onpressed){
    return  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: AppStrings.rubik,
              color: AppColor.primaryColor),
        ),
        content: Text(
            subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: AppStrings.rubik,
              color: AppColor.subColor,
              fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: onpressed,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

Future<void> _storeTransactionDetails({
  required String senderName,
  required String receiverName,
  required double amount,
  required String transactionReference,
  required String transactionStatus,
  required DateTime transactionDate,
}) async {
  final response = await supabase.from('transaction_receipt').insert({
    'sender_name': senderName,
    'receiver_name': receiverName,
    'transaction_amount': amount,
    'transaction_reference': transactionReference,
    'transaction_status': transactionStatus,
    'transaction_date': transactionDate.toIso8601String(),
  }).maybeSingle();

  if (response != null) {
    throw Exception('Failed to store transaction details: $response');
  }
}

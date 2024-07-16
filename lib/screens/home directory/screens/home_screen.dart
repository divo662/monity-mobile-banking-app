import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:monity/screens/transaction%20directory/screens/send_money_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../../core/utils/transaction_notify_manager.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/form_text.dart';
import '../../../widgets/small_text.dart';
import '../../auth directory/login auth directory/screens/login_screen.dart';
import '../../transaction directory/widgets/transaction_widget.dart';
import '../supabase/profile_info_db.dart';
import 'package:timezone/timezone.dart' as tz;

import 'account setup page/profile_setup_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<User?> _userFuture;
  bool isProfileSetup = false;
  bool isPasscodeSetup = false;
  Map<String, dynamic>? _profileInfo;
  bool _isLoading = true;
  bool _isBalanceHidden = true;
  bool _isPasscodeInvalid = false;
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late TransactionNotificationManager _notificationManager;
  final profileInfoDb = ProfileInfoDb();

  @override
  void initState() {
    super.initState();
    _userFuture = _getCurrentUser();
    _fetchProfileInfo();
    _loadUserData();
    _userFuture.then((user) {
      if (user != null) {
        _notificationManager = TransactionNotificationManager();
        _notificationManager.startListening(user.id);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _passcodeController.dispose();
    _notificationManager.dispose();
    super.dispose();
  }

  void _loadUserData() {
    setState(() {
      _userFuture = _getCurrentUser();
    });
  }

  Future<User?> _getCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await _checkUserProfileSetup(user.id);
      await _checkUserPasscodeSetup(user.id);
    }
    return user;
  }

  Future<void> _fetchProfileInfo() async {
    try {
      final profileInfo = await profileInfoDb.getUserProfileInfo();
      setState(() {
        _profileInfo = profileInfo;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile info: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkUserProfileSetup(String userId) async {
    final response = await Supabase.instance.client
        .from('profile_info')
        .select()
        .eq('profile_id', userId)
        .maybeSingle();
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.isNotEmpty) {
      if (kDebugMode) {
        print(response);
      }
      setState(() {
        isProfileSetup = true;
      });
    }
    if (kDebugMode) {
      print(response);
    }
  }

  Future<void> _checkUserPasscodeSetup(String userId) async {
    final response = await Supabase.instance.client
        .from('user_passcodes')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.isNotEmpty) {
      if (kDebugMode) {
        print(response);
      }
      setState(() {
        isPasscodeSetup = true;
      });
    }
    if (kDebugMode) {
      print(response);
    }
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceHidden = !_isBalanceHidden;
    });
  }

  String _formatBalance(double balance) {
    final formatCurrency = NumberFormat.currency(
        symbol: "\u20A6", decimalDigits: 2, locale: "en_NG");
    return formatCurrency.format(balance);
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

  Future<void> _showTopUpBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 600.h,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Top Up Balance",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: AppColor.secondTextColor,
                              fontFamily: AppStrings.rubik,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                NavigationHelper.navigateBack(context);
                              },
                              icon: const Icon(CupertinoIcons.xmark)),
                        ],
                      ),
                      Text(
                        "Monity Bank Account",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColor.secondTextColor,
                          fontFamily: AppStrings.rubik,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(
                            text: _profileInfo!['account_number'] ??
                                'no account number',
                            size: 22.sp,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          DefaultButton(
                              onpressed: () {
                                Clipboard.setData(ClipboardData(
                                    text:
                                        _profileInfo!['account_number'] ?? ''));
                              },
                              title: "Copy",
                              buttonWidth: 159.w),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "-------------------- or ---------------------",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColor.secondTextColor,
                            fontFamily: AppStrings.rubik,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Top up with Monity top-up.",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColor.secondTextColor,
                          fontFamily: AppStrings.rubik,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: Container(
                          width: 350.w,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide.none,
                                  right: BorderSide.none,
                                  left: BorderSide.none,
                                  bottom: BorderSide(
                                      color: Colors.black, width: 2.5.w))),
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              controller: _amountController,
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Input Amount',
                                hintStyle: TextStyle(
                                  color: AppColor.greyColor9,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  fontFamily: AppStrings.rubik,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
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
                      if (_isPasscodeInvalid)
                        Text(
                          "Wrong PIN",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            fontFamily: AppStrings.rubik,
                          ),
                        ),
                      SizedBox(height: 20.h),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: DefaultButton(
                                onpressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                    _isPasscodeInvalid = false;
                                  });
                                  bool isValid = await _validatePasscode(
                                      _passcodeController.text);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (isValid) {
                                    await _validateAndTopUp(context);
                                    _amountController.clear();
                                    _passcodeController.clear();
                                  } else {
                                    setState(() {
                                      _isPasscodeInvalid = true;
                                    });
                                  }
                                },
                                title: "Top Up",
                                buttonWidth: double.infinity,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _validateAndTopUp(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _isPasscodeInvalid = false;
    });

    // Validate amount input
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar("Please enter a valid top-up amount");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String passcode = _passcodeController.text;

    try {
      if (await _validatePasscode(passcode)) {
        await profileInfoDb.topUpBalance(amount);
      } else {
        setState(() {
          _isPasscodeInvalid = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error topping up balance: $e');
      }
      _showSnackBar("Failed to top up balance. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
        _amountController.clear();
        _passcodeController.clear();
        Navigator.pop(context); // Close the bottom sheet
        _showSnackBar("Successfully topped up");
      });
    }
  }

  Future<bool> _validatePasscode(String passcode) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      final response = await supabase
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

  Future<List<Map<String, dynamic>>> fetchTransactions(String profileId) async {
    final response = await supabase
        .from('transaction_logs_with_names')
        .select('*')
        .or('sender_profile_id.eq.$profileId,recipient_profile_id.eq.$profileId')
        .order('timestamp', ascending: false)
        .limit(5);

    for (var transaction in response) {
      DateTime.parse(transaction['timestamp']).toUtc();
    }

    return response;
  }

  List<Map<String, dynamic>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions, String userId) {
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};

    for (var transaction in transactions) {
      if (transaction['sender_profile_id'] == userId ||
          transaction['recipient_profile_id'] == userId) {
        final timestamp = DateTime.parse(transaction['timestamp']);
        final dateKey = _formatDateKey(timestamp);

        if (groupedTransactions.containsKey(dateKey)) {
          groupedTransactions[dateKey]!.add(transaction);
        } else {
          groupedTransactions[dateKey] = [transaction];
        }
      }
    }

    final sortedGroups = groupedTransactions.entries.toList()
      ..sort((a, b) {
        final aDate = DateTime.parse(a.value.first['timestamp']);
        final bDate = DateTime.parse(b.value.first['timestamp']);
        return bDate
            .compareTo(aDate);
      });

    return sortedGroups.map((entry) {
      return {
        'date': entry.key,
        'transactions': entry.value,
      };
    }).toList();
  }

  String _formatDateKey(DateTime date) {
    final westAfricaTimeZone = tz.getLocation('Africa/Lagos');
    final now = tz.TZDateTime.now(westAfricaTimeZone);
    final today = tz.TZDateTime(westAfricaTimeZone, now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = tz.TZDateTime.from(date.toUtc(), westAfricaTimeZone);
    final transactionDateOnly = tz.TZDateTime(westAfricaTimeZone, transactionDate.year, transactionDate.month, transactionDate.day);

    if (transactionDateOnly == today) {
      return 'Today';
    } else if (transactionDateOnly == yesterday) {
      return 'Yesterday';
    } else if (transactionDateOnly.isAfter(today)) {
      // This shouldn't happen, but just in case
      final formattedDate = DateFormat('MMMM d, yyyy').format(transactionDate);
      return formattedDate;
    } else {
      final formattedDate = DateFormat('MMMM d, yyyy').format(transactionDate);
      return formattedDate;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColor.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Network /Error: We ran into error, please try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColor.secondTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      fontFamily: AppStrings.rubik),
                ),
                SizedBox(
                  height: 10.h,
                ),
                DefaultButton(
                    onpressed: () {
                      _loadUserData();
                    },
                    title: "Refresh",
                    buttonWidth: double.infinity)
              ],
            )),
          );
        } else {
          final user = snapshot.data!;
          if (kDebugMode) {
            print(
                '${user.userMetadata!['first_name']} ${user.userMetadata!['last_name']}');
          }
          final userName =
              '${user.userMetadata!['first_name']} ${user.userMetadata!['last_name']}';

          return RefreshIndicator(
            onRefresh: () async {
              _loadUserData();
            },
            color: AppColor.primaryColor,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            backgroundColor: AppColor.bg,
            child: Scaffold(
              backgroundColor: AppColor.bg,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300.h,
                      child: Stack(children: [
                        Container(
                          height: 280.h,
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              top: 35.sp, left: 12.sp, right: 12.sp),
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50.r),
                                bottomRight: Radius.circular(50.r),
                              )),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: AppStrings.rubik,
                                          color: AppColor.greyColor1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      userName,
                                      style: TextStyle(
                                          fontSize: 27.sp,
                                          fontFamily: AppStrings.rubik,
                                          color: AppColor.whiteTextColor,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 50.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.4)),
                                    child: Image.asset(
                                      AppIcons.notifyBell,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 160,
                          right: 10,
                          bottom: 0,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  height: 120.h,
                                  width: 356.w,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8),
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteTextColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(2, 1),
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: FutureBuilder<Map<String, dynamic>?>(
                                    future: profileInfoDb.getUserProfileInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        // Handle specific error types
                                        if (snapshot.error
                                            is PostgrestException) {
                                          final error = snapshot.error
                                              as PostgrestException;
                                          if (error.code == "PGRST301") {
                                            // Token expired
                                            return _buildErrorScreen(
                                              context,
                                              'Your session has expired. Please log in again.',
                                              onRetry: () {
                                                // Logic to log the user out or refresh token
                                                _redirectToLogin(context);
                                              },
                                            );
                                          } else {
                                            return _buildErrorScreen(
                                              context,
                                              'Error: ${error.message}',
                                            );
                                          }
                                        }
                                        return _buildErrorScreen(
                                          context,
                                          'An unexpected error occurred. Please try again.',
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Center(
                                          child: Text(
                                            'No profile data available, set up account or reload page.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppStrings.rubik,
                                              fontSize: 16.sp,
                                              color: AppColor.secondTextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }

                                      // Successfully fetched data
                                      final profileInfo = snapshot.data!;
                                      return _buildProfileInfo(profileInfo);
                                    },
                                  ),
                                ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.all(13.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          if (!isProfileSetup || !isPasscodeSetup)
                            Container(
                              height: 120.h,
                              width: double.infinity,
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                  color: AppColor.whiteTextColor,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(
                                      text: "Set up your account to continue",
                                      size: 17.sp,
                                      color: AppColor.secondTextColor,
                                      fontWeight: FontWeight.w500),
                                  SmallText(
                                      text: "Complete Profile Setup",
                                      size: 14.sp,
                                      color: AppColor.subColor,
                                      fontWeight: FontWeight.w500),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      NavigationHelper.navigateToPage(
                                          context, const ProfileSetupPage());
                                    },
                                    child: Container(
                                      height: 40.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                          color: AppColor.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5.r)),
                                      child: Center(
                                        child: SmallText(
                                            text: "Proceed",
                                            size: 14.sp,
                                            color: AppColor.whiteTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                    text: "Services",
                                    size: 18.sp,
                                    color: AppColor.secondTextColor,
                                    fontWeight: FontWeight.w500),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultButton(
                                        onpressed: () {
                                          NavigationHelper.navigateToPage(
                                              context, const SendMoneyScreen());
                                        },
                                        title: "Send 💸",
                                        buttonWidth: 165.w),
                                    DefaultButton(
                                        onpressed: () async {
                                          await _showTopUpBottomSheet();
                                        },
                                        title: "Top up 🤲",
                                        buttonWidth: 165.w),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SmallText(
                                    text: "Get Started",
                                    size: 18.sp,
                                    color: AppColor.secondTextColor,
                                    fontWeight: FontWeight.w500),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        _showSnackBar(
                                            "Sorry not available yet!");
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: AppColor.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                      title: SmallText(
                                          text: "Add Money",
                                          size: 16.sp,
                                          color: AppColor.secondTextColor,
                                          fontWeight: FontWeight.w500),
                                      subtitle: SmallText(
                                          text: "Get more from your account",
                                          size: 14.sp,
                                          color: AppColor.subColor,
                                          fontWeight: FontWeight.w500),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_sharp),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        _showSnackBar(
                                            "Sorry not available yet!");
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: AppColor.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                      title: SmallText(
                                          text: "Create a debit card",
                                          size: 16.sp,
                                          color: AppColor.secondTextColor,
                                          fontWeight: FontWeight.w500),
                                      subtitle: SmallText(
                                          text: "Get a debit card now.",
                                          size: 14.sp,
                                          color: AppColor.subColor,
                                          fontWeight: FontWeight.w500),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_sharp),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        _showSnackBar(
                                            "Sorry not available yet!");
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: AppColor.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                      title: SmallText(
                                          text: "Earn for inviting friends",
                                          size: 16.sp,
                                          color: AppColor.secondTextColor,
                                          fontWeight: FontWeight.w500),
                                      subtitle: SmallText(
                                          text:
                                              "Earn 2,000 Naira for inviting a friend.",
                                          size: 14.sp,
                                          color: AppColor.subColor,
                                          fontWeight: FontWeight.w500),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_sharp),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SmallText(
                                    text: "Transaction History",
                                    size: 18.sp,
                                    color: AppColor.secondTextColor,
                                    fontWeight: FontWeight.w500),
                                SizedBox(
                                  height: 10.h,
                                ),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: fetchTransactions(user.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      // Handle specific error types
                                      if (snapshot.error
                                          is PostgrestException) {
                                        final error = snapshot.error
                                            as PostgrestException;
                                        if (error.code == "PGRST301") {
                                          // Token expired
                                          return _buildErrorScreen(
                                            context,
                                            'Your session has expired. Please log in again.',
                                            onRetry: () {
                                              // Logic to log the user out or refresh token
                                              _redirectToLogin(context);
                                            },
                                          );
                                        } else {
                                          return _buildErrorScreen(
                                            context,
                                            'Error: ${error.message}',
                                          );
                                        }
                                      }
                                      return _buildErrorScreen(
                                        context,
                                        'An unexpected error occurred. Please check your network and reload page.',
                                      );
                                    }

                                    final transactions = snapshot.data!;

                                    // Check if there are transactions
                                    if (transactions.isEmpty) {
                                      return Center(
                                        child: SmallText(
                                          text: "No Transaction History yet.",
                                          size: 14.sp,
                                          color: AppColor.subColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }

                                    final groupedTransactions =
                                        groupTransactionsByDate(
                                            transactions, user.id);

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: groupedTransactions.length,
                                      itemBuilder: (context, index) {
                                        final group =
                                            groupedTransactions[index];
                                        return TransactionGroup(group: group);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorScreen(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.subColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              fontFamily: AppStrings.rubik,
            ),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic> profileInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmallText(
              text: "Your Balance",
              size: 15.sp,
              color: AppColor.subColor,
              fontWeight: FontWeight.w500,
            ),
            IconButton(
              onPressed: _toggleBalanceVisibility,
              icon: Icon(
                _isBalanceHidden
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          _isBalanceHidden
              ? "****"
              : _formatBalance(profileInfo['balance'] ?? 0.00),
          style: TextStyle(
            fontSize: 24.sp,
            color: AppColor.blueTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isProfileSetup && isPasscodeSetup)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: "Account Number:",
                size: 15.sp,
                color: AppColor.subColor,
                fontWeight: FontWeight.w500,
              ),
              Row(
                children: [
                  SmallText(
                    text: profileInfo['account_number'] ?? 'no account number',
                    size: 15.sp,
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500,
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: profileInfo['account_number'] ?? ''));
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
                                "Account number copied!",
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
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _redirectToLogin(BuildContext context) {
    NavigationHelper.navigateToReplacement(context, const LoginScreen());
  }
}

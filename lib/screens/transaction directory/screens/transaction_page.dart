import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../main.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/small_text.dart';
import '../../auth directory/login auth directory/screens/login_screen.dart';
import '../../home directory/supabase/profile_info_db.dart';
import '../../home directory/widgets/transaction_widget.dart';


class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<User?> _userFuture;
  Map<String, dynamic>? _profileInfo;

  final profileInfoDb = ProfileInfoDb();

  @override
  void initState() {
    super.initState();
    _userFuture = _getCurrentUser();
    _fetchProfileInfo();
  }

  Future<User?> _getCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<void> _fetchProfileInfo() async {
    try {
      final profileInfo = await profileInfoDb.getUserProfileInfo();
      setState(() {
        _profileInfo = profileInfo;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile info: $e');
      }
      setState(() {
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchTransactions(String profileId) async {
    final response = await supabase
        .from('transaction_logs_with_names')
        .select('*')
        .or('sender_profile_id.eq.$profileId,recipient_profile_id.eq.$profileId')
        .order('timestamp', ascending: false);

    for (var transaction in response) {
      DateTime.parse(transaction['timestamp']).toUtc();
    }

    return response;
  }
  List<Map<String, dynamic>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions, String userId) {
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};

    for (var transaction in transactions) {
      if (transaction['sender_profile_id'] == userId) {
        final timestamp = DateTime.parse(transaction['timestamp']);
        final dateKey = _formatDateKey(timestamp);

        if (groupedTransactions.containsKey(dateKey)) {
          groupedTransactions[dateKey]!.add(transaction);
        } else {
          groupedTransactions[dateKey] = [transaction];
        }
      }
    }


    // Sort the grouped transactions by date
    final sortedGroups = groupedTransactions.entries.toList()
      ..sort((a, b) {
        final aDate = DateTime.parse(a.value.first['timestamp']);
        final bDate = DateTime.parse(b.value.first['timestamp']);
        return bDate.compareTo(aDate); // Sort in descending order (latest first)
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
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "All Transactions",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: AppStrings.rubik,
            fontWeight: FontWeight.w400,
            color: AppColor.secondTextColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _userFuture.then((user) => fetchTransactions(user!.id)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              if (snapshot.error is PostgrestException) {
                final error = snapshot.error as PostgrestException;
                if (error.code == "PGRST301") {
                  return _buildErrorScreen(
                    context,
                    'Your session has expired. Please log in again.',
                    onRetry: () {
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
                'An unexpected error occurred. Please check your network and reload the page.',
              );
            }

            final transactions = snapshot.data!;

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

            final groupedTransactions = groupTransactionsByDate(
                transactions, _profileInfo?["profile_id"] ?? "");

            return ListView.builder(
              shrinkWrap: true,
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final group = groupedTransactions[index];
                return TransactionGroup(group: group);
              },
            );
          },
        ),
      ),
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

  void _redirectToLogin(BuildContext context) {
    NavigationHelper.navigateToReplacement(context, const LoginScreen());
  }
}




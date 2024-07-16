import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:monity/screens/transaction%20directory/widgets/receipt_widget.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';

class TransactionGroup extends StatefulWidget {
  final Map<String, dynamic> group;

  const TransactionGroup({super.key, required this.group});

  @override
  State<TransactionGroup> createState() => TransactionGroupState();
}

class TransactionGroupState extends State<TransactionGroup> {
  String _formatBalance(double balance) {
    final formatCurrency = NumberFormat.currency(
      symbol: "\u20A6",
      decimalDigits: 2,
      locale: "en_NG",
    );
    return formatCurrency.format(balance);
  }

  @override
  Widget build(BuildContext context) {
    final transactions =
        widget.group['transactions'] as List<Map<String, dynamic>>;
    final date = widget.group['date'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.secondTextColor,
                fontFamily: AppStrings.rubik)),
        ...transactions.map((transaction) {
          final transactionType = transaction['transaction_type'] ?? 'unknown';
          final senderFirstName = transaction['sender_first_name'] ?? 'Unknown';
          final senderLastName = transaction['sender_last_name'] ?? 'Unknown';
          final recipientFirstName =
              transaction['recipient_first_name'] ?? 'Unknown';
          final recipientLastName =
              transaction['recipient_last_name'] ?? 'Unknown';
          final senderName = '$senderFirstName $senderLastName';
          final recipientName = '$recipientFirstName $recipientLastName';
          final amount = transaction['amount']?.toDouble() ?? 0.0;
          final timestamp = DateTime.tryParse(transaction['timestamp'] ?? '') ??
              DateTime.now();
          final formattedTime = DateFormat('hh:mm a').format(timestamp);

          final formattedAmount =
              _formatBalance(transactionType == 'debit' ? -amount : amount);

          return ListTile(
            leading: CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColor.primaryColor.withOpacity(0.2),
              child: Icon(
                transactionType == 'debit'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: transactionType == 'debit' ? Colors.red : Colors.green,
              ),
            ),
            title: Text(
                transactionType == 'debit'
                    ? 'To: $recipientName'
                    : 'From: $recipientName',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.secondTextColor,
                    fontFamily: AppStrings.rubik)),
            subtitle: Text('Time: $formattedTime',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.subColor,
                    fontFamily: AppStrings.rubik)),
            trailing: Text(
              formattedAmount,
              style: TextStyle(
                  color: transactionType == 'debit' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReceiptScreen(
                  senderName:  transactionType == 'debit' ? senderName : recipientName,
                  receiverName:  transactionType == 'debit' ? recipientName : senderName,
                  amount: amount,
                  transactionReference:
                      transaction['transaction_reference'] ?? "",
                  transactionStatus: transaction['transaction_status'] ?? "",
                  transactionDate: timestamp,
                  onpressed: () {
                    NavigationHelper.navigateBack(context);
                  },
                ),
              ));
            },
          );
        }),
      ],
    );
  }
}

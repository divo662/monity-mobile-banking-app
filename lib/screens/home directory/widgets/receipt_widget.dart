import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../res/app_icons.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/default_button.dart';

class ReceiptScreen extends StatefulWidget {
  final String senderName;
  final String receiverName;
  final double amount;
  final String transactionReference;
  final String transactionStatus;
  final DateTime transactionDate;
  final VoidCallback? onpressed;

  const ReceiptScreen({
    super.key,
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.transactionReference,
    required this.transactionStatus,
    required this.transactionDate,
     this.onpressed,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String _formatBalance(double balance) {
    final formatCurrency = NumberFormat.currency(
      symbol: "\u20A6",
      decimalDigits: 2,
      locale: "en_NG",
    );
    return formatCurrency.format(balance);
  }

  Future<void> _downloadReceipt() async {
    try {
      // Generate receipt content
      final StringBuffer buffer = StringBuffer();
      buffer.writeln('Sender,Receiver,Amount,Reference,Status,Date');
      buffer.writeln(
          '${widget.senderName},${widget.receiverName},${_formatBalance(widget.amount)},${widget.transactionReference},${widget.transactionStatus},${DateFormat.yMd().add_jm().format(widget.transactionDate)}');

      // Check and request storage permission if not granted
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception('Permission denied for storage');
          }
        }
      }

      // Get the directory for storing files
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Failed to access external storage');
      }

      // Create the file
      File file = File('${directory.path}/receipt.csv');

      // Write to the file
      await file.writeAsString(buffer.toString());

      _showSnackBar("Receipt downloaded successfully");

      // Open the file using the platform's file explorer
      if (await file.exists()) {
        await launch(file.path);
      } else {
        _showSnackBar("File does not exist");
        throw Exception('File does not exist');
      }
    } catch (e) {
      _showSnackBar("Failed to download receipt: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        content: Container(
          width: 199.w,
          height: 56.h,
          padding: EdgeInsets.all(10.sp),
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

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat.yMMMMd().add_jm().format(widget.transactionDate);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onpressed,
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppIcons.greenStatus),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Sender: ${widget.senderName}',
                style: TextStyle(
                    color: AppColor.secondTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    fontFamily: AppStrings.rubik),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'You sent ${_formatBalance(widget.amount)} to:',
                style: TextStyle(
                  color: AppColor.secondTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Receiver: ${widget.receiverName}',
                style: TextStyle(
                    color: AppColor.secondTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    fontFamily: AppStrings.rubik),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Reference: ${widget.transactionReference}',
                style: TextStyle(
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    fontFamily: AppStrings.rubik),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Status: ${widget.transactionStatus}',
                style: TextStyle(
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    fontFamily: AppStrings.rubik),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Date: $formattedDate',
                style: TextStyle(
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    fontFamily: AppStrings.rubik),
              ),
              const SizedBox(height: 40),
              DefaultButton(
                  onpressed: _downloadReceipt,
                  title: "Download Receipt",
                  buttonWidth: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}

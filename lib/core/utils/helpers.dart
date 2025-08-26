import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 2: // High
        return Colors.red;
      case 1: // Medium
        return Colors.orange;
      case 0: // Low
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
// import 'package:flutter/material.dart';
//
// class MyDateUtil {
//   static String getFormattedTime({
//     required BuildContext context,
//     required String time,
//   }) {
//     final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
//     return TimeOfDay.fromDateTime(date).format(context);
//   }
//
//   static String getLastMessageTime({
//     required BuildContext context,
//     required String time,
//     bool showYear = false,
//   }) {
//     final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
//     final DateTime now = DateTime.now();
//
//     if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
//       return TimeOfDay.fromDateTime(sent).format(context);
//     }
//
//     return showYear ? '${sent.day} ${_getMonth(sent)} ${sent.year}' : '${sent.day} ${_getMonth(sent)}';
//   }
//
//   static String getMessageTime({
//     required BuildContext context,
//     required String time,
//   }) {
//     final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
//     final DateTime now = DateTime.now();
//     final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
//
//     if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
//       return formattedTime;
//     }
//
//     return now.year == sent.year ? '$formattedTime - ${sent.day} ${_getMonth(sent)}' : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
//   }
//
//   static String getLastActiveTime({
//     required BuildContext context,
//     required String lastActive,
//   }) {
//     final int i = int.tryParse(lastActive) ?? -1;
//
//     if (i == -1) return 'Last seen not available';
//
//     final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
//     final DateTime now = DateTime.now();
//     final formattedTime = TimeOfDay.fromDateTime(time).format(context);
//
//     if (time.day == now.day && time.month == now.month && time.year == now.year) {
//       return 'Last seen today at $formattedTime';
//     }
//
//     final yesterday = now.subtract(const Duration(days: 1));
//     if (time.day == yesterday.day && time.month == yesterday.month && time.year == yesterday.year) {
//       return 'Last seen yesterday at $formattedTime';
//     }
//
//     final month = _getMonth(time);
//
//     return 'Last seen on ${time.day} $month on $formattedTime';
//   }
//
//   static String _getMonth(DateTime date) {
//     switch (date.month) {
//       case 1:
//         return 'Jan';
//       case 2:
//         return 'Feb';
//       case 3:
//         return 'Mar';
//       case 4:
//         return 'Apr';
//       case 5:
//         return 'May';
//       case 6:
//         return 'Jun';
//       case 7:
//         return 'Jul';
//       case 8:
//         return 'Aug';
//       case 9:
//         return 'Sept';
//       case 10:
//         return 'Oct';
//       case 11:
//         return 'Nov';
//       case 12:
//         return 'Dec';
//       default:
//         return 'NA';
//     }
//   }
// }

import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      return TimeOfDay.fromDateTime(date).format(context);
    } catch (e) {
      print('Error parsing time: $e');
      return 'Invalid time';
    }
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    try {
      final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();

      if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
        return TimeOfDay.fromDateTime(sent).format(context);
      }

      return showYear ? '${sent.day} ${_getMonth(sent)} ${sent.year}' : '${sent.day} ${_getMonth(sent)}';
    } catch (e) {
      print('Error parsing last message time: $e');
      return 'Invalid time';
    }
  }

  static String getMessageTime({
    required BuildContext context,
    required String time,
  }) {
    try {
      final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();
      final formattedTime = TimeOfDay.fromDateTime(sent).format(context);

      if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
        return formattedTime;
      }

      return now.year == sent.year ? '$formattedTime - ${sent.day} ${_getMonth(sent)}' : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
    } catch (e) {
      print('Error parsing message time: $e');
      return 'Invalid time';
    }
  }

  static String getLastActiveTime({
    required BuildContext context,
    required String lastActive,
  }) {
    try {
      final int i = int.tryParse(lastActive) ?? -1;

      if (i == -1) return 'Last seen not available';

      final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
      final DateTime now = DateTime.now();
      final formattedTime = TimeOfDay.fromDateTime(time).format(context);

      if (time.day == now.day && time.month == now.month && time.year == now.year) {
        return 'Last seen today at $formattedTime';
      }

      final yesterday = now.subtract(const Duration(days: 1));
      if (time.day == yesterday.day && time.month == yesterday.month && time.year == yesterday.year) {
        return 'Last seen yesterday at $formattedTime';
      }

      final month = _getMonth(time);

      return 'Last seen on ${time.day} $month on $formattedTime';
    } catch (e) {
      print('Error parsing last active time: $e');
      return 'Invalid time';
    }
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'NA';
    }
  }
}

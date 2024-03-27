import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallsScreen extends ConsumerWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text(
        'Calls',
        style: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: AppColorConstant.primary,
        ),
      ),
    );
  }
}
import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColorConstant.black,
      ),
    );
  }
}

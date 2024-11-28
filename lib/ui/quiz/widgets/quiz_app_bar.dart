import 'package:flutter/material.dart';
import 'package:quiz_app/generated/assets.dart';
import 'package:quiz_app/model/user_model.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizAppBar({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _buildScore(),
    );
  }

  Widget _buildScore() {
    return Row(
      children: [
        Image.asset(Assets.iconsScore),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

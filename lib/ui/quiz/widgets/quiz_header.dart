import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/bloc/user/user_cubit.dart';
import 'package:quiz_app/generated/assets.dart';
import 'package:quiz_app/model/user_model.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/theme/texts.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().getUser();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildScore(user.score),
        Text(
          'Fantasy Quiz #${user.quizCompleted + 1}',
          style: AppTexts.medium,
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: Colors.black),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
      ],
    );
  }

  Widget _buildScore(int score) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Assets.iconsScore, width: 20),
          const SizedBox(width: 10),
          Text(
            score.toString(),
            style: AppTexts.small.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

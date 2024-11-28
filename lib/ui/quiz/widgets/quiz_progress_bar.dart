import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/theme/texts.dart';

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<QuizBloc>().state as QuestionsLoaded;
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.questions.length,
            minHeight: 12,
            borderRadius: BorderRadius.circular(15),
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${state.currentIndex + 1}/${state.questions.length}',
          style: AppTexts.small.copyWith(
            fontSize: 14,
            color: AppColors.gray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

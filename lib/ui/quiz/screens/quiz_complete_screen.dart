import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/bloc/user/user_cubit.dart';
import 'package:quiz_app/generated/assets.dart';
import 'package:quiz_app/ui/widgets/primary_button.dart';

import '../../../theme/colors.dart';
import '../../../theme/texts.dart';

class QuizCompleteScreen extends StatelessWidget {
  const QuizCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<QuizBloc>().state as QuestionsLoaded;

    context.read<UserCubit>().updateData(score: state.currentScore);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _goBack(context);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PrimaryButton(
          onPressed: () {
            context.read<QuizBloc>().add(ResetData());
            context.pop();
          },
          text: 'OKAY',
        ),
        body: Column(
          children: [
            const SizedBox(height: 90),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    _goBack(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
              ),
            ),
            Image.asset(Assets.imagesPrize, width: 150),
            const SizedBox(height: 50),
            Text(
              'Results of Fantasy Quiz',
              textAlign: TextAlign.center,
              style: AppTexts.large.copyWith(
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  _buildResult(
                    asset: Assets.iconsMoney,
                    label: 'SCORE GAINED',
                    count: state.currentScore,
                  ),
                  Container(
                    color: AppColors.scaffoldColor,
                    height: 1,
                    child: const Row(),
                  ),
                  _buildResult(
                    asset: Assets.iconsTick,
                    label: 'CORRECT PREDICTIONS',
                    count: state.currentScore,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult({
    required String asset,
    required String label,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.scaffoldColor,
                ),
                child: Center(
                  child: SvgPicture.asset(asset),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTexts.small.copyWith(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: AppTexts.small.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _goBack(BuildContext context) {
    context.read<QuizBloc>().add(ResetData());
    context.pop();
  }
}

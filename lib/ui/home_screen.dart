import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/bloc/user/user_cubit.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/theme/texts.dart';
import 'package:quiz_app/ui/widgets/primary_button.dart';
import 'package:quiz_app/utils/ui_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Fantasy Quiz',
              style: AppTexts.medium.copyWith(
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 10),
            BlocConsumer<QuizBloc, QuizState>(
              listener: (context, state) {
                if (state is QuestionsLoaded) {
                  log(GoRouter.of(context).state!.path.toString());
                  if (GoRouter.of(context).state?.path == '/home') {
                    context.push('/quiz');
                  }
                } else if (state is QuizError) {
                  UiUtils.showSnackbar(context, text: state.message);
                }
              },
              builder: (context, state) {
                if (state is QuestionsLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return PrimaryButton(
                    onPressed: () {
                      context.read<QuizBloc>().add(FetchQuestions());
                    },
                    text: 'Start Quiz',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

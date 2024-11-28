import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/theme/texts.dart';
import 'package:quiz_app/ui/quiz/quiz_screen.dart';
import 'package:quiz_app/ui/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizScreen(),
                    ),
                  );
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

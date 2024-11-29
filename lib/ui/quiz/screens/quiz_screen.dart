import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/theme/texts.dart';
import 'package:quiz_app/ui/quiz/widgets/question.dart';
import 'package:quiz_app/ui/quiz/widgets/quiz_header.dart';
import 'package:quiz_app/ui/quiz/widgets/quiz_progress_bar.dart';
import 'package:quiz_app/ui/widgets/primary_button.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuizBloc>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _showDialog(context);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            return PrimaryButton(
              isEnabled: state is QuestionsLoaded && state.showContinue,
              onPressed: () {
                bloc.add(SubmitAnswer());
              },
              text: 'CONTINUE',
            );
          },
        ),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInitial || state is QuestionsLoading) {
              return const CircularProgressIndicator();
            } else if (state is QuestionsLoaded) {
              if (state.currentIndex == state.questions.length) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  context.replace('/complete');
                });
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    QuizHeader(onClose: () => _showDialog(context)),
                    const SizedBox(height: 20),
                    QuizProgressBar(key: UniqueKey()),
                    const SizedBox(height: 30),
                    Question(
                      question: state.questions[state.currentIndex],
                      onSelected: () {},
                    ),
                  ],
                ),
              );
            } else if (state is QuizError) {
              return Text(state.message);
            } else {
              return const Text('Unknown State');
            }
          },
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Warning',
                  style: AppTexts.medium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure you want to quit?',
                  style: AppTexts.small,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: dialogContext.pop,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        dialogContext.pop();
                        _quitGame(context);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _quitGame(BuildContext context) {
    context.read<QuizBloc>().add(ResetData());
    context.pop();
  }
}

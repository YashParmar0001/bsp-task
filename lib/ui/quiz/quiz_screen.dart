import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/user/user_cubit.dart';
import 'package:quiz_app/ui/quiz/widgets/quiz_app_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuizAppBar(
        user: context.read<UserCubit>().getUser(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/bloc/quiz_bloc.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/ui/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

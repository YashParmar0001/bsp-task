import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/model/question_model.dart';

import '../../../theme/colors.dart';
import '../../../theme/texts.dart';

class Question extends StatefulWidget {
  const Question({
    super.key,
    required this.question,
    required this.onSelected,
  });

  final QuestionModel question;
  final VoidCallback onSelected;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuestion(widget.question.question),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final option = widget.question.options[index];
            return _buildOption(index, selected == option);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
          itemCount: widget.question.options.length,
        ),
      ],
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: AppTexts.large.copyWith(
        color: AppColors.darkBlue,
      ),
    );
  }

  Widget _buildOption(int index, bool isSelected) {
    final option = widget.question.options[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = option;
          context.read<QuizBloc>().add(SelectOption(option));
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : AppColors.scaffoldColor,
              ),
              child: Center(
                child: isSelected
                    ? const Icon(
                        Icons.done_rounded,
                        color: AppColors.primaryColor,
                      )
                    : Text(
                        String.fromCharCode(65 + index),
                        style: AppTexts.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option,
                style: AppTexts.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

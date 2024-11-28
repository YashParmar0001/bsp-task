class QuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final String answer;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          question == other.question &&
          options == other.options &&
          answer == other.answer);

  @override
  int get hashCode =>
      id.hashCode ^ question.hashCode ^ options.hashCode ^ answer.hashCode;

  @override
  String toString() {
    return 'QuestionModel{ id: $id, question: $question, options: $options, answer: $answer,}';
  }

  QuestionModel copyWith({
    int? id,
    String? question,
    List<String>? options,
    String? answer,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['question_id'] as int,
      question: map['question'] as String,
      options: <String>[
        map['ans_a'],
        map['ans_b'],
        map['ans_c'],
        map['ans_d'],
      ],
      answer: map['answer'] as String,
    );
  }

  factory QuestionModel.fromLocalMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      question: map['question'],
      options: (map['options'] as String).split(','),
      answer: map['answer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'question': question,
      'options': options.join(','),
      'answer': answer,
    };
  }
}

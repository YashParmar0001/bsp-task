class UserModel {
  final int score;
  final int quizCompleted;

  const UserModel({required this.score, required this.quizCompleted});

  factory UserModel.zero() {
    return const UserModel(score: 0, quizCompleted: 0);
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        score == other.score &&
        quizCompleted == other.quizCompleted;
  }

  @override
  int get hashCode => score.hashCode & quizCompleted.hashCode;
}

class UserModel {
  final int score;
  final int quizCompleted;

  const UserModel({required this.score, required this.quizCompleted});

  factory UserModel.zero() {
    return const UserModel(score: 0, quizCompleted: 0);
  }
}
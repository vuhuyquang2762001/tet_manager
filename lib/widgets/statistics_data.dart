class StatisticsData {
  final int totalContacts;
  final int wishedContacts;
  final int todayWished;
  final int streakDays;

  final Map<String, double> groupProgress;

  StatisticsData({
    required this.totalContacts,
    required this.wishedContacts,
    required this.todayWished,
    required this.streakDays,
    required this.groupProgress,
  });

  int get remainingContacts => totalContacts - wishedContacts;

  double get progress =>
      totalContacts == 0 ? 0 : wishedContacts / totalContacts;
}
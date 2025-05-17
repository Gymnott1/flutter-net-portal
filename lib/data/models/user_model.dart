class UserModel {
  final String name;
  final String phoneNumber;
  final double credit;
  final int netPoints;
  // Add other fields as needed

  UserModel({
    required this.name,
    required this.phoneNumber,
    this.credit = 0.0,
    this.netPoints = 0,
  });
}

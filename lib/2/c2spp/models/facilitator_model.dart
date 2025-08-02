class Facilitator {
  final String name;
  final String role;
  final String status;
  final bool isAvailable;
  bool isSelected;
  final bool isActive;

  Facilitator({
    required this.name,
    required this.role,
    required this.status,
    required this.isAvailable,
    this.isSelected = false,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'status': status,
      'isAvailable': isAvailable,
      'isSelected': isSelected,
      'isActive': isActive,
    };
  }
}

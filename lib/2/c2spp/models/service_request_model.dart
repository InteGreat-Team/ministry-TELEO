class ServiceRequest {
  final String name;
  final String location;
  final String service;
  final String timeType;
  final String timeText;
  final String? scheduledText;
  final String destination;
  final String countdown;

  ServiceRequest({
    required this.name,
    required this.location,
    required this.service,
    required this.timeType,
    required this.timeText,
    this.scheduledText,
    required this.destination,
    required this.countdown,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'service': service,
      'timeType': timeType,
      'timeText': timeText,
      'scheduledText': scheduledText,
      'destination': destination,
      'countdown': countdown,
    };
  }
}

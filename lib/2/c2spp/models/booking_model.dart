class Booking {
  final String reference;
  final String requesterName;
  final String location;
  final String serviceType;
  final String date;
  final String time;
  final bool isScheduledForLater;
  final String venue;
  final String assignedTo;
  final String? cancelReason;
  final String? feedback;
  final String? cancelledBy;
  final String? cancelledDate;

  Booking({
    required this.reference,
    required this.requesterName,
    required this.location,
    required this.serviceType,
    required this.date,
    required this.time,
    required this.isScheduledForLater,
    required this.venue,
    required this.assignedTo,
    this.cancelReason,
    this.feedback,
    this.cancelledBy,
    this.cancelledDate,
  });

  Booking copyWith({
    String? reference,
    String? requesterName,
    String? location,
    String? serviceType,
    String? date,
    String? time,
    bool? isScheduledForLater,
    String? venue,
    String? assignedTo,
    String? cancelReason,
    String? feedback,
    String? cancelledBy,
    String? cancelledDate,
  }) {
    return Booking(
      reference: reference ?? this.reference,
      requesterName: requesterName ?? this.requesterName,
      location: location ?? this.location,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      time: time ?? this.time,
      isScheduledForLater: isScheduledForLater ?? this.isScheduledForLater,
      venue: venue ?? this.venue,
      assignedTo: assignedTo ?? this.assignedTo,
      cancelReason: cancelReason ?? this.cancelReason,
      feedback: feedback ?? this.feedback,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      cancelledDate: cancelledDate ?? this.cancelledDate,
    );
  }
}

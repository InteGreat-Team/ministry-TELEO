class InboxNotification {
  final String notificationType;
  final DateTime date;
  final dynamic payload;

  InboxNotification({
    required this.notificationType,
    required this.date,
    required this.payload,
  });
}

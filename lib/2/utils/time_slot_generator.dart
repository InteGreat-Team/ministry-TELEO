import 'package:intl/intl.dart';

class TimeSlotGenerator {
  static List<String> generateTimeSlots({
    required DateTime startTime,
    required DateTime endTime,
    required int intervalMinutes,
  }) {
    final List<String> timeSlots = [];
    DateTime currentTime = startTime;

    while (currentTime.isBefore(endTime) ||
        currentTime.isAtSameMomentAs(endTime)) {
      timeSlots.add(DateFormat('h:mm a').format(currentTime));
      currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    }

    return timeSlots;
  }
}

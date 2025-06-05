import 'package:flutter/material.dart';
import '../widgets/day_item.dart';
import '../widgets/filter_button.dart';
import '../widgets/appointment_card.dart';

class ScheduleTab extends StatelessWidget {
  final List<String> weekdays;
  final List<int> dates;
  final int selectedDayIndex;
  final Function(int) onDaySelected;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const ScheduleTab({
    super.key,
    required this.weekdays,
    required this.dates,
    required this.selectedDayIndex,
    required this.onDaySelected,
    required this.selectedFilter,
    required this.onFilterSelected,
  });
  @override
  Widget build(BuildContext context) {
    // Get current date
    final now = DateTime.now();

    // Generate the current week's dates
    final currentWeekDates = List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day - now.weekday + 1 + index);
    });

    // Weekday abbreviations
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Month names
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Date and heading - now dynamic
            Text(
              '${months[now.month - 1]} ${now.day}, ${weekdays[now.weekday - 1]}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'What\'s for today?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),

            // Day selector - now dynamic
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => GestureDetector(
                    onTap: () => onDaySelected(index),
                    child: DayItem(
                      weekday: weekdays[index],
                      date: currentWeekDates[index].day,
                      isSelected: selectedDayIndex == index,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter buttons - unchanged
            Row(
              children: [
                Expanded(
                  child: FilterButton(
                    label: 'All',
                    icon: Icons.grid_4x4,
                    isSelected: selectedFilter == 'All',
                    onTap: () => onFilterSelected('All'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    label: 'Services',
                    isSelected: selectedFilter == 'Services',
                    onTap: () => onFilterSelected('Services'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    label: 'Events',
                    isSelected: selectedFilter == 'Events',
                    onTap: () => onFilterSelected('Events'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Appointment cards - unchanged (you might want to make these dynamic too)
            AppointmentCard(
              title: 'Baptism',
              assignedTo: '@Pastor John',
              location: 'P. Sherman, 42 Wallaby Way',
              time:
                  '${months[now.month - 1]} ${now.day}, ${now.year} - 3:00 PM - 6:00 PM',
              borderColor: const Color(0xFFFF6B35),
              backgroundColor: const Color(0xFFFFF8F5),
            ),
            AppointmentCard(
              title: 'Love! Live! Couples for Christ Community Night',
              assignedTo: '@Jake Sim',
              location: 'Youth Camp, Yosemite Camp',
              time:
                  '${months[now.month - 1]} ${now.day}, ${now.year} - 7:00 PM - 9:00 PM',
              borderColor: const Color(0xFF4CAF50),
              backgroundColor: const Color(0xFFF5FFF8),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

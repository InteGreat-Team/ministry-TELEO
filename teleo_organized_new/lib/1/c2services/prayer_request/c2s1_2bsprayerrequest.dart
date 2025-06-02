import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'c2s2_1bsprayerrequest.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  int monthOffset = 0;
  DateTime? selectedDate;
  String selectedTime = '';

  final List<String> morningTimes = [
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];
  final List<String> afternoonTimes = [
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    print("🕒 System DateTime.now(): $now");
    print("📆 Normalized Date: ${now.year}-${now.month}-${now.day}");
  }

  @override
  Widget build(BuildContext context) {
    DateTime baseNow = DateTime.now();
    DateTime currentMonth = DateTime(baseNow.year, baseNow.month + monthOffset);
    List<DateTime> visibleMonths = [
      DateTime(currentMonth.year, currentMonth.month - 1),
      currentMonth,
      DateTime(currentMonth.year, currentMonth.month + 1),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Prayer Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 14),
          label: const Text(
            'Back',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        leadingWidth: 80,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A0A4A)),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const StepIndicator(currentStep: 1, totalSteps: 7),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'When ',
                                    style: TextStyle(
                                      color: Color(0xFF0A0A4A),
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'do you need it?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 0),
                            const Text(
                              'Select the date and time',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Month Navigation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    if (monthOffset > 0) {
                                      setState(() {
                                        monthOffset -= 1;
                                        selectedDate = null;
                                      });
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(3, (i) {
                                      DateTime month = visibleMonths[i];
                                      bool isSelected = i == 1;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            monthOffset += (i - 1);
                                            selectedDate = null;
                                          });
                                        },
                                        child: Text(
                                          "${_monthAbbreviation(month.month)} ${month.year}",
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? const Color(0xFF0A0A4A)
                                                    : Colors.grey,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      monthOffset += 1;
                                      selectedDate = null;
                                    });
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            _buildCalendar(currentMonth),
                            const SizedBox(height: 20),

                            const Text(
                              'Available Time Slots',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  morningTimes
                                      .map((time) => _buildTimeSlot(time))
                                      .toList(),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  afternoonTimes
                                      .map((time) => _buildTimeSlot(time))
                                      .toList(),
                            ),

                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF0A0A4A),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color(0xFF0A0A4A),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        (selectedDate != null &&
                                                selectedTime.isNotEmpty)
                                            ? () {
                                              String formattedDate =
                                                  "${_monthAbbreviation(selectedDate!.month)} ${selectedDate!.day}, ${selectedDate!.year}";
                                              debugPrint(
                                                "📅 Selected Date: $formattedDate",
                                              );
                                              debugPrint(
                                                "⏰ Selected Time: $selectedTime",
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const LocationSelectionScreen(),
                                                ),
                                              );
                                            }
                                            : null,

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A0A4A),
                                      disabledBackgroundColor:
                                          Colors.grey.shade300,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7; // Sunday=0
    int totalDaysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Get previous month info
    DateTime prevMonth = DateTime(month.year, month.month - 1);
    int totalDaysInPrevMonth =
        DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    List<DateTime> calendarDays = [];

    // 1. Add leading days from previous month
    for (int i = startWeekday - 1; i >= 0; i--) {
      calendarDays.add(
        DateTime(prevMonth.year, prevMonth.month, totalDaysInPrevMonth - i),
      );
    }

    // 2. Add current month days
    for (int i = 1; i <= totalDaysInMonth; i++) {
      calendarDays.add(DateTime(month.year, month.month, i));
    }

    // 3. Fill to exactly 35 days (5 weeks)
    while (calendarDays.length < 35) {
      int day = calendarDays.length - (startWeekday + totalDaysInMonth) + 1;
      DateTime nextMonth = DateTime(month.year, month.month + 1);
      calendarDays.add(DateTime(nextMonth.year, nextMonth.month, day));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double cellWidth = constraints.maxWidth / 7;

        return Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: Center(
                    child: Text(
                      'Sun',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Mon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Tue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Wed',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Thu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Fri',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Sat',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Wrap(
              spacing: 0,
              runSpacing: 0,
              children: List.generate(35, (index) {
                final day = calendarDays[index];
                final isCurrentMonth = day.month == month.month;
                final today = DateTime.now();
                final isPast = day.isBefore(
                  DateTime(today.year, today.month, today.day),
                );
                final isSelected =
                    selectedDate != null &&
                    selectedDate!.year == day.year &&
                    selectedDate!.month == day.month &&
                    selectedDate!.day == day.day;

                return SizedBox(
                  width: cellWidth,
                  height: 48,
                  child: GestureDetector(
                    onTap:
                        (isCurrentMonth && !isPast)
                            ? () {
                              setState(() {
                                selectedDate = day;
                              });
                            }
                            : null,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected
                                ? const Color(0xFFFFC107).withOpacity(0.2)
                                : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color:
                                isCurrentMonth
                                    ? (isPast
                                        ? Colors.grey.withOpacity(0.4)
                                        : Colors.black)
                                    : Colors.grey.shade300,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeSlot(String time) {
    bool isSelected = selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFFFC107).withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFC107) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4A2D5F) : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _monthAbbreviation(int month) {
    const List<String> monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return monthNames[month - 1];
  }
}

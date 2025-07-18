import 'package:flutter/material.dart';

class MassScheduleScreen extends StatefulWidget {
  const MassScheduleScreen({super.key});

  @override
  State<MassScheduleScreen> createState() => _MassScheduleScreenState();
}

class _MassScheduleScreenState extends State<MassScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 11, minute: 0);
  final List<MassScheduleItem> _scheduleItems = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Mass Schedule',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Date picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datepicker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Time picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Timepicker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectTimeRange(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatTime(_startTime)} to ${_formatTime(_endTime)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addScheduleItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Another Time Slot'),
            ),
          ),

          const SizedBox(height: 24),

          // Schedule list
          if (_scheduleItems.isNotEmpty) ...[
            const Text(
              'Scheduled Masses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _scheduleItems.length,
                itemBuilder: (context, index) {
                  final item = _scheduleItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(_formatDate(item.date)),
                      subtitle: Text(
                        '${_formatTime(item.startTime)} to ${_formatTime(item.endTime)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeScheduleItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTimeRange(BuildContext context) async {
    final TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedStart != null) {
      setState(() {
        _startTime = pickedStart;
      });

      // Now pick end time
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: _endTime,
      );
      if (pickedEnd != null) {
        setState(() {
          _endTime = pickedEnd;
        });
      }
    }
  }

  void _addScheduleItem() {
    // Check for duplicate date and time slot
    bool isDuplicate = _scheduleItems.any(
      (item) =>
          item.date.year == _selectedDate.year &&
          item.date.month == _selectedDate.month &&
          item.date.day == _selectedDate.day &&
          item.startTime.hour == _startTime.hour &&
          item.startTime.minute == _startTime.minute &&
          item.endTime.hour == _endTime.hour &&
          item.endTime.minute == _endTime.minute,
    );
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This date and time slot is already scheduled.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      _scheduleItems.add(
        MassScheduleItem(
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
        ),
      );
    });
  }

  void _removeScheduleItem(int index) {
    setState(() {
      _scheduleItems.removeAt(index);
    });
  }

  String _formatDate(DateTime date) {
    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];

    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
          break;
      }
    }

    return '$weekday, $day$suffix $month';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class MassScheduleItem {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  MassScheduleItem({
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

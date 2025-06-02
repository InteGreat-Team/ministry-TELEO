import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Map<String, dynamic>> _appointmentTypes = [
    {'title': 'Wedding Service', 'icon': Icons.favorite, 'color': Colors.pink},
    {'title': 'Funeral Service', 'icon': Icons.church, 'color': Colors.grey},
    {'title': 'Baptism', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'title': 'Counseling', 'icon': Icons.people, 'color': Colors.green},
    {
      'title': 'Prayer Request',
      'icon': Icons.volunteer_activism,
      'color': Colors.orange,
    },
  ];

  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedType;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _availableTimes = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3E9BFF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF001A33),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A33),
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Service Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Service type selection
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _appointmentTypes.length,
                itemBuilder: (context, index) {
                  final type = _appointmentTypes[index];
                  final bool isSelected = _selectedType == type['title'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type['title'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF3E9BFF)
                                : const Color(0xFF002642),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            type['icon'],
                            color: isSelected ? Colors.white : type['color'],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Date selection
              const Text(
                'Select Date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002642),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF3E9BFF),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Time selection
              const Text(
                'Select Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _availableTimes.map((time) {
                        final bool isSelected = _selectedTime == time;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF3E9BFF)
                                      : const Color(0xFF002642),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      )
                                      : null,
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Notes
              const Text(
                'Additional Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter any special requests or notes...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF002642),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 32),

              // Book appointment button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedType != null && _selectedTime != null
                          ? () {
                            // Book appointment logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Appointment booked successfully!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E9BFF),
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/required_asterisk.dart';
import 'c2s3_1caeventcreation.dart';
import 'widgets/event_app_bar.dart';

class EventDateScreen extends StatefulWidget {
  final Event event;

  const EventDateScreen({super.key, required this.event});

  @override
  State<EventDateScreen> createState() => _EventDateScreenState();
}

class _EventDateScreenState extends State<EventDateScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isOneDay;
  List<EventDay> _eventDays = [];
  String? _timeError;
  Map<int, String> _dateErrors = {}; // Track date errors by index

  @override
  void initState() {
    super.initState();
    _isOneDay = widget.event.isOneDay;

    // Initialize with existing data or create a new day
    if (widget.event.eventDays != null && widget.event.eventDays!.isNotEmpty) {
      // Use existing event days if available
      _eventDays = List.from(widget.event.eventDays!);
    } else if (widget.event.startDate != null) {
      // Initialize from start/end dates if no event days exist
      _eventDays.add(
        EventDay(
          date: widget.event.startDate,
          startTime: widget.event.startTime,
          endTime: widget.event.endTime,
        ),
      );

      // If it's a multi-day event and has an end date different from start date
      if (!_isOneDay &&
          widget.event.endDate != null &&
          widget.event.startDate != null &&
          !_isSameDay(widget.event.startDate!, widget.event.endDate!)) {
        _eventDays.add(
          EventDay(
            date: widget.event.endDate,
            startTime: widget.event.startTime,
            endTime: widget.event.endTime,
          ),
        );
      }
    } else {
      // Add an empty day if no data exists
      _eventDays.add(EventDay());
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _selectDate(BuildContext context, int dayIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDays[dayIndex].date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _eventDays[dayIndex].date = picked;
        _dateErrors.remove(dayIndex); // Clear error for this specific day

        // Check for duplicate dates in multi-day event
        if (!_isOneDay && _eventDays.length > 1) {
          _validateUniqueDates(dayIndex);
        }
      });
    }
  }

  void _validateUniqueDates(int changedIndex) {
    if (_isOneDay) return; // No need to validate for one-day events

    // Clear previous errors for this index
    setState(() {
      _dateErrors.remove(changedIndex);
    });

    // Skip validation if date is null
    if (_eventDays[changedIndex].date == null) return;

    // Check if the selected date exists in any other day
    for (int i = 0; i < _eventDays.length; i++) {
      if (i != changedIndex && _eventDays[i].date != null) {
        if (_isSameDay(_eventDays[changedIndex].date!, _eventDays[i].date!)) {
          setState(() {
            _dateErrors[changedIndex] =
                'This date is already selected for Day ${i + 1}';
          });
          return;
        }
      }
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    int dayIndex,
    bool isStartTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isStartTime
              ? (_eventDays[dayIndex].startTime ?? TimeOfDay.now())
              : (_eventDays[dayIndex].endTime ??
                  const TimeOfDay(hour: 18, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _eventDays[dayIndex].startTime = picked;

          // Check if end time exists and validate
          if (_eventDays[dayIndex].endTime != null) {
            _validateTimes(dayIndex);
          }
        } else {
          _eventDays[dayIndex].endTime = picked;

          // Check if start time exists and validate
          if (_eventDays[dayIndex].startTime != null) {
            _validateTimes(dayIndex);
          }
        }
      });
    }
  }

  void _validateTimes(int dayIndex) {
    final startTime = _eventDays[dayIndex].startTime;
    final endTime = _eventDays[dayIndex].endTime;

    if (startTime != null && endTime != null) {
      // Convert to minutes for comparison
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      if (startMinutes == endMinutes) {
        setState(() {
          _timeError = 'Start time and end time cannot be the same';
        });
      } else if (startMinutes > endMinutes) {
        setState(() {
          _timeError = 'End time must be after start time';
        });
      } else {
        setState(() {
          _timeError = null;
        });
      }
    }
  }

  void _addEventDay() {
    setState(() {
      _eventDays.add(EventDay());
      _isOneDay = false; // Automatically switch to multi-day event
    });
  }

  void _removeEventDay(int index) {
    if (_eventDays.length > 1) {
      setState(() {
        _eventDays.removeAt(index);
        _dateErrors.remove(index); // Remove error for this index

        // Adjust indices in _dateErrors map
        Map<int, String> newDateErrors = {};
        _dateErrors.forEach((key, value) {
          if (key > index) {
            newDateErrors[key - 1] = value;
          } else if (key < index) {
            newDateErrors[key] = value;
          }
        });
        _dateErrors = newDateErrors;

        // If only one day remains, set to one-day event
        if (_eventDays.length == 1) {
          _isOneDay = true;
          _dateErrors.clear(); // Clear all date errors
        }

        // Re-validate all dates
        if (!_isOneDay && _eventDays.length > 1) {
          for (int i = 0; i < _eventDays.length; i++) {
            if (_eventDays[i].date != null) {
              _validateUniqueDates(i);
            }
          }
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  bool _validateForm() {
    bool isValid = true;

    // Check if all days have date and times
    for (var day in _eventDays) {
      if (day.date == null || day.startTime == null || day.endTime == null) {
        isValid = false;
        break;
      }
    }

    // Check for time and date errors
    if (_timeError != null || _dateErrors.isNotEmpty) {
      isValid = false;
    }

    return isValid;
  }

  void _saveEventData() {
    widget.event.isOneDay = _isOneDay;

    if (_eventDays.isNotEmpty) {
      // Set start date and time from first day
      widget.event.startDate = _eventDays[0].date;
      widget.event.startTime = _eventDays[0].startTime;

      if (_isOneDay || _eventDays.length == 1) {
        // For one-day events, end date is same as start date
        widget.event.endDate = _eventDays[0].date;
        widget.event.endTime = _eventDays[0].endTime;
      } else {
        // For multi-day events, end date is from the last day
        widget.event.endDate = _eventDays.last.date;
        widget.event.endTime = _eventDays.last.endTime;
      }

      // Save all event days for multi-day events
      widget.event.eventDays = List.from(_eventDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context),
        title: '',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicator(currentStep: 2, totalSteps: 7),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'When is your event?',
                            style: TextStyle(
                              color: Color(0xFF0A0A4A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Event Type
                          const Row(
                            children: [
                              Text(
                                'Event Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RequiredAsterisk(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isOneDay,
                                onChanged: (value) {
                                  setState(() {
                                    _isOneDay = value!;
                                    // If switching to one-day, keep only the first day
                                    if (_isOneDay && _eventDays.length > 1) {
                                      _eventDays = [_eventDays.first];
                                      _dateErrors
                                          .clear(); // Clear date errors when switching to one day
                                    }
                                  });
                                },
                                activeColor: const Color(0xFF0A0A4A),
                              ),
                              const Text('One-Day Event'),
                              const SizedBox(width: 16),
                              Radio<bool>(
                                value: false,
                                groupValue: _isOneDay,
                                onChanged: (value) {
                                  setState(() {
                                    _isOneDay = value!;
                                  });
                                },
                                activeColor: const Color(0xFF0A0A4A),
                              ),
                              const Text('Multiple-Day Event'),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Event Days
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _eventDays.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Only show day label for multi-day events
                                      if (!_isOneDay)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Day ${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            if (_eventDays.length > 1)
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color(0xFF0A0A4A),
                                                ),
                                                onPressed:
                                                    () =>
                                                        _removeEventDay(index),
                                                tooltip: 'Remove day',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                          ],
                                        ),
                                      if (!_isOneDay)
                                        const SizedBox(height: 12),

                                      // Date Selection
                                      const Text(
                                        'Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap:
                                            () => _selectDate(context, index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border:
                                                _dateErrors.containsKey(index)
                                                    ? Border.all(
                                                      color: Colors.red,
                                                    )
                                                    : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDate(
                                                  _eventDays[index].date,
                                                ),
                                                style: TextStyle(
                                                  color:
                                                      _eventDays[index].date ==
                                                              null
                                                          ? Colors.grey[600]
                                                          : Colors.black,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Date error message
                                      if (_dateErrors.containsKey(index))
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            _dateErrors[index]!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),

                                      const SizedBox(height: 16),

                                      // Time Selection
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Start Time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap:
                                                      () => _selectTime(
                                                        context,
                                                        index,
                                                        true,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 14,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border:
                                                          _timeError != null
                                                              ? Border.all(
                                                                color:
                                                                    Colors.red,
                                                              )
                                                              : null,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _formatTime(
                                                            _eventDays[index]
                                                                .startTime,
                                                          ),
                                                          style: TextStyle(
                                                            color:
                                                                _eventDays[index]
                                                                            .startTime ==
                                                                        null
                                                                    ? Colors
                                                                        .grey[600]
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'End Time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap:
                                                      () => _selectTime(
                                                        context,
                                                        index,
                                                        false,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 14,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border:
                                                          _timeError != null
                                                              ? Border.all(
                                                                color:
                                                                    Colors.red,
                                                              )
                                                              : null,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _formatTime(
                                                            _eventDays[index]
                                                                .endTime,
                                                          ),
                                                          style: TextStyle(
                                                            color:
                                                                _eventDays[index]
                                                                            .endTime ==
                                                                        null
                                                                    ? Colors
                                                                        .grey[600]
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Time error message
                                      if (_timeError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            _timeError!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Add Day Button (only for multi-day events)
                          if (!_isOneDay)
                            Center(
                              child: TextButton.icon(
                                onPressed: _addEventDay,
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF0A0A4A),
                                ),
                                label: const Text(
                                  'Add Another Day',
                                  style: TextStyle(color: Color(0xFF0A0A4A)),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A0A4A),
                        side: const BorderSide(color: Color(0xFF0A0A4A)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Back', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateForm()) {
                          _saveEventData();

                          // Navigate to next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EventLocationScreen(event: widget.event),
                            ),
                          );
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill in all date and time fields correctly',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A4A),
                        foregroundColor:
                            Colors.white, // Set text color to white
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ), // Ensure text is white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

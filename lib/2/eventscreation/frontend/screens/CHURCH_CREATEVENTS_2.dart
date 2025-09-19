import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import '../screens/CHURCH_CREATEVENTS_3p1.dart';

class ChurchCreateEvent2 extends StatefulWidget {
  final Event event;

  const ChurchCreateEvent2({super.key, required this.event});

  @override
  State<ChurchCreateEvent2> createState() => _ChurchCreateEvent2State();
}

class _ChurchCreateEvent2State extends State<ChurchCreateEvent2> {
  final _formKey = GlobalKey<FormState>();
  late DateTimeViewModel _dateTimeViewModel;

  @override
  void initState() {
    super.initState();
    _dateTimeViewModel = DateTimeViewModel();
    _dateTimeViewModel.initializeEventDays(widget.event);
  }

  Future<void> _selectDate(BuildContext context, int dayIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dateTimeViewModel.eventDays[dayIndex].date ?? DateTime.now(),
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
      _dateTimeViewModel.updateEventDate(dayIndex, picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, int dayIndex, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_dateTimeViewModel.eventDays[dayIndex].startTime ??
              TimeOfDay.now())
          : (_dateTimeViewModel.eventDays[dayIndex].endTime ??
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
      _dateTimeViewModel.updateEventTime(dayIndex, picked, isStartTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _dateTimeViewModel,
      child: Scaffold(
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
                        child: Consumer<DateTimeViewModel>(
                          builder: (context, viewModel, child) {
                            return Column(
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
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 2, // Set to the correct index for Events
          onTap: (index) {
            // Add navigation logic if needed
          },
        ),
      ),
    );
  }
}

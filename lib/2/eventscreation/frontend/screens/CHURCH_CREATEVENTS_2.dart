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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  void initState() {
    super.initState();
    _dateTimeViewModel = DateTimeViewModel();
    _dateTimeViewModel.initializeWithEvent(widget.event);
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

                                // Event Type (One day or Multiple days)
                                Row(
                                  children: [
                                    const Text('Single-day event'),
                                    const SizedBox(width: 8),
                                    Switch(
                                      value: viewModel.isOneDay,
                                      activeColor: const Color(0xFFFFC107),
                                      onChanged: (val) =>
                                          viewModel.setOneDay(val),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                if (viewModel.isOneDay) ...[
                                  const Row(
                                    children: [
                                      Text('Start date'),
                                      RequiredAsterisk(),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => viewModel
                                              .selectStartDate(context),
                                          child: Text(
                                            viewModel.startDate == null
                                                ? 'Select start date'
                                                : '${viewModel.startDate!.month}/${viewModel.startDate!.day}/${viewModel.startDate!.year}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Time (optional)'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => viewModel
                                              .selectStartTime(context),
                                          child: Text(
                                            viewModel.startTime == null
                                                ? 'Select start time'
                                                : _formatTime(
                                                    viewModel.startTime!),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              viewModel.selectEndTime(context),
                                          child: Text(
                                            viewModel.endTime == null
                                                ? 'Select end time'
                                                : _formatTime(
                                                    viewModel.endTime!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  const Text('Specific dates'),
                                  const SizedBox(height: 8),
                                  ...viewModel.eventDays
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final day = entry.value;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () =>
                                                  viewModel.selectEventDayDate(
                                                      context, index),
                                              child: Text(
                                                day.date == null
                                                    ? 'Select date for Day ${index + 1}'
                                                    : '${day.date!.month}/${day.date!.day}/${day.date!.year}',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                viewModel.removeEventDay(index),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add another date'),
                                      onPressed: viewModel.addEventDay,
                                    ),
                                  ),
                                ],

                                if (viewModel.errorMessage != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    viewModel.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0A0A4A),
                            side: const BorderSide(color: Color(0xFF0A0A4A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_dateTimeViewModel.validateDateTime()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventLocationScreen(
                                    event: widget.event,
                                    title: widget.event.title,
                                    tags: widget.event.tags,
                                    description: widget.event.description,
                                    contactInfo: widget.event.contactInfo,
                                    churchLandline: widget.event.churchLandline,
                                    dressCode: widget.event.dressCode,
                                    speakers: widget.event.speakers,
                                    imageUrl: widget.event.imageUrl,
                                    imagePath: widget.event.imagePath,
                                    imageBytes: widget.event.imageBytes,
                                    additionalImages:
                                        widget.event.additionalImages,
                                    isOneDay: widget.event.isOneDay,
                                    eventDays: widget.event.eventDays ?? [],
                                    startDate: widget.event.startDate,
                                    endDate: widget.event.endDate,
                                    startTime: widget.event.startTime,
                                    endTime: widget.event.endTime,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A4A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                    ),
                  ],
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

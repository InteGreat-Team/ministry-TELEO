import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/event_app_bar.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/success_dialog.dart';
import 'c2s9caeventcreation.dart';

class EventTargetsScreen extends StatefulWidget {
  final Event event;

  const EventTargetsScreen({super.key, required this.event});

  @override
  State<EventTargetsScreen> createState() => _EventTargetsScreenState();
}

class _EventTargetsScreenState extends State<EventTargetsScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _targetPublishDate;
  TimeOfDay? _targetPublishTime;
  final TextEditingController _inviteMessageController = TextEditingController();

  // Track if notification is visible
  bool _showNotification = true;
  
  // Track if success notification is visible
  bool _showSuccessNotification = false;
  
  @override
  void initState() {
    super.initState();
    
    // Set default target publish date to 7 days from now
    final today = DateTime.now();
    _targetPublishDate = today.add(const Duration(days: 7));
    
    _targetPublishTime = widget.event.targetPublishTime;
    _inviteMessageController.text = widget.event.inviteMessage ?? '';
  }

  // Calculate the maximum allowed date (7 days from today)
  DateTime get _maxAllowedDate {
    final today = DateTime.now();
    return today.add(const Duration(days: 7));
  }

  Future<void> _selectDate(BuildContext context) async {
    final today = DateTime.now();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetPublishDate ?? today,
      firstDate: today,
      lastDate: _maxAllowedDate,
      helpText: 'Select publish date (within 7 days)',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107), // Yellow highlight color
              onPrimary: Colors.black, // Text color on yellow
              onSurface: Colors.black, // Calendar text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFFC107), // Yellow text for buttons
              ),
            ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _targetPublishDate) {
      setState(() {
        _targetPublishDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _targetPublishTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107), // Yellow highlight color
              onPrimary: Colors.black, // Text color on yellow
              onSurface: Colors.black, // Dial text color
              surface: Colors.white, // Background color
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? const Color(0xFFFFC107) : Colors.grey.shade200
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? Colors.black : Colors.black
              ),
              dialBackgroundColor: Colors.grey.shade100,
              dialHandColor: const Color(0xFFFFC107),
              dialTextColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? Colors.white : Colors.black
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFFC107), // Yellow text for buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _targetPublishTime) {
      setState(() {
        _targetPublishTime = picked;
      });
    }
  }

  void _dismissNotification() {
    setState(() {
      _showNotification = false;
    });
  }

  void _dismissSuccessNotification() {
    setState(() {
      _showSuccessNotification = false;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.month}/${date.day}/${date.year}';
  }
  
  // Get formatted list of event dates
  String _getFormattedEventDates() {
    if (widget.event.isOneDay || widget.event.eventDays == null || widget.event.eventDays!.isEmpty) {
      return 'Event on ${_formatDate(widget.event.startDate)}';
    } else {
      // For multiple specific dates, list them all
      List<String> formattedDates = [];
      for (var day in widget.event.eventDays!) {
        if (day.date != null) {
          formattedDates.add(_formatDate(day.date));
        }
      }
      
      if (formattedDates.isEmpty) {
        return 'Event on ${_formatDate(widget.event.startDate)}';
      } else if (formattedDates.length == 1) {
        return 'Event on ${formattedDates[0]}';
      } else {
        // Join all dates with commas and "and" for the last one
        String lastDate = formattedDates.removeLast();
        if (formattedDates.length == 1) {
          return 'Event on ${formattedDates[0]} and $lastDate';
        } else {
          return 'Event on ${formattedDates.join(", ")} and $lastDate';
        }
      }
    }
  }

  void _showSendInvitesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Send Invites',
          message: 'Send out event details to invited churches for approval?',
          negativeButtonText: 'No',
          positiveButtonText: 'Yes',
          icon: Icons.search,
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
          onPositivePressed: () {
            Navigator.of(context).pop();
            _showSuccessSentDialog();
          },
        );
      },
    );
  }

  void _showSuccessSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Successfully Sent!',
          message: 'Your event invites are sent and is awaiting approval.',
          primaryButtonText: 'View Event Details',
          secondaryButtonText: 'Back to Menu',
          onPrimaryPressed: () {
            Navigator.of(context).pop();
            _navigateToWaitingApproval();
          },
          onSecondaryPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }

  void _navigateToWaitingApproval() {
    // Save event data first
    _saveEventData();
    
    // Navigate to waiting approval screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventWaitingApprovalScreen(event: widget.event),
      ),
    );
  }

  void _saveEventData() {
    // Save target publish date and time
    widget.event.targetPublishDate = _targetPublishDate;
    widget.event.targetPublishTime = _targetPublishTime;
    
    // Save invite message
    widget.event.inviteMessage = _inviteMessageController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Success notification at the top
            if (_showSuccessNotification)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.green,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Event created successfully!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.white),
                      onPressed: _dismissSuccessNotification,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            
            // Notification about automatic publishing
            if (_showNotification)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.amber.shade100,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your event will be automatically published after 7 days (${_formatDate(_maxAllowedDate)}) if not published earlier.',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _dismissNotification,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicator(
                      currentStep: 6,
                      totalSteps: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Set Targets and Invites',
                            style: TextStyle(
                              color: Color(0xFF0A0A4A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Event Date Summary
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.blue),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getFormattedEventDates(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Starting at ${widget.event.startTime?.format(context)}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Target Publish Date and Time in the same row
                          const Row(
                            children: [
                              Text(
                                'Target Publish Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Must be within 7 days (by ${_formatDate(_maxAllowedDate)})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Date and Time in the same row with equal width
                          Row(
                            children: [
                              // Date field
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _targetPublishDate == null
                                                ? 'Select date'
                                                : '${_targetPublishDate!.month}/${_targetPublishDate!.day}/${_targetPublishDate!.year}',
                                            style: TextStyle(
                                              color: _targetPublishDate == null ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.calendar_today, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              // Time field
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _targetPublishTime == null
                                                ? 'Time (optional)'
                                                : _targetPublishTime!.format(context),
                                            style: TextStyle(
                                              color: _targetPublishTime == null ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.access_time, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Invited Churches Section
                          if (widget.event.invitedChurches.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Invited Churches',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...widget.event.invitedChurches.map((church) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              church.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('${church.members} members'),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: church.roles.map((role) {
                                                // Extract role name from the format "Role (count)"
                                                final roleName = role.split(' (')[0];
                                                
                                                // Get role color based on role name
                                                Color chipColor = Colors.grey[200]!;
                                                if (roleName == 'Admin') {
                                                  chipColor = Colors.blue.shade100;
                                                } else if (roleName == 'Members') {
                                                  chipColor = Colors.purple.shade100;
                                                } else if (roleName == 'Pastor/Leader') {
                                                  chipColor = Colors.green.shade100;
                                                }
                                                
                                                return Chip(
                                                  label: Text(role, style: const TextStyle(fontSize: 10)),
                                                  backgroundColor: chipColor,
                                                  visualDensity: VisualDensity.compact,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 24),
                              ],
                            ),
                          
                          // Invited Guests Section
                          if (widget.event.invitedGuests.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Invited Guests',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...widget.event.invitedGuests.map((guest) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  guest.fullName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '@${guest.username}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'From: ${guest.churchName}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 24),
                              ],
                            ),
                          
                          // Invite Message
                          const Text(
                            'Invite Message',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _inviteMessageController,
                            decoration: const InputDecoration(
                              hintText: 'You are thoroughly invited to this event...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom buttons with equal width and separate containers
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0A0A4A)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0A0A4A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Continue button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A4A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_targetPublishDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a target publish date')),
                            );
                            return;
                          }
                          
                          // Show send invites dialog
                          _showSendInvitesDialog();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'models/event.dart';
import 'c2s10caeventcreation.dart';
import 'services/event_service.dart';

class EventWaitingApprovalScreen extends StatefulWidget {
  final Event event;

  const EventWaitingApprovalScreen({super.key, required this.event});

  @override
  State<EventWaitingApprovalScreen> createState() => _EventWaitingApprovalScreenState();
}

class _EventWaitingApprovalScreenState extends State<EventWaitingApprovalScreen> {
  late Timer _timer;
  bool _eventSaved = false;
  
  @override
  void initState() {
    super.initState();
    
    // Save the event to the EventService when this screen is first loaded
    _saveEventToService();
    
    // Automatically navigate to event details after 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: widget.event),
          ),
        );
      }
    });
  }
  
  void _saveEventToService() {
    // Set the event status to PENDING
    
    // Save the event to the EventService
    final eventService = EventService();
    final eventMap = eventService.convertEventToMap(widget.event);
    eventService.addEvent(eventMap);
    
    setState(() {
      _eventSaved = true;
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text('Waiting for Approval'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF0A0A4A),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 2, 133)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Waiting for churches to approve your event',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You will be redirected shortly...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (_eventSaved)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Event Created Successfully!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your event is now pending approval',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

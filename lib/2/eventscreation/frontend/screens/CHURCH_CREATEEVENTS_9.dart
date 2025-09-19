//CHURCH_CREATEEVENTS_9.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'models/event.dart';
import 'c2s10caeventcreation.dart';
import 'services/event_service.dart';
import 'CREATE_EVENTS_VAR.dart';
import 'CREATE_EVENTS_FUNC.dart';

class EventWaitingApprovalScreen extends StatefulWidget {
  final Event event;

  const EventWaitingApprovalScreen({super.key, required this.event});

  @override
  State<EventWaitingApprovalScreen> createState() => _EventWaitingApprovalScreenState();
}

class _EventWaitingApprovalScreenState extends State<EventWaitingApprovalScreen> {
  late EventWaitingApprovalViewModel _viewModel;
  late EventWaitingApprovalVariables _variables;
  
  @override
  void initState() {
    super.initState();
    _variables = EventWaitingApprovalVariables(event: widget.event);
    _viewModel = EventWaitingApprovalViewModel(_variables);
    _viewModel.initializeScreen(context);
  }
  
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(EventWaitingApprovalConstants.screenTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _viewModel.navigateBack(context),
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
                EventWaitingApprovalConstants.waitingMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                EventWaitingApprovalConstants.redirectMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (_viewModel.variables.eventSaved)
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
                                EventWaitingApprovalConstants.eventCreatedTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                EventWaitingApprovalConstants.pendingApprovalMessage,
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

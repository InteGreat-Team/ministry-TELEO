// CHURCH_CREATEEVENTS_8p1.dart - UI Screen
import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/event_app_bar.dart';
import 'CREATE_EVENTS_VAR.dart';
import 'CREATE_EVENTS_FUNC.dart';

class EventTargetsScreen extends StatefulWidget {
  final Event event;

  const EventTargetsScreen({super.key, required this.event});

  @override
  State<EventTargetsScreen> createState() => _EventTargetsScreenState();
}

class _EventTargetsScreenState extends State<EventTargetsScreen> {
  late EventTargetsVariables _variables;
  late EventTargetsViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _variables = EventTargetsVariables(event: widget.event);
    _viewModel = EventTargetsViewModel(_variables);
  }

  @override
  void dispose() {
    _variables.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => _viewModel.handleBack(context), 
        title: '',
      ),
      body: Form(
        key: EventTargetsVariables.formKey,
        child: Column(
          children: [
            // Success notification at the top
            if (_variables.showSuccessNotification)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: EventTargetsColors.successGreen,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: EventTargetsColors.backgroundWhite),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        EventTargetsConstants.successNotification,
                        style: TextStyle(
                          color: EventTargetsColors.backgroundWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: EventTargetsColors.backgroundWhite),
                      onPressed: _viewModel.dismissSuccessNotification,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            
            // Notification about automatic publishing
            if (_variables.showNotification)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.amber.shade100,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: EventTargetsColors.warningAmber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _viewModel.getAutoPublishNotificationMessage(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _viewModel.dismissNotification,
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
                            EventTargetsConstants.screenTitle,
                            style: TextStyle(
                              color: EventTargetsColors.primaryColor,
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
                                const Icon(Icons.calendar_today, color: EventTargetsColors.infoBlue),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _viewModel.getFormattedEventDates(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${EventTargetsConstants.startingAtText} ${widget.event.startTime?.format(context)}',
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
                          
                          // Target Publish Date and Time section
                          const Row(
                            children: [
                              Text(
                                EventTargetsConstants.targetPublishDateLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                EventTargetsConstants.requiredFieldIndicator,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${EventTargetsConstants.dateHelpText} (by ${_viewModel.formatDate(_variables.maxAllowedDate)})',
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
                                  onTap: () => _viewModel.selectDate(context),
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
                                            _variables.targetPublishDate == null
                                                ? EventTargetsConstants.selectDateHint
                                                : _viewModel.formatDate(_variables.targetPublishDate),
                                            style: TextStyle(
                                              color: _variables.targetPublishDate == null ? EventTargetsColors.textGrey : EventTargetsColors.textBlack,
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
                                  onTap: () => _viewModel.selectTime(context),
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
                                            _variables.targetPublishTime == null
                                                ? EventTargetsConstants.selectTimeHint
                                                : _variables.targetPublishTime!.format(context),
                                            style: TextStyle(
                                              color: _variables.targetPublishTime == null ? EventTargetsColors.textGrey : EventTargetsColors.textBlack,
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
                                  EventTargetsConstants.invitedChurchesLabel,
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
                                        backgroundColor: EventTargetsColors.textGrey,
                                        child: Icon(Icons.person, color: EventTargetsColors.backgroundWhite),
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
                                            Text('${church.members} ${EventTargetsConstants.membersText}'),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: church.roles.map((role) {
                                                final roleName = _viewModel.extractRoleName(role);
                                                final chipColor = RoleColors.getRoleColor(roleName);
                                                
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
                                  EventTargetsConstants.invitedGuestsLabel,
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
                                        backgroundColor: EventTargetsColors.textGrey,
                                        child: Icon(Icons.person, color: EventTargetsColors.backgroundWhite),
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
                                              '${EventTargetsConstants.fromText} ${guest.churchName}',
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
                            EventTargetsConstants.inviteMessageLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _variables.inviteMessageController,
                            decoration: const InputDecoration(
                              hintText: EventTargetsConstants.inviteMessageHint,
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
                        border: Border.all(color: EventTargetsColors.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () => _viewModel.handleBack(context),
                        style: TextButton.styleFrom(
                          foregroundColor: EventTargetsColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          EventTargetsConstants.backButtonText,
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
                        color: EventTargetsColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () => _viewModel.handleContinue(context),
                        style: TextButton.styleFrom(
                          foregroundColor: EventTargetsColors.backgroundWhite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          EventTargetsConstants.continueButtonText,
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

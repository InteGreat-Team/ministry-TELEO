import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
// import 'c2s8_1caeventcreation.dart'; import the next step

class EventInviteScreen extends StatefulWidget {
  final Event event;

  const EventInviteScreen({super.key, required this.event});

  @override
  State<EventInviteScreen> createState() => _EventInviteScreenState();
}

class _EventInviteScreenState extends State<EventInviteScreen> {
  late EventInviteViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = EventInviteViewModel();
    _viewModel.initializeFromEvent(widget.event);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        final model = _viewModel.model;
        final filteredChurches = _viewModel.getFilteredChurches();
        final totalInvited = _viewModel.calculateTotalInvitedPeople();
        final remainingCapacity = model.expectedCapacity - totalInvited;
        final bool isCapacityReached = _viewModel.isCapacityReached();

        // Add a theme override for input decorations
        final inputDecorationTheme =
            Theme.of(context).inputDecorationTheme.copyWith(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: model.navyBlue, width: 2.0),
                  ),
                  focusColor: model.navyBlue,
                );

        return Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: inputDecorationTheme,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: model.navyBlue,
                ),
          ),
          child: Scaffold(
            appBar: EventAppBar(
              onBackPressed: () => Navigator.pop(context),
              title: 'Create Event',
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Step indicator
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: StepIndicator(
                      currentStep: 5,
                      totalSteps: 7,
                      activeColor: model.navyBlue,
                      inactiveColor: Colors.grey[300]!,
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            model.pageTitle,
                            style: TextStyle(
                              fontSize: model.titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: model.titleColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            model.subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Invite Type Selection
                          _buildInviteTypeSection(),
                          const SizedBox(height: 24),

                          // Expected Capacity Section
                          _buildExpectedCapacitySection(isCapacityReached),
                          const SizedBox(height: 24),

                          // Church Selection Section (only for specific invites)
                          if (model.inviteType != 'Open Invite') ...[
                            _buildChurchSelectionSection(filteredChurches),
                            const SizedBox(height: 24),
                          ],

                          // Guest Invitation Section (only for specific invites)
                          if (model.inviteType != 'Open Invite') ...[
                            _buildGuestInvitationSection(),
                            const SizedBox(height: 24),
                          ],

                          // Capacity Summary
                          _buildCapacitySummary(totalInvited, remainingCapacity,
                              isCapacityReached),
                          const SizedBox(height: 24),

                          // Notification
                          _buildNotification(),
                        ],
                      ),
                    ),
                  ),

                  // Bottom buttons
                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInviteTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Invite Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _viewModel.model.titleColor,
              ),
            ),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text('Open Invite'),
                subtitle: const Text('Anyone can join the event'),
                value: 'Open Invite',
                groupValue: _viewModel.model.inviteType,
                onChanged: _viewModel.setInviteType,
                activeColor: _viewModel.model.navyBlue,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text('Specific Invites'),
                subtitle:
                    const Text('Invite specific churches and individuals'),
                value: 'Specific Invites',
                groupValue: _viewModel.model.inviteType,
                onChanged: _viewModel.setInviteType,
                activeColor: _viewModel.model.navyBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedCapacitySection(bool isCapacityReached) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Expected Capacity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _viewModel.model.titleColor,
              ),
            ),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 12),

        // Predefined capacity options
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _viewModel.model.capacityOptions.map((capacity) {
            final isSelected = !_viewModel.model.isCustomCapacity &&
                _viewModel.model.expectedCapacity == capacity;
            return ChoiceChip(
              label: Text('$capacity'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _viewModel.setExpectedCapacity(capacity, false);
                }
              },
              selectedColor: _viewModel.model.navyBlue.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? _viewModel.model.navyBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Custom capacity option
        Row(
          children: [
            Checkbox(
              value: _viewModel.model.isCustomCapacity,
              onChanged: (value) {
                _viewModel.setCustomCapacity(value ?? false);
              },
              activeColor: _viewModel.model.navyBlue,
            ),
            const Text('Custom: '),
            Expanded(
              child: TextFormField(
                controller: _viewModel.customCapacityController,
                enabled: _viewModel.model.isCustomCapacity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter custom capacity',
                  border: OutlineInputBorder(),
                ),
                onChanged: _viewModel.onCustomCapacityChanged,
                validator: _viewModel.validateCustomCapacity,
              ),
            ),
          ],
        ),

        if (isCapacityReached)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Capacity limit reached! Please increase capacity or remove some invites.',
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildChurchSelectionSection(
      List<Map<String, dynamic>> filteredChurches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Church Selection',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _viewModel.model.titleColor,
          ),
        ),
        const SizedBox(height: 12),

        // Search bar
        TextFormField(
          controller: _viewModel.searchController,
          decoration: InputDecoration(
            hintText: 'Search churches...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: _viewModel.onSearchChanged,
        ),

        const SizedBox(height: 16),

        // Churches list
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: filteredChurches.length,
            itemBuilder: (context, index) {
              final church = filteredChurches[index];
              final isSelected = _viewModel.model.selectedChurch == church;

              return ListTile(
                title: Text(church['name']),
                subtitle: Text('${church['members']} members'),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: _viewModel.model.navyBlue)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () => _viewModel.selectChurch(church),
                selected: isSelected,
                selectedTileColor: _viewModel.model.navyBlue.withOpacity(0.1),
              );
            },
          ),
        ),

        // Role selection for selected church
        if (_viewModel.model.selectedChurch != null) ...[
          const SizedBox(height: 16),
          _buildRoleSelection(),
        ],
      ],
    );
  }

  Widget _buildRoleSelection() {
    final church = _viewModel.model.selectedChurch!;
    final roleCount = church['roleCount'] as Map<String, int>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select roles to invite from ${church['name']}:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...roleCount.entries.map((entry) {
            final role = entry.key;
            final maxCount = entry.value;
            final currentCount =
                _viewModel.model.selectedRolesCounts[role] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('$role ($maxCount available)'),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: currentCount > 0
                              ? () => _viewModel.updateRoleCount(
                                  role, currentCount - 1)
                              : null,
                          icon: const Icon(Icons.remove),
                          iconSize: 20,
                        ),
                        Text('$currentCount'),
                        IconButton(
                          onPressed: currentCount < maxCount
                              ? () => _viewModel.updateRoleCount(
                                  role, currentCount + 1)
                              : null,
                          icon: const Icon(Icons.add),
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGuestInvitationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Guest Invitations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _viewModel.model.titleColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _viewModel.toggleGuestForm,
              icon: Icon(
                  _viewModel.model.showGuestForm ? Icons.close : Icons.add),
              label:
                  Text(_viewModel.model.showGuestForm ? 'Cancel' : 'Add Guest'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _viewModel.model.navyBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),

        if (_viewModel.model.showGuestForm) ...[
          const SizedBox(height: 16),
          _buildGuestForm(),
        ],

        const SizedBox(height: 16),

        // Invited guests list
        if (_viewModel.model.invitedGuestsUI.isNotEmpty) ...[
          Text(
            'Invited Guests (${_viewModel.model.invitedGuestsUI.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _viewModel.model.invitedGuestsUI.length,
              itemBuilder: (context, index) {
                final guest = _viewModel.model.invitedGuestsUI[index];
                return ListTile(
                  title: Text(guest.fullName),
                  subtitle: Text('${guest.username} • ${guest.guestChurch}'),
                  trailing: IconButton(
                    onPressed: () => _viewModel.removeGuest(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGuestForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _viewModel.usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: _viewModel.validateUsername,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _viewModel.fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            validator: _viewModel.validateFullName,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _viewModel.guestChurchController,
            decoration: const InputDecoration(
              labelText: 'Church Name',
              border: OutlineInputBorder(),
            ),
            validator: _viewModel.validateGuestChurch,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _viewModel.cancelGuestForm,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _viewModel.addGuest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _viewModel.model.navyBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Guest'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySummary(
      int totalInvited, int remainingCapacity, bool isCapacityReached) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCapacityReached ? Colors.red[50] : Colors.blue[50],
        border: Border.all(
          color: isCapacityReached ? Colors.red[300]! : Colors.blue[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Capacity Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCapacityReached ? Colors.red[700] : Colors.blue[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Expected Capacity:'),
              Text('${_viewModel.model.expectedCapacity}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Invited:'),
              Text('$totalInvited'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining Capacity:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isCapacityReached ? Colors.red[700] : Colors.blue[700],
                ),
              ),
              Text(
                '$remainingCapacity',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isCapacityReached ? Colors.red[700] : Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotification() {
    if (!_viewModel.model.showNotification ||
        _viewModel.model.notificationMessage == null) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (_viewModel.model.notificationType) {
      case NotificationType.success:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        iconData = Icons.check_circle;
        break;
      case NotificationType.error:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        iconData = Icons.error;
        break;
      case NotificationType.warning:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        iconData = Icons.warning;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(iconData, color: textColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _viewModel.model.notificationMessage!,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: _viewModel.hideNotification,
            icon: Icon(Icons.close, color: textColor, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: _viewModel.model.navyBlue),
              ),
              child: Text(
                _viewModel.model.backButtonText,
                style: TextStyle(color: _viewModel.model.navyBlue),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  _viewModel.proceedToNext(context, widget.event, _formKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: _viewModel.model.navyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_viewModel.model.nextButtonText),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import '../widgets/required_asterisk.dart';
import '../widgets/event_app_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../../backend/models/event.dart';
import 'CHURCH_CREATEEVENTS_8p1.dart';

class EventInviteScreen extends StatefulWidget {
  final Event event;

  const EventInviteScreen({super.key, required this.event});

  @override
  State<EventInviteScreen> createState() => _EventInviteScreenState();
}

class _EventInviteScreenState extends State<EventInviteScreen> 
    with ChurchCreateVentsVar, ChurchCreateVentsFunc {

  @override
  void initState() {
    super.initState();
    initializeEventInviteScreen(widget.event);
  }

  @override
  void dispose() {
    disposeEventInviteScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChurches = getFilteredChurches();
    final totalInvited = calculateTotalInvitedPeople();
    final remainingCapacity = expectedCapacity - totalInvited;
    final bool isCapacityReached = this.isCapacityReached();
    
    // Add a theme override for input decorations
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: navyBlue, width: 2.0),
      ),
      focusColor: navyBlue,
    );
    
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputDecorationTheme,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: navyBlue,
        ),
      ),
      child: Scaffold(
        appBar: EventAppBar(
          onBackPressed: () => Navigator.pop(context),
          title: 'Create Event',
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              // Custom notification at the top
              buildNotification(),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepIndicator(
                        currentStep: 5,
                        totalSteps: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Who is invited?',
                              style: TextStyle(
                                color: navyBlue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Invite Type
                            const Row(
                              children: [
                                Text(
                                  'Join Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RequiredAsterisk(),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Simplified radio buttons that will work properly
                            Row(
                              children: [
                                // Open Invite radio button
                                Radio<String>(
                                  value: 'Open Invite',
                                  groupValue: inviteType,
                                  activeColor: navyBlue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      inviteType = value!;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      inviteType = 'Open Invite';
                                    });
                                  },
                                  child: const Text('Open Invite'),
                                ),
                                const SizedBox(width: 16),

                                // Private radio button
                                Radio<String>(
                                  value: 'Private',
                                  groupValue: inviteType,
                                  activeColor: navyBlue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      inviteType = value!;
                                      capacityErrorMessage = null;     // clear warnings
                                      isInChurchSelectionMode = false; // collapse selection UI
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      inviteType = 'Private';
                                    });
                                  },
                                  child: const Text('Private (Filter and Select)'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Capacity Limit
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expected Capacity Limit (max registrants)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(right: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  child: !isCustomCapacity
                                    ? DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: expectedCapacity,
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down, color: navyBlue),
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black, fontSize: 16),
                                          dropdownColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          items: [
                                            ...capacityOptions.map((capacity) => 
                                              DropdownMenuItem(
                                                value: capacity,
                                                child: Text(capacity.toString()),
                                              ),
                                            ),
                                            const DropdownMenuItem(
                                              value: -1,
                                              child: Text('If more than the options given, please specify'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == -1) {
                                                isCustomCapacity = true;
                                              } else {
                                                expectedCapacity = value!;
                                                
                                                // Check if current invites exceed the new capacity
                                                int totalInvited = calculateTotalInvitedPeople();
                                                if (inviteType == 'Private' && totalInvited > expectedCapacity) {
                                                  capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($expectedCapacity people).';
                                                  
                                                  // Show warning notification
                                                  showWarningNotification(capacityErrorMessage!);
                                                } else {
                                                  capacityErrorMessage = null;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    : TextFormField(
                                        controller: customCapacityController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter custom capacity',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a capacity value';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty && int.tryParse(value) != null) {
                                            // Update expected capacity immediately when custom value changes
                                            updateExpectedCapacityFromCustomInput();
                                          }
                                        },
                                      ),
                                ),
                                if (isCustomCapacity)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isCustomCapacity = false;
                                          expectedCapacity = 1000;
                                          
                                          // Check if current invites exceed the new capacity
                                          int totalInvited = calculateTotalInvitedPeople();
                                          if (inviteType == 'Private' && totalInvited > expectedCapacity) {
                                            capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($expectedCapacity people).';
                                            showWarningNotification(capacityErrorMessage!);
                                          } else {
                                            capacityErrorMessage = null;
                                          }
                                        });
                                      },
                                      child: Text(
                                        'Use predefined options instead',
                                        style: TextStyle(color: navyBlue),
                                      ),
                                    ),
                                  ),
                                
                                // Display capacity error message if exists
                                if (capacityErrorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.orange),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.warning, color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              capacityErrorMessage!,
                                              style: const TextStyle(color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            // Capacity indicator
                            if (inviteType == 'Private')
                              Container(
                                margin: const EdgeInsets.only(top: 16, bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Capacity Usage',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: getCapacityColor().withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: getCapacityColor()),
                                          ),
                                          child: Text(
                                            '$totalInvited/$expectedCapacity',
                                            style: TextStyle(
                                              color: getCapacityColor(),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Progress bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: expectedCapacity > 0 ? totalInvited / expectedCapacity : 0,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor: AlwaysStoppedAnimation<Color>(getCapacityColor()),
                                        minHeight: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Capacity status message
                                    Text(
                                      remainingCapacity <= 0
                                          ? 'Capacity limit reached! Remove some invites to add more.'
                                          : remainingCapacity <= 20
                                              ? 'Warning: Only $remainingCapacity spots remaining!'
                                              : 'Remaining capacity: $remainingCapacity people',
                                      style: TextStyle(
                                        color: remainingCapacity <= 0 ? Colors.red : 
                                               remainingCapacity <= 20 ? Colors.orange : Colors.grey.shade700,
                                        fontWeight: remainingCapacity <= 20 ? FontWeight.bold : FontWeight.normal,
                                        fontStyle: remainingCapacity <= 0 ? FontStyle.italic : FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Only show church invitation section if Private is selected
                            if (inviteType == 'Private')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Invite churches',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Search field
                                  TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search for churches...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: Icon(Icons.search, color: navyBlue),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Selected church card for role selection
                                  if (isInChurchSelectionMode && selectedChurch != null)
                                    _buildSelectedChurchCard(),
                                  
                                  // Church list
                                  if (!isInChurchSelectionMode)
                                    _buildChurchList(filteredChurches, isCapacityReached),

                                  // Display invited churches
                                  if (invitedChurchesUI.isNotEmpty && !isInChurchSelectionMode)
                                    _buildInvitedChurchesList(),

                                  // Add Guests section
                                  const SizedBox(height: 24),
                                  _buildGuestSection(isCapacityReached),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom navigation buttons
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedChurchCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: navyBlue,
                  child: const Icon(Icons.church, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedChurch!['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${selectedChurch!['members']} members'),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedChurch = null;
                      selectedRolesCounts = {};
                      isInChurchSelectionMode = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Roles & Quantities',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (selectedRolesCounts.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.red),
                    label: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12)),
                    onPressed: () {
                      setState(() {
                        selectedRolesCounts = {};
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: navyBlue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedRolesCounts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No roles selected. Click "Select Roles" to choose roles and quantities.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        ...List.generate(
                          selectedRolesCounts.entries.length,
                          (index) {
                            final entry = selectedRolesCounts.entries.elementAt(index);
                            final role = entry.key;
                            final count = entry.value;
                            
                            if (count <= 0) return const SizedBox.shrink();
                            
                            // Get role color based on role name
                            Color roleColor = Colors.blue;
                            if (role == 'Admin') {
                              roleColor = Colors.blue;
                            } else if (role == 'Members') {
                              roleColor = Colors.purple;
                            } else if (role == 'Pastor/Leader') {
                              roleColor = Colors.green;
                            }
                            
                            return ListTile(
                              title: Text(role),
                              subtitle: Text('Selected: $count'),
                              leading: Icon(
                                Icons.people,
                                color: roleColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.people, color: Colors.white),
              label: const Text('Select Roles'),
              onPressed: () => showRoleSelectionDialog(setState),
              style: ElevatedButton.styleFrom(
                backgroundColor: navyBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedRolesCounts.isEmpty 
                  ? null 
                  : () => addChurchWithRoles(setState),
              style: ElevatedButton.styleFrom(
                backgroundColor: forestGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Add Church', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChurchList(List<Map<String, dynamic>> filteredChurches, bool isCapacityReached) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredChurches.length,
      itemBuilder: (context, index) {
        final church = filteredChurches[index];
        final isInvited = isChurchInvited(church['name']);
        
        // Determine if this church should be disabled
        final bool isDisabled = isCapacityReached && !isInvited;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isInvited 
              ? Colors.green.shade50 
              : isDisabled 
                  ? Colors.grey.shade200 
                  : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: navyBlue,
              child: const Icon(Icons.church, color: Colors.white),
            ),
            title: Text(
              church['name'],
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              '${church['members']} members',
              style: TextStyle(
                color: isDisabled ? Colors.grey : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isInvited ? Icons.check_circle : Icons.add_circle_outline,
                color: isInvited 
                    ? Colors.green 
                    : isDisabled 
                        ? Colors.grey 
                        : navyBlue,
                size: 28,
              ),
              onPressed: isDisabled 
                  ? null 
                  : () {
                      if (isInvited) {
                        removeChurch(church['name'], setState);
                      } else {
                        selectChurch(church, setState);
                      }
                    },
            ),
            onTap: isDisabled 
                ? () {
                    showErrorNotification('Cannot add more churches. You have reached your capacity limit of $expectedCapacity people.');
                  }
                : () {
                    if (isInvited) {
                      // Show confirmation dialog before removing
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Remove Church?'),
                            content: Text('Do you want to remove ${church['name']} from invited churches?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  removeChurch(church['name'], setState);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      selectChurch(church, setState);
                    }
                  },
          ),
        );
      },
    );
  }

  Widget _buildInvitedChurchesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Invited Churches',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (invitedChurchesUI.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                onPressed: () => clearAllChurches(setState),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...invitedChurchesUI.map((church) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: navyBlue,
              child: const Icon(Icons.church, color: Colors.white),
            ),
            title: Text(church.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${church.members} members'),
                const SizedBox(height: 4),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: navyBlue),
                  onPressed: () => editChurch(church, setState),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeChurch(church.name, setState),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        )),
      ],
    );
  }

  Widget _buildGuestSection(bool isCapacityReached) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add Guests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (invitedGuestsUI.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    totalInvitedPeople -= invitedGuestsUI.length;
                    invitedGuestsUI.clear();
                    widget.event.invitedGuests.clear();
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Guest form
        if (showGuestForm)
          _buildGuestForm()
        else
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text('Add New Guest', style: TextStyle(color: Colors.white)),
            onPressed: isCapacityReached
              ? () {
                  showErrorNotification('Cannot add more guests. You have reached your capacity limit of $expectedCapacity people.');
                }
              : () => showAddGuestForm(setState),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCapacityReached
                ? Colors.grey
                : navyBlue,
              foregroundColor: Colors.white,
            ),
          ),

        // Display invited guests
        if (invitedGuestsUI.isNotEmpty)
          _buildInvitedGuestsList(),
      ],
    );
  }

  Widget _buildGuestForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guest Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.alternate_email),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: navyBlue, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: navyBlue, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: guestChurchController,
            decoration: InputDecoration(
              labelText: 'Church Name',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.church),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: navyBlue, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => hideAddGuestForm(setState),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => addGuest(setState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Guest', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedGuestsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Invited Guests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(invitedGuestsUI.length, (index) {
          final guest = invitedGuestsUI[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: navyBlue,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Row(
                children: [
                  Text(guest.fullName),
                  const SizedBox(width: 8),
                  Text(
                    '@${guest.username}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Church: ${guest.churchName}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeGuest(index, setState),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
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
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A0A4A),
                side: const BorderSide(color: Color(0xFF0A0A4A)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => saveAndContinue(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: navyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

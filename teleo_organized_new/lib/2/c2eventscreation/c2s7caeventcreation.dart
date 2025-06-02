import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'widgets/required_asterisk.dart';
import 'c2s8_1caeventcreation.dart';
import 'widgets/event_app_bar.dart';

class EventInviteScreen extends StatefulWidget {
  final Event event;

  const EventInviteScreen({super.key, required this.event});

  @override
  State<EventInviteScreen> createState() => _EventInviteScreenState();
}

class _EventInviteScreenState extends State<EventInviteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _inviteType = 'Open Invite';
  int _expectedCapacity = 500;
  final TextEditingController _customCapacityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<int> _capacityOptions = [100, 200, 300, 500, 700, 1000];
  bool _isCustomCapacity = false;
  String _searchQuery = '';

  // Sample church data - limited to 4 entries
  final List<Map<String, dynamic>> _sampleChurches = [
    {'name': 'Sample Church Name', 'members': 120, 'roleCount': {'Admin': 5, 'Members': 100, 'Pastor/Leader': 10}},
    {'name': 'Sample Church Name 2', 'members': 150, 'roleCount': {'Admin': 6, 'Members': 130, 'Pastor/Leader': 8}},
    {'name': 'Sample Church Name 3', 'members': 170, 'roleCount': {'Admin': 7, 'Members': 150, 'Pastor/Leader': 8}},
    {'name': 'Sample Church Name 4', 'members': 120, 'roleCount': {'Admin': 4, 'Members': 105, 'Pastor/Leader': 6}},
  ];

  // Selected church for role assignment
  Map<String, dynamic>? _selectedChurch;

  // Permanent roles that cannot be removed
  final List<String> _permanentRoles = ['Admin', 'Members', 'Pastor/Leader'];

  // Guest list with full information
  List<GuestInvite> _invitedGuestsUI = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _guestChurchController = TextEditingController();
  bool _showGuestForm = false;

  // Selected roles with count
  Map<String, int> _selectedRolesCounts = {};

  // List to track invited churches in the UI (separate from event.invitedChurches)
  List<ChurchInvite> _invitedChurchesUI = [];
  
  // Map to track the total number of people invited per church
  final Map<String, int> _churchInviteCounts = {};

  // Error message for capacity validation
  String? _capacityErrorMessage;
  
  // Total number of people invited
  int _totalInvitedPeople = 0;

  // Navy blue color used throughout the app
  final Color _navyBlue = const Color(0xFF0A0A4A);
  // Medium forest green color for buttons
  final Color _forestGreen = const Color(0xFF2E7D32);
  
  // Notification state
  String? _notificationMessage;
  NotificationType? _notificationType;
  bool _showNotification = false;

  // New flag to track if we're in church selection mode
  bool _isInChurchSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _inviteType = widget.event.inviteType;
    _expectedCapacity = widget.event.expectedCapacity ?? 500;
    if (widget.event.customCapacity != null) {
      _isCustomCapacity = true;
      _customCapacityController.text = widget.event.customCapacity!;
      
      // Initialize expected capacity from custom capacity if available
      final customCapacityValue = int.tryParse(widget.event.customCapacity!);
      if (customCapacityValue != null) {
        _expectedCapacity = customCapacityValue;
      }
    }
    
    // Initialize UI list with existing invited churches
    _invitedChurchesUI = List.from(widget.event.invitedChurches);
    
    // Initialize UI list with existing invited guests
    _invitedGuestsUI = List.from(widget.event.invitedGuests);
    
    // Initialize church invite counts and total invited people
    _initializeInviteCounts();
  }
  
  // Initialize invite counts from existing data
  void _initializeInviteCounts() {
    _churchInviteCounts.clear();
    _totalInvitedPeople = 0;
    
    // Count people from existing church invites
    for (var church in _invitedChurchesUI) {
      int churchTotal = 0;
      
      // Parse the roles and counts from the format "Role (count)"
      for (var roleString in church.roles) {
        final parts = roleString.split(' (');
        if (parts.length == 2) {
          final countStr = parts[1].replaceAll(')', '');
          final count = int.tryParse(countStr) ?? 0;
          churchTotal += count;
        }
      }
      
      _churchInviteCounts[church.name] = churchTotal;
      _totalInvitedPeople += churchTotal;
    }
    
    // Add individual guests to the total
    _totalInvitedPeople += _invitedGuestsUI.length;
  }

  // Calculate total invited people (sum of all church roles and individual guests)
  int _calculateTotalInvitedPeople() {
    return _totalInvitedPeople;
  }

  // Calculate total people that would be invited if current selection is added
  int _calculateTotalWithCurrentSelection() {
    // Start with the current total of invited people
    int total = _totalInvitedPeople;
    
    // If we're editing an existing church, subtract its current count
    if (_selectedChurch != null) {
      final existingCount = _churchInviteCounts[_selectedChurch!['name']] ?? 0;
      total -= existingCount;
    }
    
    // Add counts from currently selected roles
    int selectedTotal = 0;
    _selectedRolesCounts.forEach((role, count) {
      if (count > 0) {
        selectedTotal += count;
      }
    });
    
    return total + selectedTotal;
  }

  // Get remaining capacity
  int _getRemainingCapacity() {
    return _expectedCapacity - _calculateTotalInvitedPeople();
  }

  // Check if adding the selected roles would exceed capacity
  bool _wouldExceedCapacity() {
    if (_inviteType == 'Open Invite') return false;
    
    int totalWithCurrentSelection = _calculateTotalWithCurrentSelection();
    
    // Check if this would exceed capacity
    return totalWithCurrentSelection > _expectedCapacity;
  }

  // Check if capacity limit is reached
  bool _isCapacityReached() {
    if (_inviteType == 'Open Invite') return false;
    int totalInvited = _calculateTotalInvitedPeople();
    return totalInvited >= _expectedCapacity;
  }

  void _showErrorNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationType = NotificationType.error;
      _showNotification = true;
    });
  }

  void _showWarningNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationType = NotificationType.warning;
      _showNotification = true;
    });
  }

  void _showSuccessNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationType = NotificationType.success;
      _showNotification = true;
    });
    
    // Auto-dismiss notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
        });
      }
    });
  }
  
  void _dismissNotification() {
    setState(() {
      _showNotification = false;
    });
  }

  // Update expected capacity from custom capacity input
  void _updateExpectedCapacityFromCustomInput() {
    if (_customCapacityController.text.isNotEmpty) {
      final customCapacityValue = int.tryParse(_customCapacityController.text);
      if (customCapacityValue != null) {
        // Check if current invites exceed the new capacity
        int totalInvited = _calculateTotalInvitedPeople();
        
        setState(() {
          _expectedCapacity = customCapacityValue;
          
          if (_inviteType == 'Private' && totalInvited > _expectedCapacity) {
            _capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($_expectedCapacity people).';
            
            // Show warning notification
            _showWarningNotification(_capacityErrorMessage!);
          } else {
            _capacityErrorMessage = null;
          }
        });
      }
    }
  }

  // COMPLETELY REWRITTEN: Add church with roles function
  void _addChurchWithRoles() {
    if (_selectedChurch != null && _selectedRolesCounts.isNotEmpty) {
      // Create a list of roles with their counts
      List<String> roles = [];
      int totalPeopleToAdd = 0;

      _selectedRolesCounts.forEach((role, count) {
        // Only add roles with count > 0
        if (count > 0) {
          roles.add("$role ($count)");
          totalPeopleToAdd += count;
        }
      });

      if (roles.isEmpty) {
        _showErrorNotification('Please select at least one role with a count greater than 0');
        return;
      }

      int totalWithCurrentSelection = _calculateTotalWithCurrentSelection();

      if (totalWithCurrentSelection > _expectedCapacity) {
        setState(() {
          _capacityErrorMessage =
              'Cannot add these roles. It would exceed your capacity limit of $_expectedCapacity people.';
        });
        _showErrorNotification(_capacityErrorMessage!);
        return;
      }

      final newChurch = ChurchInvite(
        name: _selectedChurch!['name'],
        members: _selectedChurch!['members'],
        roles: roles,
      );

      // Store the church data temporarily
      final churchToAdd = _selectedChurch;
      final rolesToAdd = Map<String, int>.from(_selectedRolesCounts);
      
      // First, clear the selection state
      setState(() {
        _selectedChurch = null;
        _selectedRolesCounts = {};
        _isInChurchSelectionMode = false;
      });

      // Then in a separate setState, add the church data
      // This ensures the UI updates correctly
      Future.microtask(() {
        setState(() {
          // Check if church is already in the list
          final existingIndex = _invitedChurchesUI.indexWhere(
            (church) => church.name == churchToAdd!['name'],
          );

          if (existingIndex >= 0) {
            final existingCount = _churchInviteCounts[churchToAdd!['name']] ?? 0;
            _totalInvitedPeople -= existingCount;
            
            // Update roles if church already exists
            _invitedChurchesUI[existingIndex] = newChurch;
            _showSuccessNotification('Church roles updated successfully');
          } else {
            // Add new church with roles
            _invitedChurchesUI.add(newChurch);
            _showSuccessNotification('Church added successfully');
          }

          _churchInviteCounts[churchToAdd!['name']] = totalPeopleToAdd;
          _totalInvitedPeople += totalPeopleToAdd;
          
          // Update the event's invited churches list
          widget.event.invitedChurches = List.from(_invitedChurchesUI);
        });
      });
    }
  }

  void _showRoleSelectionDialog() {
    // Create a temporary map for role selection with counts
    Map<String, int> tempSelectedRolesCounts = Map.from(_selectedRolesCounts);
    
    // Initialize with default values if empty
    for (var role in _permanentRoles) {
      if (!tempSelectedRolesCounts.containsKey(role)) {
        tempSelectedRolesCounts[role] = 0;
      }
    }
    
    // Calculate the TOTAL number of people already invited across ALL churches and guests
    int totalAlreadyInvited = _calculateTotalInvitedPeople();
    
    // If this church is already in the list, subtract its current counts to avoid double counting
    int currentChurchTotal = 0;
    if (_selectedChurch != null) {
      currentChurchTotal = _churchInviteCounts[_selectedChurch!['name']] ?? 0;
      // Subtract this church's current contribution from the total
      totalAlreadyInvited -= currentChurchTotal;
    }
    
    // Calculate remaining capacity after accounting for all other invites
    int remainingCapacity = _expectedCapacity - totalAlreadyInvited;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Calculate total selected in this dialog
            int totalSelectedInDialog = 0;
            tempSelectedRolesCounts.forEach((role, count) {
              totalSelectedInDialog += count;
            });
            
            // Check if current selection exceeds remaining capacity
            bool exceedsCapacity = totalSelectedInDialog > remainingCapacity;
            
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Select Roles',
                style: TextStyle(color: _navyBlue, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show capacity information
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: exceedsCapacity ? Colors.red.shade50 : 
                               remainingCapacity <= 20 ? Colors.amber.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: exceedsCapacity ? Colors.red : 
                                 remainingCapacity <= 20 ? Colors.amber : Colors.green,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Capacity Limit: $_expectedCapacity',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('Already Invited (other churches/guests): $totalAlreadyInvited'),
                            Text('Currently Selected: $totalSelectedInDialog'),
                            Text('Remaining Capacity: ${remainingCapacity - totalSelectedInDialog}'),
                            if (exceedsCapacity)
                              const Text(
                                'Warning: Selection exceeds capacity limit!',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Click for options'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _navyBlue),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Column(
                          children: [
                            // Permanent roles section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: _navyBlue,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                ),
                              ),
                              child: const Text(
                                'Permanent Roles',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ...List.generate(_permanentRoles.length, (index) {
                              final role = _permanentRoles[index];
                              final maxCount = _selectedChurch?['roleCount']?[role] ?? 0;
                              final currentCount = tempSelectedRolesCounts[role] ?? 0;
                              
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
                                title: Row(
                                  children: [
                                    Text(
                                      role,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.people,
                                      size: 16,
                                      color: roleColor,
                                    ),
                                    Text(' $maxCount'),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text('0', style: TextStyle(color: Colors.grey[600])),
                                        Expanded(
                                          child: Slider(
                                            value: currentCount.toDouble(),
                                            min: 0,
                                            max: maxCount.toDouble(),
                                            divisions: maxCount,
                                            label: currentCount.toString(),
                                            activeColor: roleColor,
                                            onChanged: (double value) {
                                              setDialogState(() {
                                                // Calculate how this change affects the total
                                                int newTotal = totalSelectedInDialog - currentCount + value.toInt();
                                                
                                                // Only allow the change if it doesn't exceed capacity
                                                // or if it's reducing the current value
                                                if (newTotal <= remainingCapacity || value < currentCount) {
                                                  tempSelectedRolesCounts[role] = value.toInt();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Text('$maxCount', style: TextStyle(color: Colors.grey[600])),
                                      ],
                                    ),
                                    Text(
                                      'Selected: $currentCount',
                                      style: TextStyle(
                                        color: roleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Wrap the buttons in a row with equal width containers
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Confirm button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: exceedsCapacity ? Colors.grey : _navyBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextButton(
                            onPressed: exceedsCapacity 
                              ? null  // Disable button if capacity is exceeded
                              : () {
                                  // Apply the selected roles and counts to the main state
                                  setState(() {
                                    _selectedRolesCounts = Map.from(tempSelectedRolesCounts);
                                  });
                                  Navigator.of(context).pop();
                                },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // REWRITTEN: Select church function
  void _selectChurch(Map<String, dynamic> church) {
    // Check if capacity is already reached
    if (_inviteType == 'Private' && _isCapacityReached()) {
      _showErrorNotification('Cannot add more churches. You have reached your capacity limit of $_expectedCapacity people.');
      return;
    }
    
    setState(() {
      _selectedChurch = church;
      _selectedRolesCounts = {};
      _isInChurchSelectionMode = true;
    });
  }

  void _removeChurch(String churchName) {
    setState(() {
      // Subtract this church's count from the total before removing
      final churchCount = _churchInviteCounts[churchName] ?? 0;
      _totalInvitedPeople -= churchCount;
      
      // Remove the church from the invite counts map
      _churchInviteCounts.remove(churchName);
      
      // Remove the church from the UI list
      _invitedChurchesUI.removeWhere((church) => church.name == churchName);
      
      // Update the event's invited churches list
      widget.event.invitedChurches = List.from(_invitedChurchesUI);
    });
  }

  void _editChurch(ChurchInvite church) {
    // Find and select the church for editing
    final churchData = _sampleChurches.firstWhere(
      (c) => c['name'] == church.name,
      orElse: () => {'name': church.name, 'members': church.members},
    );
    
    // Parse the roles and counts from the format "Role (count)"
    Map<String, int> roleCounts = {};
    for (var roleString in church.roles) {
      final parts = roleString.split(' (');
      if (parts.length == 2) {
        final role = parts[0];
        final countStr = parts[1].replaceAll(')', '');
        final count = int.tryParse(countStr) ?? 0;
        roleCounts[role] = count;
      }
    }
    
    setState(() {
      _selectedChurch = churchData;
      _selectedRolesCounts = roleCounts;
      _isInChurchSelectionMode = true;
    });
  }

  void _clearAllChurches() {
    setState(() {
      // Clear all church-related data
      _invitedChurchesUI.clear();
      _churchInviteCounts.clear();
      
      // Recalculate total invited people (only guests remain)
      _totalInvitedPeople = _invitedGuestsUI.length;
      
      // Update the event's invited churches list
      widget.event.invitedChurches.clear();
    });
  }

  List<Map<String, dynamic>> _getFilteredChurches() {
    if (_searchQuery.isEmpty) {
      return _sampleChurches;
    }
    
    return _sampleChurches.where((church) => 
      church['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // REWRITTEN: Show add guest form
  void _showAddGuestForm() {
    // Check if capacity is already reached
    if (_inviteType == 'Private' && _isCapacityReached()) {
      _showErrorNotification('Cannot add more guests. You have reached your capacity limit of $_expectedCapacity people.');
      return;
    }
    
    // Clear form fields first
    _usernameController.clear();
    _fullNameController.clear();
    _guestChurchController.clear();
    
    setState(() {
      _showGuestForm = true;
    });
  }

  // REWRITTEN: Hide add guest form
  void _hideAddGuestForm() {
    setState(() {
      _showGuestForm = false;
    });
  }

  // COMPLETELY REWRITTEN: Add guest function
  void _addGuest() {
    if (_usernameController.text.isEmpty || 
        _fullNameController.text.isEmpty || 
        _guestChurchController.text.isEmpty) {
      _showErrorNotification('Please fill in all guest information');
      return;
    }

    // Check if adding one more guest would exceed capacity
    if (_inviteType == 'Private' && _calculateTotalInvitedPeople() + 1 > _expectedCapacity) {
      _showErrorNotification('Cannot add more guests. It would exceed your capacity limit of $_expectedCapacity people.');
      return;
    }

    // Store the guest data temporarily
    final username = _usernameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final churchName = _guestChurchController.text.trim();
    
    // First, hide the form
    setState(() {
      _showGuestForm = false;
    });
    
    // Then in a separate setState, add the guest data
    // This ensures the UI updates correctly
    Future.microtask(() {
      setState(() {
        final newGuest = GuestInvite(
          username: username,
          fullName: fullName,
          churchName: churchName,
        );
        
        _invitedGuestsUI.add(newGuest);
        _totalInvitedPeople += 1; // Add 1 to the total for this guest
        widget.event.invitedGuests = List.from(_invitedGuestsUI);
        _showSuccessNotification('Guest added successfully');
      });
    });
  }

  void _removeGuest(int index) {
    setState(() {
      _invitedGuestsUI.removeAt(index);
      _totalInvitedPeople -= 1; // Subtract 1 from the total for this guest
      widget.event.invitedGuests = List.from(_invitedGuestsUI);
    });
  }

  // Get color for capacity indicator
  Color _getCapacityColor() {
    final totalInvited = _calculateTotalInvitedPeople();
    final percentFilled = totalInvited / _expectedCapacity;
    
    if (percentFilled >= 1.0) {
      return Colors.red;
    } else if (percentFilled >= 0.9) {
      return Colors.orange;
    } else if (percentFilled >= 0.7) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  // Check if a church is already invited
  bool _isChurchInvited(String churchName) {
    return _invitedChurchesUI.any((church) => church.name == churchName);
  }

  // Save event data and navigate to next screen
  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      // Check if current invites exceed capacity
      if (_inviteType == 'Private') {
        int totalInvited = _calculateTotalInvitedPeople();
        if (totalInvited > _expectedCapacity) {
          _showErrorNotification('Cannot proceed. Your current invites ($totalInvited people) exceed the capacity limit ($_expectedCapacity people). Please remove some invites or increase the capacity.');
          return;
        }
      }
      
      // Update event data
      widget.event.inviteType = _inviteType;
      widget.event.expectedCapacity = _expectedCapacity;
      
      if (_isCustomCapacity && _customCapacityController.text.isNotEmpty) {
        widget.event.customCapacity = _customCapacityController.text;
      } else {
        widget.event.customCapacity = null;
      }
      
      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventTargetsScreen(event: widget.event),
        ),
      );
    }
  }

  // Build a notification widget based on type
  Widget _buildNotification() {
    if (!_showNotification || _notificationMessage == null) {
      return const SizedBox.shrink();
    }
    
    Color backgroundColor;
    IconData iconData;
    
    switch (_notificationType) {
      case NotificationType.error:
        backgroundColor = Colors.red;
        iconData = Icons.error_outline;
        break;
      case NotificationType.warning:
        backgroundColor = Colors.orange;
        iconData = Icons.warning_amber_outlined;
        break;
      case NotificationType.success:
        backgroundColor = Colors.green;
        iconData = Icons.check_circle_outline;
        break;
      case NotificationType.info:
      default:
        backgroundColor = Colors.blue;
        iconData = Icons.info_outline;
        break;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _notificationMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white),
            onPressed: _dismissNotification,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChurches = _getFilteredChurches();
    final totalInvited = _calculateTotalInvitedPeople();
    final remainingCapacity = _expectedCapacity - totalInvited;
    final bool isCapacityReached = _isCapacityReached();
    
    // Add a theme override for input decorations
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _navyBlue, width: 2.0),
      ),
      focusColor: _navyBlue,
    );
    
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputDecorationTheme,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: _navyBlue,
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
              // Custom notification at the top
              _buildNotification(),
              
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
                                color: _navyBlue,
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
                                  groupValue: _inviteType,
                                  activeColor: _navyBlue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _inviteType = value!;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _inviteType = 'Open Invite';
                                    });
                                  },
                                  child: const Text('Open Invite'),
                                ),
                                const SizedBox(width: 16),

                                // Private radio button
                                Radio<String>(
                                  value: 'Private',
                                  groupValue: _inviteType,
                                  activeColor: _navyBlue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _inviteType = value!;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _inviteType = 'Private';
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
                                  child: !_isCustomCapacity
                                    ? DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: _expectedCapacity,
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down, color: _navyBlue),
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black, fontSize: 16),
                                          dropdownColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          items: [
                                            ..._capacityOptions.map((capacity) => 
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
                                                _isCustomCapacity = true;
                                              } else {
                                                _expectedCapacity = value!;
                                                
                                                // Check if current invites exceed the new capacity
                                                int totalInvited = _calculateTotalInvitedPeople();
                                                if (_inviteType == 'Private' && totalInvited > _expectedCapacity) {
                                                  _capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($_expectedCapacity people).';
                                                  
                                                  // Show warning notification
                                                  _showWarningNotification(_capacityErrorMessage!);
                                                } else {
                                                  _capacityErrorMessage = null;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    : TextFormField(
                                        controller: _customCapacityController,
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
                                            _updateExpectedCapacityFromCustomInput();
                                          }
                                        },
                                      ),
                                ),
                                if (_isCustomCapacity)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCustomCapacity = false;
                                          _expectedCapacity = 1000;
                                          
                                          // Check if current invites exceed the new capacity
                                          int totalInvited = _calculateTotalInvitedPeople();
                                          if (_inviteType == 'Private' && totalInvited > _expectedCapacity) {
                                            _capacityErrorMessage = 'Warning: Your current invites ($totalInvited people) exceed the new capacity limit ($_expectedCapacity people).';
                                            _showWarningNotification(_capacityErrorMessage!);
                                          } else {
                                            _capacityErrorMessage = null;
                                          }
                                        });
                                      },
                                      child: Text(
                                        'Use predefined options instead',
                                        style: TextStyle(color: _navyBlue),
                                      ),
                                    ),
                                  ),
                                
                                // Display capacity error message if exists
                                if (_capacityErrorMessage != null)
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
                                              _capacityErrorMessage!,
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
                            if (_inviteType == 'Private')
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
                                            color: _getCapacityColor().withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: _getCapacityColor()),
                                          ),
                                          child: Text(
                                            '$totalInvited/$_expectedCapacity',
                                            style: TextStyle(
                                              color: _getCapacityColor(),
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
                                        value: _expectedCapacity > 0 ? totalInvited / _expectedCapacity : 0,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor: AlwaysStoppedAnimation<Color>(_getCapacityColor()),
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
                            if (_inviteType == 'Private')
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
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search for churches...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: Icon(Icons.search, color: _navyBlue),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Selected church card for role selection
                                  if (_isInChurchSelectionMode && _selectedChurch != null)
                                    Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: _navyBlue,
                                                  child: const Icon(Icons.church, color: Colors.white),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        _selectedChurch!['name'],
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Text('${_selectedChurch!['members']} members'),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedChurch = null;
                                                      _selectedRolesCounts = {};
                                                      _isInChurchSelectionMode = false;
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
                                                if (_selectedRolesCounts.isNotEmpty)
                                                  TextButton.icon(
                                                    icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.red),
                                                    label: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12)),
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedRolesCounts = {};
                                                      });
                                                    },
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: _navyBlue),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: _selectedRolesCounts.isEmpty
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
                                                          _selectedRolesCounts.entries.length,
                                                          (index) {
                                                            final entry = _selectedRolesCounts.entries.elementAt(index);
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
                                              onPressed: _showRoleSelectionDialog,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _navyBlue,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(double.infinity, 48),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: _selectedRolesCounts.isEmpty 
                                                  ? null 
                                                  : _addChurchWithRoles,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _forestGreen,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(double.infinity, 48),
                                              ),
                                              child: const Text('Add Church', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  
                                  // Church list
                                  if (!_isInChurchSelectionMode)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: filteredChurches.length,
                                      itemBuilder: (context, index) {
                                        final church = filteredChurches[index];
                                        final isInvited = _isChurchInvited(church['name']);
                                        
                                        // Determine if this church should be disabled
                                        // If capacity is reached and this church is not already invited, disable it
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
                                              backgroundColor: _navyBlue,
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
                                                        : _navyBlue,
                                                size: 28,
                                              ),
                                              onPressed: isDisabled 
                                                  ? null 
                                                  : () {
                                                      if (isInvited) {
                                                        // If already invited, remove the church
                                                        _removeChurch(church['name']);
                                                      } else {
                                                        // If not invited, select the church to add
                                                        _selectChurch(church);
                                                      }
                                                    },
                                            ),
                                            onTap: isDisabled 
                                                ? () {
                                                    // Show message that capacity is reached
                                                    _showErrorNotification('Cannot add more churches. You have reached your capacity limit of $_expectedCapacity people.');
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
                                                                  _removeChurch(church['name']);
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
                                                      _selectChurch(church);
                                                    }
                                                  },
                                          ),
                                        );
                                      },
                                    ),

                                  // Display invited churches
                                  if (_invitedChurchesUI.isNotEmpty && !_isInChurchSelectionMode)
                                    Column(
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
                                            if (_invitedChurchesUI.isNotEmpty)
                                              TextButton.icon(
                                                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                                                label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                                                onPressed: _clearAllChurches,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ..._invitedChurchesUI.map((church) => Card(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: _navyBlue,
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
                                                  icon: Icon(Icons.edit, color: _navyBlue),
                                                  onPressed: () => _editChurch(church),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () => _removeChurch(church.name),
                                                ),
                                              ],
                                            ),
                                            isThreeLine: true,
                                          ),
                                        )),
                                      ],
                                    ),

                                  // Add Guests section - updated with more detailed form
                                  const SizedBox(height: 24),
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
                                      if (_invitedGuestsUI.isNotEmpty)
                                        TextButton.icon(
                                          icon: const Icon(Icons.delete_sweep, color: Colors.red),
                                          label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            setState(() {
                                              _totalInvitedPeople -= _invitedGuestsUI.length; // Update total count
                                              _invitedGuestsUI.clear();
                                              widget.event.invitedGuests.clear();
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Guest form
                                  if (_showGuestForm)
                                    Container(
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
                                            controller: _usernameController,
                                            decoration: InputDecoration(
                                              labelText: 'Username',
                                              border: const OutlineInputBorder(),
                                              prefixIcon: const Icon(Icons.alternate_email),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: _navyBlue, width: 2.0),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey.shade100,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: _fullNameController,
                                            decoration: InputDecoration(
                                              labelText: 'Full Name',
                                              border: const OutlineInputBorder(),
                                              prefixIcon: const Icon(Icons.person),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: _navyBlue, width: 2.0),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey.shade100,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: _guestChurchController,
                                            decoration: InputDecoration(
                                              labelText: 'Church Name',
                                              border: const OutlineInputBorder(),
                                              prefixIcon: const Icon(Icons.church),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: _navyBlue, width: 2.0),
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
                                                  onPressed: _hideAddGuestForm,
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
                                                  onPressed: _addGuest,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: _navyBlue,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text('Add Guest', style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.person_add, color: Colors.white),
                                      label: const Text('Add New Guest', style: TextStyle(color: Colors.white)),
                                      onPressed: isCapacityReached
                                        ? () {
                                            _showErrorNotification('Cannot add more guests. You have reached your capacity limit of $_expectedCapacity people.');
                                          }
                                        : _showAddGuestForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCapacityReached
                                          ? Colors.grey
                                          : _navyBlue,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),

                                  // Display invited guests
                                  if (_invitedGuestsUI.isNotEmpty)
                                    Column(
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
                                        ...List.generate(_invitedGuestsUI.length, (index) {
                                          final guest = _invitedGuestsUI[index];
                                          return Card(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: _navyBlue,
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
                                                onPressed: () => _removeGuest(index),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
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
                        onPressed: _saveAndContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navyBlue,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Notification type enum
enum NotificationType {
  error,
  warning,
  success,
  info,
}

// Model classes for church and guest invites
class ChurchInvite {
  final String name;
  final int members;
  final List<String> roles;

  ChurchInvite({
    required this.name,
    required this.members,
    required this.roles,
  });
}

class GuestInvite {
  final String username;
  final String fullName;
  final String churchName;

  GuestInvite({
    required this.username,
    required this.fullName,
    required this.churchName,
  });
}

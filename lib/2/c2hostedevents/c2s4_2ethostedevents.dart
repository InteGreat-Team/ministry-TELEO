import 'package:flutter/material.dart';
import 'c2s4_1ethostedevents.dart';
import 'models/volunteer.dart';

class VolunteersTab extends StatefulWidget {
  final Map<String, dynamic> eventData;
  
  const VolunteersTab({
    super.key,
    required this.eventData,
  });

  @override
  State<VolunteersTab> createState() => _VolunteersTabState();
}

class _VolunteersTabState extends State<VolunteersTab> {
  String _searchQuery = '';
  String _selectedStatus = 'ALL';
  final List<String> _statusOptions = ['ALL', 'Accepted', 'Pending', 'Rejected', 'Exited', 'Exit Requests'];
  
  // Local copy of volunteers data that can be modified
  late List<Map<String, dynamic>> _volunteers;
  
  @override
  void initState() {
    super.initState();
    // Create a deep copy of the volunteers data
    _volunteers = List<Map<String, dynamic>>.from(dummyVolunteers);
    
    // Add exit request to Brent Damian for demonstration
    final brentIndex = _volunteers.indexWhere((v) => v['name'] == 'Brent Damian');
    if (brentIndex != -1) {
      _volunteers[brentIndex]['wantsToExit'] = true;
      _volunteers[brentIndex]['exitForm'] = {
        'submissionDate': 'March 18, 2025',
        'reason': 'Personal commitment',
        'description': 'I have a family emergency that requires my attention.'
      };
    }
    
    // Add exit request to Analise Bell as well
    final analiseIndex = _volunteers.indexWhere((v) => v['name'] == 'Analise Bell');
    if (analiseIndex != -1) {
      _volunteers[analiseIndex]['wantsToExit'] = true;
      _volunteers[analiseIndex]['exitForm'] = {
        'submissionDate': 'March 20, 2025',
        'reason': 'Health issues',
        'description': 'I need to focus on my health for the next few months.'
      };
    }
    
    // Debug print the event data
    print("Event Data in VolunteersTab: ${widget.eventData}");
  }

  // Filtered volunteers based on search and status
  List<Map<String, dynamic>> get _filteredVolunteers {
    return _volunteers.where((volunteer) {
      // Special filter for exit requests
      if (_selectedStatus == 'EXIT_REQUESTS') {
        return volunteer['wantsToExit'] == true && 
               volunteer['exitDenied'] != true && 
               volunteer['status'] != 'Exited';
      }
      
      // Filter by status
      if (_selectedStatus != 'ALL' && volunteer['status'] != _selectedStatus) {
        return false;
      }
      
      // Filter by search query
      if (_searchQuery.isEmpty) {
        return true;
      }
      
      final String name = volunteer['name'].toLowerCase();
      final String church = volunteer['church'].toLowerCase();
      final String query = _searchQuery.toLowerCase();
      
      return name.contains(query) || church.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for something...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
        
        // Status filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity, // Make it full width like the search bar
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell( // Make the entire container clickable
              onTap: () {
                // Show the dropdown menu when tapping anywhere on the container
                final RenderBox button = context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(Offset.zero, ancestor: overlay),
                    button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );
                
                showMenu<String>(
                  context: context,
                  position: position,
                  items: _statusOptions.map((String status) {
                    return PopupMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ).then((String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                      // Handle the special case for Exit Requests
                      if (value == 'Exit Requests') {
                        _selectedStatus = 'EXIT_REQUESTS';
                      }
                    });
                  }
                });
              },
              child: Row(
                children: [
                  const Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedStatus == 'EXIT_REQUESTS' ? 'Exit Requests' : _selectedStatus,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        
        
        const SizedBox(height: 8),
        
        // Volunteers list
        Expanded(
          child: _filteredVolunteers.isEmpty
              ? const Center(
                  child: Text(
                    'No volunteers found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredVolunteers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final volunteer = _filteredVolunteers[index];
                    final bool isReported = volunteer['isReported'] == true;
                    final bool wantsToExit = volunteer['wantsToExit'] == true;
                    final bool exitDenied = volunteer['exitDenied'] == true;
                    final bool isExited = volunteer['status'] == 'Exited';
                    
                    return InkWell(
                      onTap: () async {
                        // Navigate to volunteer detail page
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VolunteerDetailPage(
                              volunteer: volunteer,
                              eventData: widget.eventData, volunteerData: {},
                            ),
                          ),
                        );
                        
                        // Handle the result from the detail page
                        if (result != null) {
                          setState(() {
                            if (result is Map<String, dynamic> && result['action'] == 'remove') {
                              // Remove the volunteer from the list
                              _volunteers.removeWhere((v) => v['id'] == result['volunteerId']);
                              
                              // Show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Volunteer removed successfully'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (result is Map<String, dynamic>) {
                              // Update the volunteer data
                              final index = _volunteers.indexWhere((v) => v['id'] == result['id']);
                              if (index != -1) {
                                _volunteers[index] = result;
                              }
                            }
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // Avatar with consistent gray icon
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Volunteer info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        volunteer['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (isReported)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.red[400],
                                            size: 16,
                                          ),
                                        ),
                                      if (wantsToExit && !exitDenied && !isExited)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.exit_to_app,
                                                  color: Colors.blue[700],
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Exit Request',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        volunteer['status'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: volunteer['status'] == 'Pending'
                                              ? Colors.orange
                                              : volunteer['status'] == 'Accepted'
                                                  ? Colors.green
                                                  : volunteer['status'] == 'Exited'
                                                      ? Colors.blue
                                                      : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        volunteer['church'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

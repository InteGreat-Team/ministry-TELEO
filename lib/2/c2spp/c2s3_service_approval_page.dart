import 'package:flutter/material.dart';
import 'assignment_confirmation_page.dart';
import 'models/facilitator_model.dart';
import 'models/service_request_model.dart';

class ServiceApprovalPage extends StatefulWidget {
  const ServiceApprovalPage({super.key});

  @override
  State<ServiceApprovalPage> createState() => _ServiceRequestsPageState();
}

class _ServiceRequestsPageState extends State<ServiceApprovalPage> {
  // Currently assigned facilitator
  final Facilitator _currentlyAssigned = Facilitator(
    name: 'Lebron James',
    role: 'Pastor',
    status: 'Schedule Conflict',
    isAvailable: false,
    isActive: true,
  );

  final List<Facilitator> _facilitators = [
    Facilitator(
      name: 'John Jhong Cook', // Updated name
      role: 'Pastor',
      status: 'Schedule Conflict',
      isAvailable: false,
      isSelected: true,
      isActive: true,
    ),
    Facilitator(
      name: 'Mah Shayla',
      role: 'Leader',
      status: 'Available',
      isAvailable: true,
      isSelected: true,
      isActive: false,
    ),
    Facilitator(
      name: 'Tailor Sweep',
      role: 'Leader',
      status: 'Available',
      isAvailable: true,
      isSelected: true,
      isActive: true,
    ),
    Facilitator(
      name: 'Sabrina Carpenter',
      role: 'Pastor',
      status: 'Available',
      isAvailable: true,
      isSelected: true,
      isActive: true,
    ),
    Facilitator(
      name: 'Harry Styles', // Added Harry Styles instead of Lebron James
      role: 'Pastor',
      status: 'Available',
      isAvailable: true,
      isSelected: true,
      isActive: true,
    ),
  ];

  bool _selectAll = true;
  bool _isEditing = true;

  // Function to show the confirmation dialog
  Future<void> _showCancelConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Cancel Editing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Message
                const Text(
                  'Are you sure you want to cancel editing this service assignment?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    // No button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF000233),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000233),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Yes, proceed button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            Navigator.of(
                              context,
                            ).pop(); // Return to previous screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Yes, proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF000233), // Dark navy blue color
          ),
        ),
        title: const Text(
          'Upcoming Services',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White background container for the top section
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Requester Info
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name and location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service Requester Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Default location where theyre booking from',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Service details
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service type with heart icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Service: ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'Baptism and Dedication',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Time with clock icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Time: ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Text(
                              'May 5, 3:00 PM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),

                        // Scheduled tag on a separate line with proper alignment
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0, top: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Scheduled for Later',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0078D4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location with location icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'To the church',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Special request - indented
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            '"Please assign Fr. Lebron James if available"',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Partial divider (not edge to edge)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(height: 1, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),

            // Reassign Facilitator section (new)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reassign Facilitator',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Currently Assigned section (new)
                  const Text(
                    'Currently Assigned',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Currently assigned facilitator card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Profile image with status indicator
                        Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Status indicator
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF15D474,
                                  ), // Green for active
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Name and role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentlyAssigned.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currentlyAssigned.role,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Schedule Conflict',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF9966),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Remove button (X)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0078D4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pastors and Leaders section
                  const Text(
                    'Pastors and Leaders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Active Now with Select All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Now (5)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      // Wrap both text and checkbox in a single GestureDetector
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectAll = !_selectAll;
                            for (var facilitator in _facilitators) {
                              facilitator.isSelected = _selectAll;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Select All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFFF6B35),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Changed to use white checkmark on red background
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _selectAll
                                    ? const Color(0xFFFF6B35)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFFFF6B35),
                                  width: 2,
                                ),
                              ),
                              child: _selectAll
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white, // White checkmark
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Facilitator list
                  ..._facilitators.map(
                    (facilitator) => _buildFacilitatorItem(facilitator),
                  ),

                  const SizedBox(height: 24),

                  // Send Assignment Request button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Get the list of selected facilitators
                        List<String> selectedFacilitators = _facilitators
                            .where(
                              (facilitator) => facilitator.isSelected,
                            )
                            .map(
                              (facilitator) => facilitator.name,
                            )
                            .toList();

                        // Create a map with service details to pass to the confirmation page
                        Map<String, dynamic> serviceDetails = {
                          'name': 'Service Requester Name',
                          'location':
                              'Default location where theyre booking from',
                          'service': 'Baptism and Dedication',
                          'timeText': 'May 5, 3:00 PM',
                          'scheduledText': 'Scheduled for Later',
                          'destination': 'To the church',
                        };

                        // Navigate to the assignment confirmation page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssignmentConfirmationPage(
                              selectedFacilitators: selectedFacilitators,
                              serviceDetails: ServiceRequest(
                                name: serviceDetails['name'],
                                location: serviceDetails['location'],
                                service: serviceDetails['service'],
                                timeType:
                                    'scheduled', // or 'fast' if you have it
                                timeText: serviceDetails['timeText'],
                                scheduledText: serviceDetails['scheduledText'],
                                destination: serviceDetails['destination'],
                                countdown: '',
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF000233,
                          ), // Dark navy blue color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            'Send Assignment Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cancel Editing button (new)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        // Show confirmation dialog before navigating back
                        _showCancelConfirmationDialog();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF000233),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel Editing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233),
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

  Widget _buildFacilitatorItem(Facilitator facilitator) {
    Color statusColor;
    Color statusBgColor;

    if (facilitator.status == 'Available') {
      statusColor = const Color(0xFF00A300);
      statusBgColor = const Color(0xFFE6FFE6);
    } else {
      statusColor = const Color(0xFFFF9966);
      statusBgColor = const Color(0xFFFFF5F0);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              // Profile image with status indicator
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Always show a status indicator - green for active, gray for inactive
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: facilitator.isActive
                            ? const Color(0xFF15D474) // Green for active
                            : const Color(0xFF757575), // Gray for inactive
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name and role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facilitator.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      facilitator.role,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  facilitator.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Checkbox with white checkmark on red background (changed)
              GestureDetector(
                onTap: () {
                  setState(() {
                    facilitator.isSelected = !facilitator.isSelected;
                    // Check if all facilitators are selected to update _selectAll state
                    bool allSelected = _facilitators.every(
                      (f) => f.isSelected,
                    );
                    _selectAll = allSelected;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: facilitator.isSelected
                        ? const Color(0xFFFF6B35)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFFFF6B35),
                      width: 2,
                    ),
                  ),
                  child: facilitator.isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white, // White checkmark
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

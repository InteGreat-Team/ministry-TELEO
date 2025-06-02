import 'package:flutter/material.dart';
import '../c2spp/service_notification_confirmation_page.dart'; // Import the notification page

class ServiceAcceptedPage extends StatelessWidget {
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> facilitatorDetails;

  const ServiceAcceptedPage({
    super.key,
    required this.serviceDetails,
    required this.facilitatorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        elevation: 0,
        centerTitle: true,
        // Add these properties to prevent color change when scrolling
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(color: const Color(0xFF000233)),
        title: const Text(
          'Service Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Step indicator - FIXED TO HIGHLIGHT STEP 2
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                child: Row(
                  children: [
                    // Step 1 - Inactive (white with blue border)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF000233),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Line between 1 and 2
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                    ),

                    // Step 2 - Active (dark blue with white text)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF000233),
                        border: Border.all(
                          color: const Color(0xFF000233),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Line between 2 and 3
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                    ),

                    // Step 3 - Inactive
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF000233),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 30), // Increased spacing after step indicator

              // Green illustrations - Adjusted spacing and size
              Image.asset(
                'assets/images/service_accepted_illustration.JPG',
                height: 220, // Adjusted height to match second image
                width: double.infinity,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20), // Adjusted spacing after image

              // Automatically assigned text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'The service request has been automatically assigned.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Facilitator info - FIXED OVERFLOW ISSUE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Avatar and info
                    Flexible(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile image
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[300],
                            // Removed the child property that was displaying the text
                          ),
                          const SizedBox(width: 12),

                          // Name, role and acceptance info
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facilitatorDetails['name'] ?? 'Lebron James',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  facilitatorDetails['role'] ?? 'Pastor',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Accepted on: ${facilitatorDetails['acceptedDate'] ?? '[Date]'} at ${facilitatorDetails['acceptedTime'] ?? '[Time]'}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
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

                    const SizedBox(width: 8),

                    // Right side: Reassign button
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Reassign\nFacilitator',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Service request summary card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pink left border
                      Container(
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),

                      // Card content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service requestor info
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceDetails['name'] ??
                                              'Service Requestor Name',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          serviceDetails['location'] ??
                                              'Default location where theyre booking from',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Service type
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_border,
                                      size: 18, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Service: ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      serviceDetails['service'] ??
                                          'Baptism and Dedication',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Time
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 18, color: Colors.grey[600]),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Time: ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        serviceDetails['timeText'] ??
                                            'May 5, 3:00 PM',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      serviceDetails['scheduledText'] ??
                                          'Scheduled for Later',
                                      style: TextStyle(
                                        color: Colors.blue[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Location
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Icon(Icons.location_on_outlined,
                                        size: 18, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceDetails['destination'] ??
                                              'To the church',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '"Please assign Fr. Lebron James if available"',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    // Cancel Booking button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle cancel booking
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF000233)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel Booking',
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Notify Requester button - UPDATED with navigation
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the notification confirmation page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ServiceNotificationConfirmationPage(
                                serviceDetails: serviceDetails,
                                facilitatorDetails: facilitatorDetails,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000233),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Notify Requester',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

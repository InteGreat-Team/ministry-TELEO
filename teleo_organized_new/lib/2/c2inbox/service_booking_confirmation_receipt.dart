import 'package:flutter/material.dart';

class ServiceBookingConfirmationReceipt extends StatefulWidget {
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> personalDetails;
  final Map<String, dynamic> paymentDetails;

  const ServiceBookingConfirmationReceipt({
    super.key,
    required this.serviceDetails,
    required this.personalDetails,
    required this.paymentDetails,
  });

  @override
  State<ServiceBookingConfirmationReceipt> createState() => _ServiceBookingConfirmationReceiptState();
}

class _ServiceBookingConfirmationReceiptState extends State<ServiceBookingConfirmationReceipt> {
  bool _isPersonalDetailsExpanded = false;
  bool _isServiceInfoExpanded = false;
  bool _isPaymentDetailsExpanded = false;
  bool _isAmountPaidExpanded = true; // Amount Paid section expanded by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Use a standard AppBar with scrolledUnderElevation set to 0 to prevent color change
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        elevation: 0,
        centerTitle: true,
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
      // Use a NestedScrollView to allow the app bar to scroll away
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator - Now part of the scrollable content
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Row(
                  children: [
                    // Step 1 - Inactive
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

                    // Step 2 - Inactive
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
                          "2",
                          style: TextStyle(
                            color: Color(0xFF000233),
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

                    // Step 3 - Active (dark blue with white text)
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
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Service Booking Confirmed title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Service Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Booking Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reference number
                    _buildDetailRow(
                      'Reference #',
                      widget.serviceDetails['reference'] ?? 'AJSNDF8034U93829FWB',
                    ),

                    // Date
                    _buildDetailRow(
                      'Date',
                      widget.serviceDetails['date'] ?? '[Date] at [Time]',
                    ),

                    const SizedBox(height: 15),

                    // Service requester info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),

                        // Requester details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceDetails['name'] ?? 'Service Requestor Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.serviceDetails['location'] ?? 'Default location where theyre booking from',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Service details
                    Row(
                      children: [
                        Icon(Icons.favorite_border, size: 18, color: Colors.grey[600]),
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
                            widget.serviceDetails['service'] ?? 'Baptism and Dedication',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Time
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.serviceDetails['timeText'] ?? 'May 5, 3:00 PM',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.serviceDetails['scheduledText'] ?? 'Scheduled for Later',
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
                          child: Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.serviceDetails['destination'] ?? 'To the church',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Assigned to
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(Icons.person_outline, size: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Assigned to: ${widget.serviceDetails['assignedTo'] ?? '@Lebron James'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              const Divider(height: 1),

              // Personal Details (Expandable)
              _buildExpandableSection(
                title: 'Personal Details',
                isExpanded: _isPersonalDetailsExpanded,
                onTap: () {
                  setState(() {
                    _isPersonalDetailsExpanded = !_isPersonalDetailsExpanded;
                  });
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Full Name',
                      widget.personalDetails['fullName'] ?? 'John G. Dela Cruz',
                    ),
                    _buildDetailRow(
                      'Age',
                      widget.personalDetails['age'] ?? '27',
                    ),
                    _buildDetailRow(
                      'Gender',
                      widget.personalDetails['gender'] ?? 'Male',
                    ),
                    _buildDetailRow(
                      'Contact Number',
                      widget.personalDetails['contactNumber'] ?? '09272944324',
                    ),
                    _buildDetailRow(
                      'Email Address',
                      widget.personalDetails['emailAddress'] ?? 'johngdelacruz@gmail.com',
                    ),
                    _buildDetailRow(
                      'Primary Emergency Person',
                      widget.personalDetails['emergencyPerson'] ?? 'Maria B. Dela Cruz',
                    ),
                    _buildDetailRow(
                      'Primary Emergency Person Number',
                      widget.personalDetails['emergencyNumber'] ?? '0999999999',
                    ),
                    _buildDetailRow(
                      'Primary Emergency Person Relation',
                      widget.personalDetails['emergencyRelation'] ?? 'Spouse',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Service Information (Expandable)
              _buildExpandableSection(
                title: 'Service Information',
                isExpanded: _isServiceInfoExpanded,
                onTap: () {
                  setState(() {
                    _isServiceInfoExpanded = !_isServiceInfoExpanded;
                  });
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Event Booking',
                      widget.serviceDetails['eventBooking'] ?? 'Event API stuff',
                    ),
                    _buildDetailRow(
                      'Baptizand Full Name',
                      widget.serviceDetails['baptizandName'] ?? 'Baby G. Dela Cruz',
                    ),
                    _buildDetailRow(
                      'Date of Birth',
                      widget.serviceDetails['dateOfBirth'] ?? '01/20/2025',
                    ),
                    _buildDetailRow(
                      'Gender',
                      widget.serviceDetails['baptizandGender'] ?? 'Male',
                    ),
                    _buildDetailRow(
                      'Type of Ceremony',
                      widget.serviceDetails['ceremonyType'] ?? 'Infant',
                    ),
                    _buildDetailRow(
                      'Name of Parent/Guardian',
                      widget.serviceDetails['parentName'] ?? 'John G. Dela Cruz',
                    ),
                    _buildDetailRow(
                      'Relation to Baptizand',
                      widget.serviceDetails['relation'] ?? 'Father',
                    ),
                    _buildDetailRow(
                      'Purpose/Reason for Service',
                      widget.serviceDetails['purpose'] ?? 'Our son is to be baptized into Christianity.',
                    ),
                    _buildDetailRow(
                      'Anything else we need to know?',
                      widget.serviceDetails['additionalInfo'] ?? 'Please assign Fr. Lebron James if available.',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Payment Details (Expandable)
              _buildExpandableSection(
                title: 'Payment Details',
                isExpanded: _isPaymentDetailsExpanded,
                onTap: () {
                  setState(() {
                    _isPaymentDetailsExpanded = !_isPaymentDetailsExpanded;
                  });
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Status',
                      widget.paymentDetails['status'] ?? 'Paid',
                      valueColor: Colors.green,
                      valueBold: true,
                      valueBackground: Colors.green.withOpacity(0.1),
                      valuePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      valueBorderRadius: BorderRadius.circular(4),
                    ),
                    _buildDetailRow(
                      'Date',
                      widget.paymentDetails['date'] ?? '[Date when paid]',
                    ),
                    _buildDetailRow(
                      'Method',
                      widget.paymentDetails['method'] ?? 'Credit Card',
                    ),
                    _buildDetailRow(
                      'Holder\'s Full Name',
                      widget.paymentDetails['holderName'] ?? 'Jack Black',
                    ),
                    _buildDetailRow(
                      'Transaction ID',
                      widget.paymentDetails['transactionId'] ?? 'JSDBK-2893-2384',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Amount Paid (Expandable)
              _buildExpandableSection(
                title: 'Amount Paid',
                isExpanded: _isAmountPaidExpanded,
                onTap: () {
                  setState(() {
                    _isAmountPaidExpanded = !_isAmountPaidExpanded;
                  });
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Fee
                    _buildAmountRow(
                      'Service Fee',
                      widget.paymentDetails['serviceFee'] ?? '200.00',
                    ),

                    // Distance Fee
                    _buildAmountRow(
                      'Distance Fee (₱ per exceeding 1km)',
                      widget.paymentDetails['distanceFee'] ?? '20.20',
                    ),

                    const Divider(),

                    // Total
                    _buildAmountRow(
                      'Total',
                      widget.paymentDetails['total'] ?? '220.20',
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // View in 'Our Bookings' Tab button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Our Bookings tab
                      Navigator.pop(context);
                      // Additional navigation logic would go here
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF000233)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View in \'Our Bookings\' Tab',
                      style: TextStyle(
                        color: Color(0xFF000233),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build expandable sections
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: content,
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(
      String label,
      String value, {
        Color? valueColor,
        bool valueBold = false,
        Color? valueBackground,
        EdgeInsets? valuePadding,
        BorderRadius? valueBorderRadius,
      }) {
    final textWidget = Text(
      value,
      style: TextStyle(
        fontSize: 14,
        fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
        color: valueColor ?? const Color(0xFF333333),
      ),
      textAlign: TextAlign.right,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: valueBackground != null
                ? Container(
              padding: valuePadding,
              decoration: BoxDecoration(
                color: valueBackground,
                borderRadius: valueBorderRadius,
              ),
              child: textWidget,
            )
                : textWidget,
          ),
        ],
      ),
    );
  }

  // Helper method to build amount rows
  Widget _buildAmountRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF333333) : Colors.grey[600],
            ),
          ),
          Text(
            '₱ $amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

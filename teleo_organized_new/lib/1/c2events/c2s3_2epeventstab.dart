import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasReachedEnd = false;
  bool _isAcceptButtonEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (!_hasReachedEnd) {
        setState(() {
          _hasReachedEnd = true;
          _isAcceptButtonEnabled = true;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        title: const Text(
          'Legal Policies and Guidelines',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Column(
        children: [
          // Terms and conditions content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Legal Policies and Guidelines for Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000233),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Introduction
                  _buildSectionTitle('1. Introduction'),
                  _buildParagraph(
                    'Welcome to our church event. By registering for this event, you agree to comply with and be bound by the following terms and conditions. Please read these terms carefully before completing your registration.'
                  ),
                  
                  // Registration and Attendance
                  _buildSectionTitle('2. Registration and Attendance'),
                  _buildParagraph(
                    '2.1. All participants must complete the registration process accurately and truthfully.'
                  ),
                  _buildParagraph(
                    '2.2. Registration is only confirmed upon completion of all required fields and acceptance of these terms.'
                  ),
                  _buildParagraph(
                    '2.3. The church reserves the right to refuse or cancel any registration at its sole discretion.'
                  ),
                  _buildParagraph(
                    '2.4. Participants are expected to arrive on time and follow the event schedule.'
                  ),
                  _buildParagraph(
                    '2.5. Participants under 18 years of age must have parental or guardian consent to attend.'
                  ),
                  
                  // Code of Conduct
                  _buildSectionTitle('3. Code of Conduct'),
                  _buildParagraph(
                    '3.1. All participants are expected to behave in a respectful and appropriate manner.'
                  ),
                  _buildParagraph(
                    '3.2. Harassment, discrimination, or disruptive behavior of any kind will not be tolerated.'
                  ),
                  _buildParagraph(
                    '3.3. Participants must follow instructions from event organizers and staff.'
                  ),
                  _buildParagraph(
                    '3.4. Dress code requirements, if specified, must be adhered to.'
                  ),
                  _buildParagraph(
                    '3.5. The use of alcohol, illegal drugs, or tobacco products is strictly prohibited.'
                  ),
                  
                  // Health and Safety
                  _buildSectionTitle('4. Health and Safety'),
                  _buildParagraph(
                    '4.1. Participants are responsible for their own health and safety during the event.'
                  ),
                  _buildParagraph(
                    '4.2. Any medical conditions, allergies, or dietary restrictions should be disclosed during registration.'
                  ),
                  _buildParagraph(
                    '4.3. In case of emergency, event staff will contact the emergency contacts provided during registration.'
                  ),
                  _buildParagraph(
                    '4.4. The church is not responsible for any personal injury or illness that may occur during the event.'
                  ),
                  _buildParagraph(
                    '4.5. Participants must follow all health and safety protocols established for the event.'
                  ),
                  
                  // Photography and Recording
                  _buildSectionTitle('5. Photography and Recording'),
                  _buildParagraph(
                    '5.1. By attending the event, participants consent to being photographed, filmed, or recorded.'
                  ),
                  _buildParagraph(
                    '5.2. The church reserves the right to use photographs, videos, or recordings for promotional, educational, or archival purposes.'
                  ),
                  _buildParagraph(
                    '5.3. Participants who do not wish to be photographed or recorded should notify the event organizers in writing.'
                  ),
                  
                  // Personal Property
                  _buildSectionTitle('6. Personal Property'),
                  _buildParagraph(
                    '6.1. The church is not responsible for any lost, stolen, or damaged personal property.'
                  ),
                  _buildParagraph(
                    '6.2. Participants are advised to keep valuable items secure at all times.'
                  ),
                  
                  // Cancellation and Refunds
                  _buildSectionTitle('7. Cancellation and Refunds'),
                  _buildParagraph(
                    '7.1. The church reserves the right to cancel or reschedule the event due to unforeseen circumstances.'
                  ),
                  _buildParagraph(
                    '7.2. In case of event cancellation by the church, participants will be notified as soon as possible.'
                  ),
                  _buildParagraph(
                    '7.3. Refund policies, if applicable, will be communicated to participants.'
                  ),
                  
                  // Data Privacy
                  _buildSectionTitle('8. Data Privacy'),
                  _buildParagraph(
                    '8.1. Personal information collected during registration will be used solely for event-related purposes.'
                  ),
                  _buildParagraph(
                    '8.2. The church will not share participant information with third parties without consent, except as required by law.'
                  ),
                  _buildParagraph(
                    '8.3. Participants have the right to access, correct, or delete their personal information by contacting the church.'
                  ),
                  
                  // Liability Waiver
                  _buildSectionTitle('9. Liability Waiver'),
                  _buildParagraph(
                    '9.1. By registering for the event, participants waive any and all claims against the church, its staff, volunteers, and affiliates for any liability, loss, damage, or injury.'
                  ),
                  _buildParagraph(
                    '9.2. Participants acknowledge that they are participating in the event voluntarily and at their own risk.'
                  ),
                  
                  // Amendments
                  _buildSectionTitle('10. Amendments'),
                  _buildParagraph(
                    '10.1. The church reserves the right to modify these terms and conditions at any time.'
                  ),
                  _buildParagraph(
                    '10.2. Any changes will be communicated to participants and will be effective immediately.'
                  ),
                  
                  // Contact Information
                  _buildSectionTitle('11. Contact Information'),
                  _buildParagraph(
                    'For questions or concerns regarding these terms and conditions, please contact the event organizers at events@churchname.org or call (123) 456-7890.'
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          
          // Accept button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Divider above the button row
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                
                // Button row with warning message
                Row(
                  children: [
                    // Warning message with much more space
                    if (!_hasReachedEnd)
                      Expanded(
                        flex: 3, // Give more space to the warning message
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Please read the entire document before accepting',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Spacer only if warning is shown
                    if (!_hasReachedEnd) const SizedBox(width: 16),
                    
                    // Accept button
                    Expanded(
                      flex: 1, // Give less space to the button
                      child: ElevatedButton(
                        onPressed: _isAcceptButtonEnabled
                            ? () => Navigator.pop(context, true)
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          backgroundColor: const Color(0xFF000233),
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'I Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // Helper method to build paragraphs
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
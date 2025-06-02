import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/step_indicator.dart';
import 'c2s6bsweddingform.dart';

class ServiceInformationScreen extends StatefulWidget {
  final Map<String, String> personalDetails;

  const ServiceInformationScreen({
    super.key, 
    required this.personalDetails,
  });

  @override
  State<ServiceInformationScreen> createState() => _ServiceInformationScreenState();
}

class _ServiceInformationScreenState extends State<ServiceInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCeremonyType = 'Traditional';

  DateTime? selectedDate;

  // Controllers to store user input for summary
  final TextEditingController _brideNameController = TextEditingController();
  final TextEditingController _groomNameController = TextEditingController();
  final TextEditingController _weddingDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  // Get minimum allowed date (1 week from today)
  DateTime _getMinimumAllowedDate() {
    return DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _brideNameController.dispose();
    _groomNameController.dispose();
    _weddingDateController.dispose();
    _reasonController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Set minimum date to 1 week from today
    final DateTime minimumDate = _getMinimumAllowedDate();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? minimumDate,
      firstDate: minimumDate, // Only allow dates 1 week from now
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _weddingDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wedding Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 14,
          ),
          label: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        leadingWidth: 80,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A4A),
        ),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StepIndicator(currentStep: 4, totalSteps: 7),
                          const SizedBox(height: 20),
                          
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Wedding ',
                                  style: TextStyle(
                                    color: Color(0xFF0A0A4A),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Information',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please fill out the following fields',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Couple Information
                          const Text(
                            'Couple Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Bride's Full Name
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Bride\'s Full Name ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 232, 12, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _brideNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Enter bride's full name",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter bride\'s name';
                              }
                              // Only allow letters and spaces
                              if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(value)) {
                                return 'Please enter a valid name (letters only)';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                            ],
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          
                          // Groom's Full Name
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Groom\'s Full Name ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 232, 12, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _groomNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Enter groom's full name",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter groom\'s name';
                              }
                              // Only allow letters and spaces
                              if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(value)) {
                                return 'Please enter a valid name (letters only)';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                            ],
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          
                          // Wedding Date
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Wedding Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 232, 12, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _weddingDateController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  hintText: "MM/DD/YYYY (must be at least 1 week from today)",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  helperText: "Wedding date must be at least 1 week from today",
                                  helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select wedding date';
                                  }
                                  
                                  // Verify the selected date is at least 1 week in the future
                                  if (selectedDate != null) {
                                    final minimumDate = _getMinimumAllowedDate();
                                    if (selectedDate!.isBefore(minimumDate)) {
                                      return 'Wedding date must be at least 1 week from today';
                                    }
                                  }
                                  
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Type of Ceremony
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Type of Ceremony ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 232, 12, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedCeremonyType,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                              dropdownColor: Colors.white,
                              items: [
                                'Traditional',
                                'Civil', 
                                'Religious',
                                'Destination',
                                'Themed'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCeremonyType = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Special Requests/Notes
                          const Text(
                            'Special Requests/Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextFormField(
                            controller: _reasonController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Any special requests or notes for your wedding ceremony",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Anything else we need to know
                          const Text(
                            'Anything else we need to know?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextFormField(
                            controller: _additionalInfoController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "(Optional)",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Navigation buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0A0A4A)),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Color(0xFF0A0A4A),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Combine personal details with service details
                                      final allDetails = {
                                        ...widget.personalDetails,
                                        'brideName': _brideNameController.text,
                                        'groomName': _groomNameController.text,
                                        'weddingDate': _weddingDateController.text,
                                        'ceremonyType': selectedCeremonyType,
                                        'specialRequests': _reasonController.text,
                                        'additionalInfo': _additionalInfoController.text,
                                      };
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventManagementScreen(
                                            allDetails: allDetails,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A0A4A),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/step_indicator.dart';
import 'c2s6bsbaptismform.dart';

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
  String selectedGender = 'Male';
  String selectedCeremony = 'Newborn'; // Changed from 'Infant' to 'Newborn'

  DateTime? selectedDate;

  // Controllers to store user input for summary
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _reasonController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        _dobController.text = DateFormat('MM/dd/yyyy').format(picked);
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
          'Baptism Form',
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
                                  text: 'Service ',
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
                          
                          // Changed from "Recipient's Information" to "Child's Information"
                          const Text(
                            'Child\'s Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Full Name
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Full Name ',
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
                            controller: _nameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Answer this field",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter child\'s name';
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
                          
                          // Date of Birth and Gender
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Date of Birth ',
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
                                          controller: _dobController,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFF5F5F5),
                                            hintText: "MM/DD/YYYY",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            suffixIcon: Icon(Icons.calendar_today),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select date of birth';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Gender ',
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
                                        value: selectedGender,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          border: InputBorder.none,
                                        ),
                                        icon: const Icon(Icons.arrow_drop_down),
                                        style: const TextStyle(color: Colors.black, fontSize: 14),
                                        dropdownColor: Colors.white,
                                        items: ['Male', 'Female']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedGender = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Type of Ceremony - Updated with new options
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Type of Service ',
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
                              value: selectedCeremony,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                              dropdownColor: Colors.white,
                              items: [
                                'Newborn',
                                'Child', 
                                'Adult'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCeremony = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Father's Information (new section)
                          const Text(
                            'Father\'s Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Father's Name
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Father\'s Full Name ',
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
                            controller: _fatherNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Answer this field",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter father\'s name';
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
                          const SizedBox(height: 20),
                          
                          // Mother's Information (new section)
                          const Text(
                            'Mother\'s Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Mother's Name
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Mother\'s Full Name ',
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
                            controller: _motherNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Answer this field",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mother\'s name';
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
                          const SizedBox(height: 20),
                          
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Reason/Purpose of Service
                          const Text(
                            'Reason/Purpose of Service',
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
                              hintText: "Answer this field",
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
                                        'recipientName': _nameController.text,
                                        'dateOfBirth': _dobController.text,
                                        'recipientGender': selectedGender,
                                        'serviceType': selectedCeremony,
                                        'fatherName': _fatherNameController.text,
                                        'motherName': _motherNameController.text,
                                        'reasonForService': _reasonController.text,
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

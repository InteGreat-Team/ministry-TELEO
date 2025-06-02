import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/step_indicator.dart';
import 'c2s5bsweddingform.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';
  String selectedRelation = 'Spouse';
  
  // Controllers to store user input for summary
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactNumberController = TextEditingController();
  final TextEditingController _secondaryEmergencyContactNameController = TextEditingController();
  final TextEditingController _secondaryEmergencyContactNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactNumberController.dispose();
    _secondaryEmergencyContactNameController.dispose();
    _secondaryEmergencyContactNumberController.dispose();
    super.dispose();
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
                child: Column(
                  children: [
                    // Step indicator inside the white container
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: const StepIndicator(currentStep: 3, totalSteps: 7),
                      ),
                    ),
                    
                    // Main content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Are these your ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'details?',
                                        style: TextStyle(
                                          color: Color(0xFF0A0A4A),
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                          
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
                                      return 'Please enter your name';
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
                                
                                // Age and Gender
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Age',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _ageController,
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
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
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedGender,
                                                isExpanded: true,
                                                items: ['Male', 'Female', 'Other']
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                const Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Contact Number
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Contact Number ',
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
                                  controller: _contactController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "e.g., 09123456789",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.phone, size: 20, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your contact number';
                                    }
                                    // Validate Philippine mobile number format (starts with 09)
                                    if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                                      return 'Please enter a valid mobile number (e.g., 09123456789)';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Email Address
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Email Address ',
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
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "example@email.com",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.email, size: 20, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    // Basic email validation
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                
                              const SizedBox(height: 20),
                                const Text(
                                  'Other Contact Person',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  "In cases where you are currently unavailable for communication",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Primary Contact Person
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Primary Contact Person ',
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
                                  controller: _emergencyContactNameController,
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
                                      return 'Please enter contact person';
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

                                // Primary Contact Person's Number
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Primary Contact Person\'s Number ',
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
                                  controller: _emergencyContactNumberController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "e.g., 09123456789",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.phone, size: 20, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter contact number';
                                    }
                                    // Validate Philippine mobile number format (starts with 09)
                                    if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                                      return 'Please enter a valid mobile number (e.g., 09123456789)';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Relation
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Relation ',
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
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedRelation,
                                      isExpanded: true,
                                      items: ['Spouse', 'Parent', 'Sibling', 'Friend', 'Other']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedRelation = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Secondary Contact Person (Optional)
                                const Text(
                                  'Secondary Contact Person',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextFormField(
                                  controller: _secondaryEmergencyContactNameController,
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                                  ],
                                  textCapitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: 16),

                                // Secondary Contact Person's Number
                                const Text(
                                  'Secondary Contact Person\'s Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextFormField(
                                  controller: _secondaryEmergencyContactNumberController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "(Optional)",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.phone, size: 20, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
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
                                            // Pass user data to the next screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ServiceInformationScreen(
                                                  personalDetails: {
                                                    'name': _nameController.text,
                                                    'age': _ageController.text,
                                                    'gender': selectedGender,
                                                    'contact': _contactController.text,
                                                    'email': _emailController.text,
                                                    'emergencyContactName': _emergencyContactNameController.text,
                                                    'emergencyContactNumber': _emergencyContactNumberController.text,
                                                    'emergencyContactRelation': selectedRelation,
                                                    'secondaryEmergencyContactName': _secondaryEmergencyContactNameController.text,
                                                    'secondaryEmergencyContactNumber': _secondaryEmergencyContactNumberController.text,
                                                  },
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

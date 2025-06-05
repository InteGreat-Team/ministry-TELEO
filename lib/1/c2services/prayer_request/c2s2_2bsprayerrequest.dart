import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c2s4bsprayerrequest.dart';
import '../widgets/step_indicator.dart';

class DivineLinkScreen extends StatefulWidget {
  const DivineLinkScreen({super.key});

  @override
  State<DivineLinkScreen> createState() => _DivineLinkScreenState();
}

class _DivineLinkScreenState extends State<DivineLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedApplication = 'Zoom';
  bool isOtherSelected = false;
  
  // Controllers
  final TextEditingController _otherApplicationController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _preferredDateController = TextEditingController();
  final TextEditingController _preferredTimeController = TextEditingController();

  @override
  void dispose() {
    _otherApplicationController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _preferredDateController.dispose();
    _preferredTimeController.dispose();
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
          'Prayer Request',
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
            const SizedBox(height: 90), // Space for app bar
            
            // White container with content
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
                        child: const StepIndicator(currentStep: 2, totalSteps: 7),
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
                                        text: 'Divine Link ',
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
                                  'Please provide details for your online service',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Application Selection
                                const Text(
                                  'Select Application for Divine Link',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Radio buttons for application selection
                                RadioListTile<String>(
                                  title: const Text('Zoom'),
                                  value: 'Zoom',
                                  groupValue: selectedApplication,
                                  activeColor: const Color(0xFF0A0A4A),
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedApplication = value!;
                                      isOtherSelected = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('Google Meet'),
                                  value: 'Google Meet',
                                  groupValue: selectedApplication,
                                  activeColor: const Color(0xFF0A0A4A),
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedApplication = value!;
                                      isOtherSelected = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('Others'),
                                  value: 'Others',
                                  groupValue: selectedApplication,
                                  activeColor: const Color(0xFF0A0A4A),
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedApplication = value!;
                                      isOtherSelected = true;
                                    });
                                  },
                                ),
                                
                                // Text field for other application
                                if (isOtherSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                                    child: TextFormField(
                                      controller: _otherApplicationController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFF5F5F5),
                                        hintText: "Please specify",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (isOtherSelected && (value == null || value.isEmpty)) {
                                          return 'Please specify the application';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                
                                const SizedBox(height: 24),
                                
                                // User Information
                                const Text(
                                  'User Information',
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
                                  controller: _fullNameController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "Enter your full name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                                  ],
                                  textCapitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: 16),
                                
                                // Age
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Age ',
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
                                  controller: _ageController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "Enter your age",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Email
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Email ',
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
                                    hintText: "Enter your email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Phone
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Phone Number ',
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
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "e.g., 09123456789",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.smartphone, size: 20, color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                                      return 'Please enter a valid phone number (e.g., 09123456789)';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                
                                // Preferred Schedule
                                const Text(
                                  'Preferred Schedule',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Preferred Date
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Preferred Date ',
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
                                  controller: _preferredDateController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "MM/DD/YYYY",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Icon(Icons.calendar_today, size: 20, color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your preferred date';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    final DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
                                              primary: Color(0xFFFFC107),
                                              onPrimary: Colors.white,
                                              onSurface: Colors.black,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _preferredDateController.text = 
                                            "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year}";
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Preferred Time
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Preferred Time ',
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
                                  controller: _preferredTimeController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                    hintText: "HH:MM AM/PM",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Icon(Icons.access_time, size: 20, color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your preferred time';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    final TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
                                              primary: Color(0xFFFFC107),
                                              onPrimary: Colors.white,
                                              onSurface: Colors.black,
                                            ),
                                            timePickerTheme: TimePickerThemeData(
                                              dialBackgroundColor: Colors.grey[200],
                                              hourMinuteColor: WidgetStateColor.resolveWith((states) => 
                                                states.contains(WidgetState.selected) ? const Color(0xFFFFC107) : Colors.grey[200]!
                                              ),
                                              hourMinuteTextColor: WidgetStateColor.resolveWith((states) => 
                                                states.contains(WidgetState.selected) ? Colors.white : Colors.black
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedTime != null) {
                                      final hour = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
                                      final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                                      setState(() {
                                        _preferredTimeController.text = 
                                            "${hour.toString()}:${pickedTime.minute.toString().padLeft(2, '0')} $period";
                                      });
                                    }
                                  },
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
                                            // Prepare divine link details
                                            final divineLinkDetails = {
                                              'application': isOtherSelected 
                                                  ? _otherApplicationController.text 
                                                  : selectedApplication,
                                              'fullName': _fullNameController.text,
                                              'age': _ageController.text,
                                              'email': _emailController.text,
                                              'phone': _phoneController.text,
                                              'preferredDate': _preferredDateController.text,
                                              'preferredTime': _preferredTimeController.text,
                                            };
                                            
                                            // Navigate to personal details screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const PersonalDetailsScreen(),
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

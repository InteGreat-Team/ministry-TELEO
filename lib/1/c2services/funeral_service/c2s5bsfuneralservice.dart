import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/step_indicator.dart';
import 'c2s6bsfuneralservice.dart';

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
  
  // Dropdown selection for relation - now null by default
  String? selectedRelation;
  
  // Checkboxes for service types
  bool funeralSelected = false;
  bool memorialSelected = false;
  bool gravesideSelected = false;
  bool wakeSelected = false;
  bool virtualServiceSelected = false;
  bool otherServiceSelected = false;
  
  // Consent checkbox
  bool consentToGuidelines = false;

  // Controllers to store user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dateOfPassingController = TextEditingController();
  final TextEditingController _causeOfDeathController = TextEditingController();
  final TextEditingController _otherRelationController = TextEditingController();
  final TextEditingController _otherServiceController = TextEditingController();

  // List of relation options for dropdown
  final List<String> relationOptions = [
    'Mother',
    'Father',
    'Sister',
    'Brother',
    'Others',
    'Would rather not say'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _dateOfPassingController.dispose();
    _causeOfDeathController.dispose();
    _otherRelationController.dispose();
    _otherServiceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, {bool allowFuture = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: allowFuture ? DateTime(2100) : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A0A4A),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  bool get isAnyServiceTypeSelected {
    return funeralSelected || 
           memorialSelected || 
           gravesideSelected || 
           wakeSelected || 
           virtualServiceSelected || 
           (otherServiceSelected && _otherServiceController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Funeral Service',
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
                          
                          // Deceased Information
                          const Text(
                            'Deceased Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Full Name of Deceased
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Full Name of Deceased ',
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
                              hintText: "Enter full name",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the deceased\'s name';
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          
                          // Date of Birth
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
                            onTap: () => _selectDate(context, _dobController),
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
                          const SizedBox(height: 16),
                          
                          // Date of Passing
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Date of Passing ',
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
                            onTap: () => _selectDate(context, _dateOfPassingController),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _dateOfPassingController,
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
                                    return 'Please select date of passing';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Cause of Death
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Cause of Death ',
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
                            controller: _causeOfDeathController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              hintText: "Enter cause of death",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter cause of death';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Relation - Changed to Dropdown with hint text
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Relation ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 232, 12, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Dropdown for relation with hint text
                          DropdownButtonFormField<String>(
                            hint: const Text(
                              "Your relation with the deceased person",
                              style: TextStyle(color: Colors.grey),
                            ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            items: relationOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedRelation = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your relation to the deceased';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                          
                          // Text field for other relation
                          if (selectedRelation == 'Others')
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextFormField(
                                controller: _otherRelationController,
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
                                  if (selectedRelation == 'Others' && (value == null || value.isEmpty)) {
                                    return 'Please specify the relation';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          
                          const SizedBox(height: 20),
                          
                          // Type of Service Requested
                          const Text(
                            'Type of Service Requested',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Checkboxes for service types with reduced spacing
                          Wrap(
                            spacing: 0, // Reduced horizontal spacing
                            runSpacing: -8, // Reduced vertical spacing
                            children: [
                              _buildServiceCheckbox('Funeral', funeralSelected, (value) {
                                setState(() {
                                  funeralSelected = value!;
                                });
                              }),
                              _buildServiceCheckbox('Memorial', memorialSelected, (value) {
                                setState(() {
                                  memorialSelected = value!;
                                });
                              }),
                              _buildServiceCheckbox('Graveside', gravesideSelected, (value) {
                                setState(() {
                                  gravesideSelected = value!;
                                });
                              }),
                              _buildServiceCheckbox('Wake', wakeSelected, (value) {
                                setState(() {
                                  wakeSelected = value!;
                                });
                              }),
                              _buildServiceCheckbox('Virtual Service', virtualServiceSelected, (value) {
                                setState(() {
                                  virtualServiceSelected = value!;
                                });
                              }),
                              _buildServiceCheckbox('Others', otherServiceSelected, (value) {
                                setState(() {
                                  otherServiceSelected = value!;
                                });
                              }),
                            ],
                          ),
                          
                          // Text field for other service
                          if (otherServiceSelected)
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0, top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                controller: _otherServiceController,
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
                                  if (otherServiceSelected && (value == null || value.isEmpty)) {
                                    return 'Please specify the service type';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          
                          const SizedBox(height: 20),
                          
                          // Consent to Church Funeral Guidelines
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: consentToGuidelines,
                                onChanged: (value) {
                                  setState(() {
                                    consentToGuidelines = value!;
                                  });
                                },
                                activeColor: const Color(0xFF0A0A4A),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'I consent to the ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Church Funeral Guidelines',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF0A0A4A),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Show guidelines dialog or navigate to guidelines page
                                              _showGuidelinesDialog(context);
                                            },
                                        ),
                                        const TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(255, 232, 12, 12),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          if (!consentToGuidelines)
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0, top: 4.0),
                              child: Text(
                                'You must consent to the guidelines to continue',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 232, 12, 12),
                                  fontSize: 12,
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
                                    if (_formKey.currentState!.validate() && 
                                        isAnyServiceTypeSelected && 
                                        consentToGuidelines) {
                                      
                                      // Prepare service types
                                      List<String> serviceTypes = [];
                                      if (funeralSelected) serviceTypes.add('Funeral');
                                      if (memorialSelected) serviceTypes.add('Memorial');
                                      if (gravesideSelected) serviceTypes.add('Graveside');
                                      if (wakeSelected) serviceTypes.add('Wake');
                                      if (virtualServiceSelected) serviceTypes.add('Virtual Service');
                                      if (otherServiceSelected) serviceTypes.add('Other: ${_otherServiceController.text}');
                                      
                                      // Prepare relation
                                      String relation = selectedRelation!;
                                      if (relation == 'Others') {
                                        relation = 'Other: ${_otherRelationController.text}';
                                      }
                                      
                                      // Combine personal details with service details
                                      final allDetails = {
                                        ...widget.personalDetails,
                                        'deceasedName': _nameController.text,
                                        'dateOfBirth': _dobController.text,
                                        'dateOfPassing': _dateOfPassingController.text,
                                        'causeOfDeath': _causeOfDeathController.text,
                                        'relation': relation,
                                        'serviceTypes': serviceTypes.join(', '),
                                        'consentToGuidelines': consentToGuidelines.toString(),
                                      };
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventManagementScreen(
                                            allDetails: allDetails,
                                          ),
                                        ),
                                      );
                                    } else if (!isAnyServiceTypeSelected) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please select at least one service type'),
                                          backgroundColor: Colors.red,
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
  
  Widget _buildServiceCheckbox(String title, bool value, Function(bool?) onChanged) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // Set width to approximately half the screen
      child: CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0A0A4A),
        contentPadding: EdgeInsets.zero,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
  
  void _showGuidelinesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Church Funeral Guidelines'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Guidelines for Funeral Services:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1. Services must be scheduled at least 48 hours in advance.'),
                Text('2. The church must be notified of any special requirements.'),
                Text('3. All services must adhere to church protocols and traditions.'),
                Text('4. Photography and videography policies must be respected.'),
                Text('5. The family is responsible for coordinating with funeral homes.'),
                SizedBox(height: 16),
                Text(
                  'For more information, please contact the church office.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

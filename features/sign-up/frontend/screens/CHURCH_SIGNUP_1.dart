// View - Church Signup Screen UI
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchSignupVar and ChurchSignupConstants
import '../../backend/viewmodels/CHURCH_SIGNUP_FUNC.dart'; // For ChurchSignupViewModel
import '../widgets/index.dart'; // For all custom widgets

class ChurchSignup1 extends StatefulWidget {
  const ChurchSignup1({super.key});

  @override
  State<ChurchSignup1> createState() => _ChurchSignup1State();
}

class _ChurchSignup1State extends State<ChurchSignup1> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  DateTime? _selectedDate;
  String _selectedMinistry = ChurchSignupConstants.ministryTypes.first;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church Member Signup'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChurchSignupViewModel>(
        builder: (context, viewModel, child) {
          return LoadingOverlay(
            isLoading: viewModel.isLoading,
            message: 'Adding member...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const CustomHeader(
                      title: 'Join Our Church Family',
                      subtitle: 'Fill in your details to become a member',
                      icon: Icons.church,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // First Name
                    CustomTextFormField(
                      controller: _firstNameController,
                      labelText: 'First Name',
                      icon: Icons.person,
                      validator: (value) => FormValidation.validateRequired(value, 'first name'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Last Name
                    CustomTextFormField(
                      controller: _lastNameController,
                      labelText: 'Last Name',
                      icon: Icons.person_outline,
                      validator: (value) => FormValidation.validateRequired(value, 'last name'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => FormValidation.validateEmail(value),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Phone
                    CustomTextFormField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => FormValidation.validatePhone(value),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Address
                    CustomTextFormField(
                      controller: _addressController,
                      labelText: 'Address',
                      icon: Icons.home,
                      maxLines: 2,
                      validator: (value) => FormValidation.validateRequired(value, 'address'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Birth Date
                    CustomDatePicker(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      labelText: 'Select Birth Date',
                      lastDate: DateTime.now(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Ministry Dropdown
                    CustomDropdown<String>(
                      value: _selectedMinistry,
                      items: ChurchSignupConstants.ministryTypes,
                      labelText: 'Preferred Ministry',
                      icon: Icons.church,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMinistry = value;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Error Message
                    if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty)
                      ErrorMessageWidget(
                        message: viewModel.errorMessage!,
                        onDismiss: viewModel.clearError,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Submit Button
                    CustomElevatedButton(
                      onPressed: viewModel.isLoading ? null : _submitForm,
                      isLoading: viewModel.isLoading,
                      text: 'Join Church',
                      icon: Icons.church,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Members List
                    if (viewModel.members.isNotEmpty) ...[
                      Text(
                        'Church Members',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      CustomMembersList(members: viewModel.members),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<ChurchSignupViewModel>(context, listen: false);
      
      final newMember = ChurchSignupVar(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        birthDate: _selectedDate,
        ministry: _selectedMinistry,
      );

      final success = await viewModel.addMember(newMember);
      
      if (success) {
        _clearForm();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome to our church family!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Error message is already handled by the ViewModel and ErrorMessageWidget
      }
    }
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() {
      _selectedDate = null;
      _selectedMinistry = ChurchSignupConstants.ministryTypes.first;
    });
  }
}

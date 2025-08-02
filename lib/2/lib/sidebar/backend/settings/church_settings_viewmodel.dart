// lib/sidebar/backend/settings/church_settings_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart'; // Import AdminView, AdminData, MassScheduleItem

class ChurchSettingsViewModel extends ChangeNotifier {
  final AdminData _adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue}) _onNavigate;

  ChurchSettingsViewModel({
    required AdminData adminData,
    required Function(AdminView, {AuthenticatorFlow? flow, String? newValue}) onNavigate,
  })  : _adminData = adminData,
        _onNavigate = onNavigate {
    // Initialize controllers for account settings
    churchNameController = TextEditingController(text: _adminData.churchName);
    locationController = TextEditingController(text: _adminData.location);
    descriptionController = TextEditingController(text: _adminData.description);
    scheduleController = TextEditingController(text: _adminData.schedule);
    gcashController = TextEditingController(text: _adminData.gcash);
    mayaController = TextEditingController(text: _adminData.maya);
    bdoController = TextEditingController(text: _adminData.bdo);
    bpiController = TextEditingController(text: _adminData.bpi);

    // Initialize controllers for change email
    currentEmail = _adminData.currentEmail;
    newEmailController = TextEditingController();

    // Initialize controllers for change password
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // Initialize controllers for change phone
    currentPhoneNumber = _adminData.currentPhoneNumber;
    newPhoneController = TextEditingController();
  }

  // --- General Settings & Navigation ---
  void goBack() {
    _onNavigate(AdminView.settings);
  }

  // --- Account Settings Logic ---
  late TextEditingController churchNameController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController scheduleController;
  late TextEditingController gcashController;
  late TextEditingController mayaController;
  late TextEditingController bdoController;
  late TextEditingController bpiController;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void saveChanges(Function(AdminData) onUpdateAdminData) {
    if (_isEditing) {
      // Save logic here
      final updatedAdminData = _adminData.copyWith(
        churchName: churchNameController.text,
        location: locationController.text,
        description: descriptionController.text,
        schedule: scheduleController.text,
        gcash: gcashController.text,
        maya: mayaController.text,
        bdo: bdoController.text,
        bpi: bpiController.text,
      );
      onUpdateAdminData(updatedAdminData);
    }
    toggleEditing();
  }

  // --- Change Email Logic ---
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  late String currentEmail;
  late TextEditingController newEmailController;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (value == currentEmail) {
      return 'New email cannot be the same as old email';
    }
    return null;
  }

  void submitChangeEmail() {
    if (emailFormKey.currentState?.validate() ?? false) {
      _onNavigate(AdminView.authenticator, flow: AuthenticatorFlow.email, newValue: newEmailController.text);
    }
  }

  // --- Change Password Logic ---
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    }
    if (value != _adminData.password) {
      return 'Incorrect old password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (value == oldPasswordController.text) {
      return 'New password cannot be the same as old password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void submitChangePassword() {
    if (passwordFormKey.currentState?.validate() ?? false) {
      // In a real app, you'd send this to a backend for verification and update
      _onNavigate(AdminView.authenticator, flow: AuthenticatorFlow.password, newValue: newPasswordController.text);
    }
  }

  // --- Change Phone Logic ---
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  late String currentPhoneNumber;
  late TextEditingController newPhoneController;

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new phone number';
    }
    if (!RegExp(r'^\+?[0-9]{10,14}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    if (value == currentPhoneNumber) {
      return 'New phone number cannot be the same as old phone number';
    }
    return null;
  }

  void submitChangePhone() {
    if (phoneFormKey.currentState?.validate() ?? false) {
      _onNavigate(AdminView.authenticator, flow: AuthenticatorFlow.phone, newValue: newPhoneController.text);
    }
  }

  // --- Notification Settings Logic ---
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;

  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;

  void togglePushNotifications(bool value) {
    _pushNotificationsEnabled = value;
    // TODO: Add logic to persist this setting (e.g., API call, local storage)
    notifyListeners();
  }

  void toggleEmailNotifications(bool value) {
    _emailNotificationsEnabled = value;
    // TODO: Add logic to persist this setting (e.g., API call, local storage)
    notifyListeners();
  }

  // --- Mass Schedule Logic ---
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 11, minute: 0);
  final List<MassScheduleItem> _scheduleItems = [];

  DateTime get selectedDate => _selectedDate;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  List<MassScheduleItem> get scheduleItems => List.unmodifiable(_scheduleItems);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectTimeRange(BuildContext context) async {
    final TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedStart != null) {
      _startTime = pickedStart;
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: _endTime,
      );
      if (pickedEnd != null) {
        _endTime = pickedEnd;
      }
      notifyListeners();
    }
  }

  void addScheduleItem(BuildContext context) {
    final newItem = MassScheduleItem(
      date: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
    );

    bool isDuplicate = _scheduleItems.contains(newItem);

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This date and time slot is already scheduled.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    _scheduleItems.add(newItem);
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void removeScheduleItem(int index) {
    if (index >= 0 && index < _scheduleItems.length) {
      _scheduleItems.removeAt(index);
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    final List<String> weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1: suffix = 'st'; break;
        case 2: suffix = 'nd'; break;
        case 3: suffix = 'rd'; break;
        default: suffix = 'th'; break;
      }
    }
    return '$weekday, $day$suffix $month';
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // --- Terms and Conditions Logic ---
  // No specific state or methods needed here, as it's mostly static content.
  // The goBack() method is already handled by the general settings navigation.

  @override
  void dispose() {
    churchNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    scheduleController.dispose();
    gcashController.dispose();
    mayaController.dispose();
    bdoController.dispose();
    bpiController.dispose();
    newEmailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPhoneController.dispose();
    super.dispose();
  }
}

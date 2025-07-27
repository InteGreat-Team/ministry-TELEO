import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart';
import '../../backend/viewmodels/CHURCH_SIGNUP_FUNC.dart';
import '../widgets/index.dart';
import 'package:provider/provider.dart';

class ApprovalStatusScreen extends StatefulWidget {
  const ApprovalStatusScreen({super.key});

  @override
  State<ApprovalStatusScreen> createState() => _ApprovalStatusScreenState();
}

class _ApprovalStatusScreenState extends State<ApprovalStatusScreen> {
  final _referenceCodeController = TextEditingController();
  late final ChurchSignupViewModel _viewModel;
  bool _isChecking = false;
  ApprovalStatus? _approvalStatus;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ChurchSignupViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _referenceCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final referenceCode = _referenceCodeController.text.trim();
    
    // Validate input
    if (referenceCode.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a reference code';
      });
      return;
    }
    
    // Format validation
    if (!RegExp(r'^[A-Z0-9]{6,12}$').hasMatch(referenceCode)) {
      setState(() {
        _errorMessage = 'Invalid reference code format';
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
      _approvalStatus = null;
    });

    try {
      final status = await _viewModel.checkApprovalStatus(referenceCode);
      
      if (mounted) {
        setState(() {
          _isChecking = false;
          _approvalStatus = status;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChecking = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Check Approval Status'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      const SizedBox(height: 32),
                      
                      // Reference Code Input Section
                      _buildReferenceCodeInput(),
                      const SizedBox(height: 24),
                      
                      // Check Status Button
                      _buildCheckStatusButton(),
                      const SizedBox(height: 32),
                      
                      // Status Display
                      _buildStatusDisplay(),
                      
                      const SizedBox(height: 32),
                      
                      // Help Section
                      _buildHelpSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Track Your Application',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter your reference code to check the status of your church application.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
  
  Widget _buildReferenceCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reference Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _referenceCodeController,
          decoration: InputDecoration(
            hintText: 'e.g., CH12345678',
            prefixIcon: const Icon(Icons.confirmation_number),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF002642), width: 2),
            ),
            suffixIcon: IconButton(
              icon: _isChecking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              onPressed: _isChecking ? null : _checkStatus,
            ),
            errorText: _errorMessage,
            errorMaxLines: 2,
          ),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            UpperCaseTextFormatter(),
            LengthLimitingTextInputFormatter(12),
          ],
          onSubmitted: (_) => _checkStatus(),
          enabled: !_isChecking,
        ),
      ],
    );
  }
  
  Widget _buildCheckStatusButton() {
    return CustomElevatedButton(
      onPressed: _isChecking ? null : _checkStatus,
      text: 'Check Status',
      isLoading: _isChecking,
      backgroundColor: const Color(0xFF002642),
      foregroundColor: Colors.white,
      height: 56,
      width: double.infinity,
    );
  }
  
  Widget _buildStatusDisplay() {
    if (_errorMessage != null && _approvalStatus == null) {
      return ErrorMessageWidget(
        message: _errorMessage!,
        onDismiss: () => setState(() => _errorMessage = null),
      );
    } else if (_approvalStatus != null) {
      return AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: ApprovalStatusWidget(status: _approvalStatus!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  
  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'If you can\'t find your reference code or need assistance, please contact our support team.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to support or show contact info
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support contact: support@church.org'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue.shade600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Contact Support',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

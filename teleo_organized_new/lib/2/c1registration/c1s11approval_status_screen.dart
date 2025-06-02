import 'package:flutter/material.dart';

class ApprovalStatusScreen extends StatefulWidget {
  const ApprovalStatusScreen({super.key});

  @override
  State<ApprovalStatusScreen> createState() => _ApprovalStatusScreenState();
}

class _ApprovalStatusScreenState extends State<ApprovalStatusScreen> {
  final _referenceCodeController = TextEditingController();
  bool _isChecking = false;
  String? _statusMessage;
  bool? _isApproved;

  @override
  void dispose() {
    _referenceCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isChecking = true;
      _statusMessage = null;
      _isApproved = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, approve if code starts with 'CH'
    final code = _referenceCodeController.text.trim();
    final isApproved = code.startsWith('CH');

    setState(() {
      _isChecking = false;
      _isApproved = isApproved;
      _statusMessage = isApproved
          ? 'Your church has been approved!'
          : 'Your church is still pending approval. Please check back later.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Check Approval Status'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your reference code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _referenceCodeController,
              decoration: InputDecoration(
                hintText: 'e.g., CH12345678',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _referenceCodeController.text.isNotEmpty
                      ? _checkStatus
                      : null,
                ),
              ),
              onSubmitted: (_) {
                if (_referenceCodeController.text.isNotEmpty) {
                  _checkStatus();
                }
              },
            ),
            const SizedBox(height: 24),
            if (_isChecking)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isApproved == true
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isApproved == true
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isApproved == true
                          ? Icons.check_circle
                          : Icons.access_time,
                      color: _isApproved == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: _isApproved == true
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
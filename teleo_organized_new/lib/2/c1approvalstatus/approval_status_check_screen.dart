import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'approval_status_result_screen.dart';

class ApprovalStatusCheckScreen extends StatefulWidget {
  const ApprovalStatusCheckScreen({super.key});

  @override
  State<ApprovalStatusCheckScreen> createState() => _ApprovalStatusCheckScreenState();
}

class _ApprovalStatusCheckScreenState extends State<ApprovalStatusCheckScreen> {
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _checkStatus() {
    // In a real app, this would make an API call to check the status
    // For demo purposes, we'll randomly choose a status
    final statuses = ['under_review', 'approved', 'disapproved'];
    final randomStatus = statuses[DateTime.now().millisecond % 3];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalStatusResultScreen(status: randomStatus),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF002642),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Approval Status',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Enter Email Address',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Provide your email to view your approval status.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              
              // Email field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'name@example.com',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                ),
              ),
              const Spacer(),
              
              // Confirm button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _checkStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
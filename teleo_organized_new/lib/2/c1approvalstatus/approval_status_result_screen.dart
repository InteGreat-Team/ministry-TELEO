import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ApprovalStatusResultScreen extends StatelessWidget {
  final String status; // 'under_review', 'approved', or 'disapproved'
  
  const ApprovalStatusResultScreen({
    super.key,
    required this.status,
  });

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Status icon and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStatusIcon(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _getStatusTitle(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Status message
                Text(
                  _getStatusMessage(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                
                // Only show submitted documents for disapproved status
                if (status == 'disapproved') ...[
                  const SizedBox(height: 40),
                  const Text(
                    'Submitted Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Invalid information.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentItem('document-name.PDF'),
                  const SizedBox(height: 8),
                  _buildDocumentItem('image-name-goes-here.png'),
                  const SizedBox(height: 8),
                  _buildDocumentItem('document-name.PDF'),
                  const SizedBox(height: 8),
                  _buildDocumentItem('image-name-goes-here.png'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusIcon() {
    Color iconColor;
    IconData iconData;
    
    switch (status) {
      case 'under_review':
        iconColor = Colors.orange;
        iconData = Icons.warning_rounded;
        break;
      case 'approved':
        iconColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case 'disapproved':
        iconColor = Colors.red;
        iconData = Icons.error;
        break;
      default:
        iconColor = Colors.grey;
        iconData = Icons.help;
    }
    
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: iconColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 32,
      ),
    );
  }
  
  String _getStatusTitle() {
    switch (status) {
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Account Approved';
      case 'disapproved':
        return 'Account Disapproved';
      default:
        return 'Status Unknown';
    }
  }
  
  String _getStatusMessage() {
    switch (status) {
      case 'under_review':
        return 'Our team is reviewing your documents. Once your application has been approved, you may be able to proceed with setting up your profile.';
      case 'approved':
        return 'Our team has thoroughly reviewed the validity of your documents and have approved your application! You may now set up your church profile. Thank you for joining us!';
      case 'disapproved':
        return 'We regret to inform you that after thorough review of your documents, your application as a church has not been approved by our team.\n\nPlease reapply if you wish to appeal your application.';
      default:
        return 'We could not determine the status of your application. Please try again later or contact support.';
    }
  }
  
  Widget _buildDocumentItem(String documentName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        documentName,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
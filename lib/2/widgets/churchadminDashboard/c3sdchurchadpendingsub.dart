import 'package:flutter/material.dart';
import 'package:church_app/models/c3cichurchadpendingsub.dart';
import 'package:church_app/theme/c3atchurchadpendingsub.dart';

class SubmissionDetailView extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onClose;

  const SubmissionDetailView({
    Key? key,
    required this.item,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onClose,
        ),
        title: const Text(
          'Submission Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and submission info
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Submitted by ${item.subtitle} on ${item.dateSubmitted}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Description section
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Description ${item.description ?? 'No description provided.'}',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Status section
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusBadge(item.status),
              const SizedBox(height: 24),

              // Content Type section
              const Text(
                'Content Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildTypeBadge(item.type),
              const SizedBox(height: 24),

              // Attachments section
              const Text(
                'Attachments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Video attachment
              _buildAttachmentCard(
                'Video Title Here',
                'video',
                onTap: () {},
              ),
              const SizedBox(height: 16),

              // PDF attachment
              _buildAttachmentCard(
                'prayer_slides.pdf',
                'pdf',
                onTap: () {},
              ),
              const SizedBox(height: 16),

              // Image attachment
              _buildAttachmentCard(
                'prayer_slides.png',
                'image',
                onTap: () {},
              ),
              const SizedBox(height: 32),

              // Close button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: onClose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status?.toLowerCase()) {
      case 'approved':
        backgroundColor = const Color(0xFF90dab5).withOpacity(0.3);
        textColor = const Color(0xFF08a657);
        statusText = 'Approved';
        break;
      case 'rejected':
        backgroundColor = const Color(0xFFffbab2).withOpacity(0.3);
        textColor = const Color(0xFF7c0c00);
        statusText = 'Rejected';
        break;
      case 'pending':
        backgroundColor = const Color(0xFFeedf89).withOpacity(0.3);
        textColor = const Color(0xFF968000);
        statusText = 'Pending';
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String? type) {
    String displayType;

    switch (type?.toLowerCase()) {
      case 'course':
        displayType = 'Course';
        break;
      case 'lesson':
        displayType = 'Lesson';
        break;
      case 'announcement':
        displayType = 'Announcement';
        break;
      default:
        displayType = type?.capitalize() ?? 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF60a3d9).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayType,
        style: const TextStyle(
          color: Color(0xFF3C9CE3),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(String title, String type,
      {required VoidCallback onTap}) {
    Widget previewWidget;

    switch (type) {
      case 'video':
        previewWidget = Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey[400],
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 48,
              color: Colors.white,
            ),
          ),
        );
        break;
      case 'pdf':
        previewWidget = Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black54,
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: Colors.black,
                      child: const Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      ' / 2',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove, color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                    const Text(
                      '100%',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const Spacer(),
                    const Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porttitor congue orci. Duis euismod...',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case 'image':
      default:
        previewWidget = Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey[400],
          child: const Center(
            child: Icon(
              Icons.image,
              size: 48,
              color: Colors.white,
            ),
          ),
        );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
              child: previewWidget,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

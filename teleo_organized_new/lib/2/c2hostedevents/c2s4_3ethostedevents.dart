import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c2s4_2ethostedevents.dart';
import 'c2s4_4ethostedevents.dart'; // Import the volunteer form setup

class EnhancedVolunteersTab extends StatefulWidget {
  final Map<String, dynamic> eventData;
  
  const EnhancedVolunteersTab({
    super.key,
    required this.eventData,
  });

  @override
  State<EnhancedVolunteersTab> createState() => _EnhancedVolunteersTabState();
}

class _EnhancedVolunteersTabState extends State<EnhancedVolunteersTab> {
  bool _needsVolunteers = false;
  String _volunteerFormLink = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with event data if available
    if (widget.eventData.containsKey('needsVolunteers')) {
      _needsVolunteers = widget.eventData['needsVolunteers'];
    }
    if (widget.eventData.containsKey('volunteerFormLink')) {
      _volunteerFormLink = widget.eventData['volunteerFormLink'];
    }
  }

  void _toggleNeedsVolunteers(bool value) {
    setState(() {
      _needsVolunteers = value;
      // Update event data
      widget.eventData['needsVolunteers'] = value;
    });
  }

  void _setupVolunteerForm() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VolunteerFormSetupScreen(
            eventData: widget.eventData,
          ),
        ),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          _volunteerFormLink = result['volunteerFormLink'] ?? '';
          widget.eventData['volunteerFormLink'] = _volunteerFormLink;
          widget.eventData['volunteerFormConfig'] = result['volunteerFormConfig'];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Volunteer form setup completed')),
        );
      }
    } catch (e) {
      print("Error navigating to volunteer form setup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error setting up volunteer form')),
      );
    }
  }

  void _shareVolunteerForm() async {
    if (_volunteerFormLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set up the volunteer form first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate sharing functionality
      await Future.delayed(const Duration(seconds: 1));
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: _volunteerFormLink));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Volunteer form link copied to clipboard')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share volunteer form link')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _needsVolunteers && _volunteerFormLink.isNotEmpty
        ? VolunteersTab(eventData: widget.eventData) // Pass eventData to VolunteersTab
        : _buildInitialSetupView();
  }

  Widget _buildInitialSetupView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle for "This event needs volunteers"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'This event needs volunteers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _needsVolunteers,
                  onChanged: _toggleNeedsVolunteers,
                  activeColor: const Color(0xFF0A0E3D),
                ),
              ],
            ),
          ),
          
          if (_needsVolunteers) ...[
            const SizedBox(height: 24),
            
            // Set Up Volunteer Form button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _setupVolunteerForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Set Up Volunteer Form',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.share, size: 20),
                      onPressed: _shareVolunteerForm,
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_volunteerFormLink.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Volunteer Form Link:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _volunteerFormLink,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: _volunteerFormLink));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard')),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            
            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

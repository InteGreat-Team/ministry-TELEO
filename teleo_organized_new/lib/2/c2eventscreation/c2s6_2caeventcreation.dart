import 'package:flutter/material.dart';
import 'widgets/event_app_bar.dart';

class ConsentFormScreen extends StatefulWidget {
  final String title;
  final String content;
  final Function(bool) onAccept;

  const ConsentFormScreen({
    super.key,
    required this.title,
    required this.content,
    required this.onAccept,
  });

  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  bool _hasScrolledToBottom = false;
  bool _hasAccepted = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    
    // Use a post-frame callback to check if content is scrollable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent > 0) {
        setState(() {
          _isScrollable = true;
        });
      } else {
        // If content is not scrollable, mark as already scrolled to bottom
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hasScrolledToBottom = true;
      });
    }
  }

  void _toggleAccept(bool? value) {
    if (_hasScrolledToBottom) {
      setState(() {
        _hasAccepted = value ?? false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please read the entire document before accepting'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handleComplete() {
    widget.onAccept(_hasAccepted);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context),
        title: widget.title,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consent Form and Waiver',
                    style: TextStyle(
                      color: Color(0xFF0A0A4A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please read the following terms and conditions carefully',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.content,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            // Add some space at the bottom to ensure scrolling triggers the bottom detection
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isScrollable && !_hasScrolledToBottom)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Please scroll to the bottom to read the entire document',
                        style: TextStyle(
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Checkbox(
                        value: _hasAccepted,
                        onChanged: _toggleAccept,
                        activeColor: const Color(0xFF0A0A4A),
                      ),
                      const Expanded(
                        child: Text(
                          'I have read and agree to the terms and conditions',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0A0A4A),
                      side: const BorderSide(color: Color(0xFF0A0A4A)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasAccepted ? _handleComplete : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A4A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Accept & Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'widgets/event_app_bar.dart';
import 'models/event.dart';
import 'c2s7caeventcreation.dart'; // EventInviteScreen

class ConsentFormScreen extends StatefulWidget {
  final String title;
  final String content;
  final Function(bool) onAccept;
  final Event event;

  const ConsentFormScreen({
    super.key,
    required this.title,
    required this.content,
    required this.onAccept,
    required this.event,
  });

  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  bool _hasScrolledToBottom = false;
  bool _hasAccepted = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;

  RegistrationFormConfig get _cfg {
  return widget.event.registrationFormConfig ??= RegistrationFormConfig(
    fieldVisibility: {},
    consentRequired: true,
    hasReadTerms: false,
    hasAcceptedTerms: false,
  );
}

  @override
void initState() {
  super.initState();
  _scrollController.addListener(_scrollListener);
    // Hydrate from existing config so back-navigation preserves state
  _hasAccepted = _cfg.hasAcceptedTerms;                 // <-- add
  _hasScrolledToBottom = _cfg.hasReadTerms;             // <-- add

  // If consent isn’t required, auto-pass
  if (_cfg.consentRequired == false) {
    _hasScrolledToBottom = true;
    _cfg.hasReadTerms = true;
    _hasAccepted = true;
    _cfg.hasAcceptedTerms = true;
  }

  // Post-frame: detect if content is scrollable
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (max > 0) {
      setState(() => _isScrollable = true);
    } else {
      setState(() {
        _isScrollable = false;
        _hasScrolledToBottom = true;
        _cfg.hasReadTerms = true;
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
  if (!_scrollController.hasClients) return;
  final max = _scrollController.position.maxScrollExtent;
  final off = _scrollController.offset;
  if (off >= (max - 40.0) && !_scrollController.position.outOfRange) {
    if (!_hasScrolledToBottom) {
      setState(() {
        _hasScrolledToBottom = true;
        _cfg.hasReadTerms = true; // persist on Event
      });
    }
  }
}


  void _toggleAccept(bool? value) {
  if (_cfg.consentRequired == false || _hasScrolledToBottom) {
    setState(() {
      _hasAccepted = value ?? false;
      _cfg.hasAcceptedTerms = _hasAccepted; // persist on Event
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
  if (_cfg.consentRequired && !_cfg.hasAcceptedTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must accept the terms to continue.')),
    );
    return;
  }

  // Inform parent callback
  widget.onAccept(_hasAccepted);

  // PUSH the next screen and pass the SAME event instance
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EventInviteScreen(event: widget.event),
    ),
  );
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

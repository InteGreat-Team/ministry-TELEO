import 'dart:async';
import 'package:flutter/material.dart';

class DebouncedSearchField extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String) onSubmitted; // NEW: Called when user submits search
  final VoidCallback? onCurrentLocationPressed;
  final TextEditingController controller;
  final Duration delay;
  final String hintText;
  final bool enabled;

  const DebouncedSearchField({
    super.key,
    required this.onChanged,
    required this.onSubmitted, // NEW: Required callback for search submission
    required this.controller,
    this.onCurrentLocationPressed,
    this.delay = const Duration(milliseconds: 500),
    this.hintText = "Search your address",
    this.enabled = true,
  });

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  Timer? _debounceTimer;

  void _onSubmitted(String value) {
    _debounceTimer?.cancel();
    widget.onSubmitted(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      textInputAction: TextInputAction.search,
      onSubmitted: _onSubmitted, // Trigger search on Enter/Search button
      onChanged: (value) {
        // Optional: Still call onChanged for any real-time UI updates
        // but remove the debounced search functionality
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _onSubmitted(widget.controller.text),
              tooltip: 'Search',
            ),
            // Current location button
            if (widget.onCurrentLocationPressed != null)
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: widget.onCurrentLocationPressed,
                tooltip: 'Current Location',
              ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
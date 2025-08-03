import 'dart:async';
import 'package:flutter/material.dart';

class GeoDebouncedSearchField extends StatefulWidget { // FIXED: Renamed to match import
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback? onCurrentLocationPressed;
  final TextEditingController controller;
  final Duration delay;
  final String hintText;
  final bool enabled;

  const GeoDebouncedSearchField({ // FIXED: Constructor name matches class
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.controller,
    this.onCurrentLocationPressed,
    this.delay = const Duration(milliseconds: 500),
    this.hintText = "Search your address",
    this.enabled = true,
  });

  @override
  State<GeoDebouncedSearchField> createState() => _GeoDebouncedSearchFieldState(); // FIXED: State class name
}

class _GeoDebouncedSearchFieldState extends State<GeoDebouncedSearchField> { // FIXED: State class name
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
      onSubmitted: _onSubmitted,
      onChanged: (value) {
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
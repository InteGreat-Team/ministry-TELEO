import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prayer_post.dart';
import '../widgets/prayer_request.dart';

class PrayerRequestScreen extends StatefulWidget {
  final Function(PrayerPost) onPrayerAdded;
  const PrayerRequestScreen({Key? key, required this.onPrayerAdded})
    : super(key: key);

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final _subjectController = TextEditingController();
  final _requestController = TextEditingController();
  Color _selectedColor = const Color(0xFF1A2A4A); // Default dark blue
  List<String> _selectedHashtags = []; // Store tag names
  bool _isHashtagDropdownOpen = false;
  bool _isLoading = false;
  bool _isTagsLoading = true;
  String? _errorMessage;
  List<String> _availableTags = []; // Store tag names

  // Post type selection
  String _selectedPostType = 'public'; // Default to public

  // Church and Pastor selection
  bool _isChurchDropdownOpen = false;
  bool _isPastorDropdownOpen = false;
  String? _selectedChurch; // Single church selection
  List<String> _selectedPastors = []; // Multiple pastor selection

  final List<Color> _themeColors = [
    const Color(0xFF1A2A4A), // Dark blue
    const Color(0xFF00A19A), // Teal
    const Color(0xFF8A2BE2), // Purple
    const Color(0xFFD81B60), // Pink
    const Color(0xFFE67E22), // Orange
    const Color(0xFF009688), // Green
  ];

  // Sample data - replace with API calls
  final List<Map<String, String>> _availableChurches = [
    {'id': '1', 'name': 'Grace Community Church'},
    {'id': '2', 'name': 'Hope Fellowship'},
    {'id': '3', 'name': 'Faith Chapel'},
  ];

  final List<Map<String, String>> _availablePastors = [
    {'id': '1', 'name': 'Pastor John'},
    {'id': '2', 'name': 'Pastor Sarah'},
    {'id': '3', 'name': 'Pastor Michael'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  Future<void> _fetchTags() async {
    setState(() {
      _isTagsLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/api/tags'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> tags = [];

        if (data is List) {
          tags =
              data
                  .whereType<Map>()
                  .map((tag) => tag['name'].toString().trim())
                  .toList();
        } else {
          throw Exception('Unexpected response format: $data');
        }

        tags = tags.toSet().toList()..sort();

        setState(() {
          _availableTags = tags;
          _isTagsLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load tags: ${response.statusCode} - ${response.body}';
          _isTagsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading tags: ${e.toString()}';
        _isTagsLoading = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _subjectController.clear();
      _requestController.clear();
      _selectedColor = _themeColors[0];
      _selectedHashtags = [];
      _selectedPostType = 'public';
      _selectedChurch = null; // Clear single church selection
      _selectedPastors = []; // Clear multiple pastor selection
      _errorMessage = null;
    });
  }

  Future<void> _submitPrayer() async {
    if (_subjectController.text.isEmpty || _requestController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedHashtags.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one tag';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one tag'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate church community selection
    if (_selectedPostType == 'church_community' &&
        (_selectedChurch == null || _selectedPastors.isEmpty)) {
      setState(() {
        _errorMessage = 'Please select a church and at least one pastor';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a church and at least one pastor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prayerContent = _subjectController.text.trim();
      final prayerDetails = _requestController.text.trim();

      final prayerData = {
        'content': prayerContent,
        'details': prayerDetails,
        'tags': _selectedHashtags,
        'postType': _selectedPostType,
        if (_selectedPostType == 'church_community') ...{
          'church': _selectedChurch, // Single church
          'pastors': _selectedPastors, // Multiple pastors
        },
        'themeColor':
            '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      };

      final response = await http
          .post(
            Uri.parse('http://localhost:3000/api/prayers'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(prayerData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newPrayer = PrayerPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userName: 'You',
          userAvatar: 'assets/images/avatar.png',
          timeAgo: 'Just now',
          content: _subjectController.text,
          details: _requestController.text,
          likes: 0,
          prayers: 0,
          comments: 0,
          hasLiked: false,
          hasPrayed: false,
          cardColor: _selectedColor,
        );

        widget.onPrayerAdded(newPrayer);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prayer posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage =
              'Failed to post prayer: ${response.statusCode} - ${response.body}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post prayer: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error posting prayer: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting prayer: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getHashtagsDisplayText() {
    if (_selectedHashtags.isEmpty) {
      return 'Select tags';
    } else if (_selectedHashtags.length == 1) {
      return _selectedHashtags[0];
    } else {
      return '${_selectedHashtags.length} tags selected';
    }
  }

  String _getChurchDisplayText() {
    return _selectedChurch ?? 'Select church';
  }

  String _getPastorsDisplayText() {
    if (_selectedPastors.isEmpty) {
      return 'Select pastors';
    } else if (_selectedPastors.length == 1) {
      return _selectedPastors[0];
    } else {
      return '${_selectedPastors.length} pastors selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrayerRequestWidgets.buildScaffold(
      context: context,
      subjectController: _subjectController,
      requestController: _requestController,
      selectedColor: _selectedColor,
      themeColors: _themeColors,
      selectedHashtags: _selectedHashtags,
      isHashtagDropdownOpen: _isHashtagDropdownOpen,
      isTagsLoading: _isTagsLoading,
      errorMessage: _errorMessage,
      availableTags: _availableTags,
      selectedPostType: _selectedPostType,
      isChurchDropdownOpen: _isChurchDropdownOpen,
      isPastorDropdownOpen: _isPastorDropdownOpen,
      availableChurches: _availableChurches,
      availablePastors: _availablePastors,
      selectedChurch: _selectedChurch,
      selectedPastors: _selectedPastors,
      isLoading: _isLoading,
      // Callbacks
      onColorSelected: (color) => setState(() => _selectedColor = color),
      onHashtagToggle:
          () =>
              setState(() => _isHashtagDropdownOpen = !_isHashtagDropdownOpen),
      onTagSelected: (tag) {
        setState(() {
          if (_selectedHashtags.contains(tag)) {
            _selectedHashtags.remove(tag);
          } else {
            _selectedHashtags.add(tag);
          }
        });
      },
      onPostTypeChanged: (value) {
        setState(() {
          _selectedPostType = value;
          if (value != 'church_community') {
            _selectedChurch = null;
            _selectedPastors = [];
          }
        });
      },
      onChurchDropdownToggle:
          () => setState(() => _isChurchDropdownOpen = !_isChurchDropdownOpen),
      onPastorDropdownToggle:
          () => setState(() => _isPastorDropdownOpen = !_isPastorDropdownOpen),
      onChurchSelected: (church) {
        setState(() {
          _selectedChurch = church;
          _isChurchDropdownOpen = false;
        });
      },
      onPastorToggle: (pastor) {
        setState(() {
          if (_selectedPastors.contains(pastor)) {
            _selectedPastors.remove(pastor);
          } else {
            _selectedPastors.add(pastor);
          }
        });
      },
      onClearForm: _clearForm,
      onSubmitPrayer: _submitPrayer,
      onRefreshTags: _fetchTags,
      getHashtagsDisplayText: _getHashtagsDisplayText,
      getChurchDisplayText: _getChurchDisplayText,
      getPastorsDisplayText: _getPastorsDisplayText,
    );
  }
}

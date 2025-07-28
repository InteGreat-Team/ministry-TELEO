import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_post.dart';
import '../providers/prayer_request_provider.dart';
import '../widgets/prayer_request/prayer_request.dart';

class PrayerRequestScreen extends StatelessWidget {
  final Function(PrayerPost) onPrayerAdded;

  const PrayerRequestScreen({super.key, required this.onPrayerAdded});

  // Extract theme colors as a static constant
  static const List<Color> _themeColors = [
    Color(0xFF1A2A4A),
    Color(0xFF00A19A),
    Color(0xFF8A2BE2),
    Color(0xFFD81B60),
    Color(0xFFE67E22),
    Color(0xFF009688),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerRequestProvider()..fetchTags(),
      child: Consumer<PrayerRequestProvider>(
        builder:
            (context, provider, _) => PrayerRequestWidgets.buildScaffold(
              context: context,
              subjectController: provider.subjectController,
              requestController: provider.requestController,
              selectedColor: provider.selectedColor,
              themeColors: _themeColors,
              selectedHashtags: provider.selectedHashtags,
              isHashtagDropdownOpen: provider.isHashtagDropdownOpen,
              isTagsLoading: provider.isTagsLoading,
              errorMessage: provider.errorMessage,
              availableTags: provider.availableTags,
              selectedPostType: provider.selectedPostType,
              // Fix: Use provider state instead of hardcoded false
              isChurchDropdownOpen: provider.isChurchDropdownOpen,
              isPastorDropdownOpen: provider.isPastorDropdownOpen,
              availableChurches: provider.availableChurches,
              availablePastors: provider.availablePastors,
              selectedChurch: provider.selectedChurch,
              selectedPastors: provider.selectedPastors,
              isLoading: provider.isLoading,
              onColorSelected: provider.setSelectedColor,
              onHashtagToggle: provider.toggleHashtagDropdown,
              onTagSelected: provider.toggleTag,
              onPostTypeChanged: provider.setPostType,
              onChurchDropdownToggle: provider.toggleChurchDropdown,
              onPastorDropdownToggle: provider.togglePastorDropdown,
              onChurchSelected: provider.setSelectedChurch,
              onPastorToggle: provider.togglePastor,
              onClearForm: provider.clearForm,
              onSubmitPrayer: () => _handleSubmitPrayer(context, provider),
              onRefreshTags: provider.fetchTags,
              getHashtagsDisplayText: () => _getHashtagsDisplayText(provider),
              getChurchDisplayText: () => _getChurchDisplayText(provider),
              getPastorsDisplayText: () => _getPastorsDisplayText(provider),
            ),
      ),
    );
  }

  // Extract submit handler for better readability and error handling
  Future<void> _handleSubmitPrayer(
    BuildContext context,
    PrayerRequestProvider provider,
  ) async {
    try {
      final result = await provider.submitPrayer();
      if (!context.mounted) return; // Check if widget is still mounted
      _showSnackBar(context, result['message'], result['success']);
      if (result['success']) {
        final newPrayerPost = _createPrayerPost(provider);
        onPrayerAdded(newPrayerPost);
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(
          context,
          'An error occurred while submitting prayer',
          false,
        );
      }
    }
  }

  // Extract PrayerPost creation for better readability
  PrayerPost _createPrayerPost(PrayerRequestProvider provider) {
    return PrayerPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // More unique ID
      userName: 'You',
      userAvatar: '',
      createdAt: DateTime.now(),
      content: provider.subjectController.text,
      details: provider.requestController.text,
      likes: 0,
      prayers: 0,
      comments: 0,
      hasLiked: false,
      hasPrayed: false,
      cardColor: provider.selectedColor,
    );
  }

  // Extract SnackBar display for reusability
  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Extract display text methods for better organization
  String _getHashtagsDisplayText(PrayerRequestProvider provider) {
    final selectedTags = provider.selectedHashtags;
    if (selectedTags.isEmpty) return 'Select tags';
    if (selectedTags.length == 1) return selectedTags.first;
    return '${selectedTags.length} tags selected';
  }

  String _getChurchDisplayText(PrayerRequestProvider provider) {
    return provider.selectedChurch ?? 'Select church';
  }

  String _getPastorsDisplayText(PrayerRequestProvider provider) {
    final selectedPastors = provider.selectedPastors;
    if (selectedPastors.isEmpty) return 'Select pastors';
    if (selectedPastors.length == 1) return selectedPastors.first;
    return '${selectedPastors.length} pastors selected';
  }
}

import 'package:flutter/material.dart';

class PrayerRequestWidgets {
  static Widget buildScaffold({
    required BuildContext context,
    required TextEditingController subjectController,
    required TextEditingController requestController,
    required Color selectedColor,
    required List<Color> themeColors,
    required List<String> selectedHashtags,
    required bool isHashtagDropdownOpen,
    required bool isTagsLoading,
    required String? errorMessage,
    required List<String> availableTags,
    required String selectedPostType,
    required bool isChurchDropdownOpen,
    required bool isPastorDropdownOpen,
    required List<Map<String, String>> availableChurches,
    required List<Map<String, String>> availablePastors,
    required String? selectedChurch,
    required List<String> selectedPastors,
    required bool isLoading,
    // Callbacks
    required Function(Color) onColorSelected,
    required VoidCallback onHashtagToggle,
    required Function(String) onTagSelected,
    required Function(String) onPostTypeChanged,
    required VoidCallback onChurchDropdownToggle,
    required VoidCallback onPastorDropdownToggle,
    required Function(String) onChurchSelected,
    required Function(String) onPastorToggle,
    required VoidCallback onClearForm,
    required VoidCallback onSubmitPrayer,
    required VoidCallback onRefreshTags,
    required String Function() getHashtagsDisplayText,
    required String Function() getChurchDisplayText,
    required String Function() getPastorsDisplayText,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              _buildHeader(context),
              const SizedBox(height: 24),

              // New Prayer Request title
              const Text(
                'New Prayer Request',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0E2D),
                ),
              ),
              const SizedBox(height: 16),

              // Subject field
              _buildTextField(
                label: 'Subject*',
                controller: subjectController,
                hintText: 'Enter a subject for your prayer request',
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Details field
              _buildTextField(
                label: 'Details*',
                controller: requestController,
                hintText: 'Share the details of your prayer request',
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Tags dropdown
              _buildTagsDropdown(
                isTagsLoading: isTagsLoading,
                errorMessage: errorMessage,
                isHashtagDropdownOpen: isHashtagDropdownOpen,
                availableTags: availableTags,
                selectedHashtags: selectedHashtags,
                getHashtagsDisplayText: getHashtagsDisplayText,
                onHashtagToggle: onHashtagToggle,
                onTagSelected: onTagSelected,
                onRefreshTags: onRefreshTags,
              ),
              const SizedBox(height: 16),

              // Theme selection
              _buildThemeSelection(
                themeColors: themeColors,
                selectedColor: selectedColor,
                onColorSelected: onColorSelected,
              ),
              const SizedBox(height: 16),

              // Audience selection
              _buildAudienceSelection(
                selectedPostType: selectedPostType,
                onPostTypeChanged: onPostTypeChanged,
              ),

              // Church and Pastor selection
              if (selectedPostType == 'church_community') ...[
                const SizedBox(height: 16),
                _buildSingleSelectDropdown(
                  title: 'Select Church',
                  displayText: getChurchDisplayText(),
                  isOpen: isChurchDropdownOpen,
                  onToggle: onChurchDropdownToggle,
                  items: availableChurches,
                  selectedItem: selectedChurch,
                  onItemSelect: onChurchSelected,
                ),
                const SizedBox(height: 16),
                _buildMultiSelectDropdown(
                  title: 'Select Pastors',
                  displayText: getPastorsDisplayText(),
                  isOpen: isPastorDropdownOpen,
                  onToggle: onPastorDropdownToggle,
                  items: availablePastors,
                  selectedItems: selectedPastors,
                  onItemToggle: onPastorToggle,
                ),
              ],

              const SizedBox(height: 24),

              // Error message
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Action buttons
              _buildActionButtons(
                isLoading: isLoading,
                onClearForm: onClearForm,
                onSubmitPrayer: onSubmitPrayer,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: const Color(0xFF0A0E2D),
        child: const SafeArea(
          child: Column(
            children: [
              // Teleo logo
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Teleo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              // Tabs
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E2D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Prayer Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
      ],
    );
  }

  static Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0A0E2D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildTagsDropdown({
    required bool isTagsLoading,
    required String? errorMessage,
    required bool isHashtagDropdownOpen,
    required List<String> availableTags,
    required List<String> selectedHashtags,
    required String Function() getHashtagsDisplayText,
    required VoidCallback onHashtagToggle,
    required Function(String) onTagSelected,
    required VoidCallback onRefreshTags,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isTagsLoading || errorMessage != null ? null : onHashtagToggle,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isTagsLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : errorMessage != null
                          ? Row(
                            children: [
                              const Text(
                                'Failed to load tags',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onRefreshTags,
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            getHashtagsDisplayText(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                      Icon(
                        isHashtagDropdownOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                if (isHashtagDropdownOpen &&
                    !isTagsLoading &&
                    errorMessage == null)
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child:
                        availableTags.isEmpty
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'No tags available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            : Column(
                              children:
                                  availableTags
                                      .map(
                                        (tag) => InkWell(
                                          onTap: () => onTagSelected(tag),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  selectedHashtags.contains(tag)
                                                      ? const Color(0xFF0A0E2D)
                                                      : Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  selectedHashtags.contains(tag)
                                                      ? Icons.check
                                                      : null,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  tag,
                                                  style: TextStyle(
                                                    color:
                                                        selectedHashtags
                                                                .contains(tag)
                                                            ? Colors.white
                                                            : Colors.black87,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildThemeSelection({
    required List<Color> themeColors,
    required Color selectedColor,
    required Function(Color) onColorSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Theme',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(themeColors.length, (index) {
            return GestureDetector(
              onTap: () => onColorSelected(themeColors[index]),
              child: Container(
                decoration: BoxDecoration(
                  color: themeColors[index],
                  borderRadius: BorderRadius.circular(8),
                  border:
                      selectedColor == themeColors[index]
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  static Widget _buildAudienceSelection({
    required String selectedPostType,
    required Function(String) onPostTypeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Audience*',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        _buildAudienceOption(
          'public',
          'Public',
          '(Visible to everyone)',
          selectedPostType,
          onPostTypeChanged,
        ),
        _buildAudienceOption(
          'church_community',
          'Church Community',
          '(Visible to pastors and leaders)',
          selectedPostType,
          onPostTypeChanged,
        ),
        _buildAudienceOption(
          'private',
          'Only Me',
          '(Visible only to you)',
          selectedPostType,
          onPostTypeChanged,
        ),
      ],
    );
  }

  static Widget _buildAudienceOption(
    String value,
    String title,
    String subtitle,
    String selectedPostType,
    Function(String) onPostTypeChanged,
  ) {
    return GestureDetector(
      onTap: () => onPostTypeChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPostType,
              onChanged: (newValue) => onPostTypeChanged(newValue!),
              activeColor: const Color(0xFF0A0E2D),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSingleSelectDropdown({
    required String title,
    required String displayText,
    required bool isOpen,
    required VoidCallback onToggle,
    required List<Map<String, String>> items,
    required String? selectedItem,
    required Function(String) onItemSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF8A2BE2),
                      ),
                    ],
                  ),
                ),
                if (isOpen)
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Column(
                      children:
                          items.map((item) {
                            final isSelected = selectedItem == item['name'];
                            return InkWell(
                              onTap: () => onItemSelect(item['name']!),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? const Color(0xFF0A0E2D)
                                          : Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check : null,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['name']!,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildMultiSelectDropdown({
    required String title,
    required String displayText,
    required bool isOpen,
    required VoidCallback onToggle,
    required List<Map<String, String>> items,
    required List<String> selectedItems,
    required Function(String) onItemToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0E2D),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF8A2BE2),
                      ),
                    ],
                  ),
                ),
                if (isOpen)
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Column(
                      children:
                          items.map((item) {
                            final isSelected = selectedItems.contains(
                              item['name'],
                            );
                            return InkWell(
                              onTap: () => onItemToggle(item['name']!),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? const Color(0xFF0A0E2D)
                                          : Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check : null,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['name']!,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildActionButtons({
    required bool isLoading,
    required VoidCallback onClearForm,
    required VoidCallback onSubmitPrayer,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onClearForm,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF0A0E2D)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A0E2D),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmitPrayer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF0A0E2D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                isLoading
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                    : const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}

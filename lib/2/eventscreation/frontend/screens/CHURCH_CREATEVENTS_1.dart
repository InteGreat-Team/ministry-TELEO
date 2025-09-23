import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../screens/CHURCH_CREATEVENTS_2.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateEventViewModel(),
      child: Consumer<CreateEventViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: EventAppBar(
              onBackPressed: () => Navigator.maybePop(context),
              title: '',
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StepIndicator(currentStep: 1, totalSteps: 7),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'What is your event for?',
                                  style: TextStyle(
                                    color: Color(0xFF0A0A4A),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Image upload disabled in this step

                                // Event Title
                                const SizedBox(height: 20),
                                _buildEventTitleField(viewModel),

                                // Event Tags
                                const SizedBox(height: 20),
                                _buildEventTagsSection(viewModel),

                                // Event Description
                                const SizedBox(height: 20),
                                _buildEventDescriptionField(viewModel),

                                // Mobile Number
                                const SizedBox(height: 20),
                                _buildMobileNumberField(viewModel),

                                // Church Landline
                                const SizedBox(height: 16),
                                _buildChurchLandlineField(viewModel),

                                // Dress Code
                                const SizedBox(height: 16),
                                _buildDressCodeField(viewModel),

                                // Guest/Speaker
                                const SizedBox(height: 20),
                                _buildSpeakersSection(viewModel),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtonBar(viewModel),
                ],
              ),
            ),
            bottomNavigationBar: NavBar(
              currentIndex: 2, // Set to the correct index for Events
              onTap: (index) {
                // Add navigation logic if needed
              },
            ),
          );
        },
      ),
    );
  }

  // Image upload/display intentionally omitted in this step

  Widget _buildEventTitleField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Title',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.titleController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter event title',
          ),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(EventConstants.titlePattern)),
          ],
        ),
      ],
    );
  }

  Widget _buildEventTagsSection(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Tags',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
            // Tag validation shown via snackbar on submit
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: EventConstants.availableTags.map((tag) {
            final isSelected = viewModel.event.tags.contains(tag);
            return GestureDetector(
              onTap: () => viewModel.toggleTag(tag),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFC107) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFC107)
                        : Colors.grey[400]!,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEventDescriptionField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Event Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.descriptionController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter event description',
          ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildMobileNumberField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Mobile Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const RequiredAsterisk(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.contactInfoController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: '(09123456789)',
            prefixIcon: const Icon(Icons.phone_android),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
            LengthLimitingTextInputFormatter(EventConstants.mobileMaxLength),
          ],
        ),
      ],
    );
  }

  Widget _buildChurchLandlineField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Church Landline',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' (optional)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.churchLandlineController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'Enter church landline/telephone number',
            prefixIcon: const Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(EventConstants.landlineLength),
          ],
        ),
      ],
    );
  }

  Widget _buildDressCodeField(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dress Code (optional)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.dressCodeController,
          decoration: _getFilledInputDecoration().copyWith(
            hintText: 'E.g., Smart Casual',
            helperText: 'Only letters, numbers, spaces, and hyphens allowed',
          ),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(EventConstants.dressCodePattern)),
            LengthLimitingTextInputFormatter(EventConstants.dressCodeMaxLength),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeakersSection(CreateEventViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Guest/Speaker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Only letters, spaces, periods, and hyphens allowed',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.speakers
              .asMap()
              .entries
              .map((entry) => Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => viewModel.removeSpeaker(entry.key),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: viewModel.speakerController,
                decoration: _getFilledInputDecoration().copyWith(
                  hintText: 'Enter speaker name',
                ),
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(EventConstants.namePattern)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A4A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: viewModel.addSpeaker,
                tooltip: 'Add New Guest/Speaker',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtonBar(CreateEventViewModel viewModel) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0A0A4A),
                    side: const BorderSide(color: Color(0xFF0A0A4A)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (viewModel.validateForm()) {
                      viewModel.saveEventData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchCreateEvent2(event: viewModel.event),
                        ),
                      );
                    } else {
                      _showErrorSnackbar(viewModel.errorMessage ??
                          ValidationMessages.fillRequiredFields);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0A4A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactImageCard(
    Uint8List? imageBytes,
    String? imagePath,
    String label, {
    required VoidCallback onRemove,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.delete, color: Colors.red, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: imageBytes != null
                  ? Image.memory(imageBytes,
                      width: double.infinity, fit: BoxFit.cover)
                  : imagePath != null
                      ? Image.file(File(imagePath),
                          width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image,
                              size: 30, color: Colors.grey),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getFilledInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(color: Colors.grey[600]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

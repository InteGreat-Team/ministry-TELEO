import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel, VerificationDocument, DocumentType
import '../../backend/viewmodels/CHURCH_SIGNUP_FUNC.dart'; // For ChurchSignupViewModel
import '../widgets/index.dart'; // For TeleoBackButton, CustomHeader, CustomElevatedButton, LoadingOverlay, DashedBorderPainter
import 'CHURCH_SIGNUP_10.dart'; // For next screen

class ChurchVerificationScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchVerificationScreen({super.key, required this.church});

  @override
  State<ChurchVerificationScreen> createState() =>
      _ChurchVerificationScreenState();
}

class _ChurchVerificationScreenState extends State<ChurchVerificationScreen> {
  File? _secCertificate;
  File? _faithStatement;
  final List<File> _churchPhotos = [];
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-populate from church model if available
    if (widget.church.documents.isNotEmpty) {
      for (final doc in widget.church.documents) {
        if (doc.type == DocumentType.secCertificate && doc.filePath != null) {
          _secCertificate = File(doc.filePath!);
        } else if (doc.type == DocumentType.statementOfFaith && doc.filePath != null) {
          _faithStatement = File(doc.filePath!);
        }
      }
    }
    
    if (widget.church.churchPhotos.isNotEmpty) {
      _churchPhotos.addAll(widget.church.churchPhotos);
    }
  }

  Future<void> _pickDocument(DocumentType type) async {
    try {
      final XFile? result = await _picker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        setState(() {
          if (type == DocumentType.secCertificate) {
            _secCertificate = File(result.path);
          } else if (type == DocumentType.statementOfFaith) {
            _faithStatement = File(result.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking document: $e')),
        );
      }
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> result = await _picker.pickMultipleMedia();
      if (result.isNotEmpty) {
        setState(() {
          for (var file in result) {
            if (_churchPhotos.length < ChurchSignupConstants.maxPhotos) {
              _churchPhotos.add(File(file.path));
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  void _removeDocument(DocumentType type) {
    setState(() {
      if (type == DocumentType.secCertificate) {
        _secCertificate = null;
      } else if (type == DocumentType.statementOfFaith) {
        _faithStatement = null;
      }
    });
  }

  void _removePhoto(int index) {
    setState(() {
      if (index >= 0 && index < _churchPhotos.length) {
        _churchPhotos.removeAt(index);
      }
    });
  }

  bool get _isFormValid {
    return _secCertificate != null &&
        _faithStatement != null &&
        _churchPhotos.isNotEmpty;
  }

  Future<void> _submitApplication() async {
    if (!_isFormValid) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Create verification documents
      final List<VerificationDocument> documents = [];
      
      if (_secCertificate != null) {
        documents.add(VerificationDocument(
          fileName: _secCertificate!.path.split('/').last,
          filePath: _secCertificate!.path,
          type: DocumentType.secCertificate,
          fileSize: await _secCertificate!.length(),
          uploadDate: DateTime.now(),
        ));
      }
      
      if (_faithStatement != null) {
        documents.add(VerificationDocument(
          fileName: _faithStatement!.path.split('/').last,
          filePath: _faithStatement!.path,
          type: DocumentType.statementOfFaith,
          fileSize: await _faithStatement!.length(),
          uploadDate: DateTime.now(),
        ));
      }

      final updatedChurch = widget.church.copyWith(
        documents: documents,
        churchPhotos: _churchPhotos,
        verificationStatus: VerificationStatus.inProgress,
        submissionDate: DateTime.now(),
        referenceCode: widget.church.generateReferenceCode(),
      );

      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicationSubmittedScreen(
              church: updatedChurch,
              viewModel: Provider.of<ChurchSignupViewModel>(context, listen: false),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting application: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isUploading,
          message: 'Submitting application...',
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TeleoBackButton(),
                  ),
                  const SizedBox(height: 24),

                  // Title and Subtitle
                  const CustomHeader(
                    title: "Let's Verify Your Church!",
                    subtitle: "Please upload the necessary documents for us to verify your church.",
                    icon: Icons.verified,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 40),

                  // SEC Certificate
                  _buildDocumentSection(
                    title: 'SEC Certificate',
                    file: _secCertificate,
                    onTap: () => _pickDocument(DocumentType.secCertificate),
                    onRemove: () => _removeDocument(DocumentType.secCertificate),
                  ),
                  const SizedBox(height: 24),

                  // Statement of Faith
                  _buildDocumentSection(
                    title: 'Statement of Faith',
                    file: _faithStatement,
                    onTap: () => _pickDocument(DocumentType.statementOfFaith),
                    onRemove: () => _removeDocument(DocumentType.statementOfFaith),
                  ),
                  const SizedBox(height: 24),

                  // Photos of the Church
                  const Text(
                    'Photos of the Church and/or Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Upload button
                  _buildUploadButton(),
                  const SizedBox(height: 16),

                  // Drag & Drop area
                  _buildDragDropArea(),
                  const SizedBox(height: 16),

                  // Display selected photos
                  if (_churchPhotos.isNotEmpty) ...[
                    const Text(
                      'Selected Photos:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPhotoGrid(),
                  ],
                  const SizedBox(height: 40),

                  // Submit button
                  CustomElevatedButton(
                    onPressed: _isFormValid && !_isUploading ? _submitApplication : null,
                    text: 'Submit',
                    isLoading: _isUploading,
                    backgroundColor: const Color(0xFF002642),
                    foregroundColor: Colors.white,
                    height: 56,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentSection({
    required String title,
    required File? file,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: file != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            file.path.split('/').last,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade300),
                          onPressed: onRemove,
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      'document-name.PDF',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose file to upload',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.upload, color: Colors.blue.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragDropArea() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.blue.shade200,
          strokeWidth: 1,
          gap: 5.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload,
              size: 64,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Drag & drop files or ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: _pickImages,
                  child: Text(
                    'Browse',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Supported formats: png, jpeg, jpg, heic',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _churchPhotos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _churchPhotos[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removePhoto(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

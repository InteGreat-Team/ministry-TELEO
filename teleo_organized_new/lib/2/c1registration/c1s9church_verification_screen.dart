import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Use image_picker for both images and documents
import '../../../2/church_model.dart';
import '../../3/c1widgets/back_button.dart';
import 'c1s10application_submitted_screen.dart';
import 'dart:math'; // Import for sqrt function

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

  Future<void> _pickDocument(int documentType) async {
    try {
      // Use image_picker instead of file_picker
      final XFile? result = await _picker.pickMedia();

      if (result != null) {
        setState(() {
          if (documentType == 1) {
            _secCertificate = File(result.path);
          } else if (documentType == 2) {
            _faithStatement = File(result.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking document: $e')));
    }
  }

  Future<void> _pickImages() async {
    try {
      // Use image_picker instead of file_picker
      final List<XFile> result = await _picker.pickMultiImage();

      if (result.isNotEmpty) {
        setState(() {
          for (var file in result) {
            _churchPhotos.add(File(file.path));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking images: $e')));
    }
  }

  void _removeDocument(int documentType) {
    setState(() {
      if (documentType == 1) {
        _secCertificate = null;
      } else if (documentType == 2) {
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
      // Simulate uploading documents
      await Future.delayed(const Duration(seconds: 2));

      // Update church model with verification documents
      final List<String> documentPaths = [];
      if (_secCertificate != null) {
        documentPaths.add(_secCertificate!.path);
      }
      if (_faithStatement != null) {
        documentPaths.add(_faithStatement!.path);
      }
      for (var photo in _churchPhotos) {
        documentPaths.add(photo.path);
      }

      final updatedChurch = widget.church.copyWith(
        verificationDocuments: documentPaths,
      );

      // Navigate to success screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ApplicationSubmittedScreen(church: updatedChurch),
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
        child: Stack(
          children: [
            SingleChildScrollView(
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

                    // Title
                    const Center(
                      child: Text(
                        "Let's Verify Your Church!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    const Center(
                      child: Text(
                        "Please upload the necessary documents for us to verify your church.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // SEC Certificate
                    const Text(
                      'SEC Certificate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDocument(1),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            _secCertificate != null
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _secCertificate!.path.split('/').last,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade300,
                                        ),
                                        onPressed: () => _removeDocument(1),
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
                    const SizedBox(height: 24),

                    // Statement of Faith
                    const Text(
                      'Statement of Faith',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDocument(2),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            _faithStatement != null
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _faithStatement!.path.split('/').last,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade300,
                                        ),
                                        onPressed: () => _removeDocument(2),
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
                    GestureDetector(
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
                    ),
                    const SizedBox(height: 16),

                    // Drag & Drop area - FIXED THE DASHED BORDER HERE
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 1,
                        ),
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
                    ),
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
                      SizedBox(
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
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid && !_isUploading
                                ? _submitApplication
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002642),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child:
                            _isUploading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isUploading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter to draw dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Draw top line
    _drawDashedLine(canvas, paint, const Offset(0, 0), Offset(size.width, 0));

    // Draw right line
    _drawDashedLine(
      canvas,
      paint,
      Offset(size.width, 0),
      Offset(size.width, size.height),
    );

    // Draw bottom line
    _drawDashedLine(
      canvas,
      paint,
      Offset(size.width, size.height),
      Offset(0, size.height),
    );

    // Draw left line
    _drawDashedLine(canvas, paint, Offset(0, size.height), const Offset(0, 0));
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double distance = sqrt(
      dx * dx + dy * dy,
    ); // Using dart:math sqrt function

    const double dashLength = 5;
    final int dashCount = (distance / (dashLength + gap)).floor();

    final double stepX = dx / dashCount;
    final double stepY = dy / dashCount;

    double currentX = start.dx;
    double currentY = start.dy;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawLine(
        Offset(currentX, currentY),
        Offset(
          currentX + stepX * dashLength / (dashLength + gap),
          currentY + stepY * dashLength / (dashLength + gap),
        ),
        paint,
      );

      currentX += stepX;
      currentY += stepY;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// Import your home page

void main() {
  runApp(const DonationApp());
}

class DonationApp extends StatelessWidget {
  const DonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class DonationProgram {
  final int id;
  final String title;
  final String description;
  final String amount;
  final String location;
  final IconData icon;
  final String category;
  final String imagePath; // Added image path

  DonationProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.location,
    required this.icon,
    required this.category,
    required this.imagePath, // Added image path parameter
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<DonationProgram> _donationPrograms = [
    DonationProgram(
      id: 6,
      title: 'Support the Teleo Team',
      description: 'Support the developers of the Teleo App',
      amount: 'P 50-500',
      location: 'Nationwide',
      icon: Icons.support_agent,
      category: 'Teleo Team',
      imagePath:
          'assets/images/Team_Teleo.png', // Using Emergency Relief as fallback
    ),
    DonationProgram(
      id: 1,
      title: 'Feeding Program',
      description: 'Help provide meals for families in need',
      amount: 'P 50-500',
      location: 'Metro Manila',
      icon: Icons.restaurant,
      category: 'Feeding Program',
      imagePath: 'assets/images/Feeding_prog.png',
    ),
    DonationProgram(
      id: 2,
      title: 'Medical Mission',
      description: 'Support healthcare services for communities',
      amount: 'P 50-500',
      location: 'Baguio',
      icon: Icons.medical_services,
      category: 'Medical Mission',
      imagePath: 'assets/images/Medical_Mission.jpg',
    ),
    DonationProgram(
      id: 3,
      title: 'School Supplies',
      description: 'Provide educational materials for students',
      amount: 'P 50-500',
      location: 'Davao City',
      icon: Icons.school,
      category: 'School Supplies',
      imagePath: 'assets/images/School_Supplies.jpg',
    ),
    DonationProgram(
      id: 4,
      title: 'Housing Program',
      description: 'Help build homes for families',
      amount: 'P 50-500',
      location: 'Metro Manila',
      icon: Icons.home,
      category: 'housing',
      imagePath: 'assets/images/Housing_Program.jpg',
    ),
    DonationProgram(
      id: 5,
      title: 'Emergency Relief',
      description: 'Disaster response and emergency aid',
      amount: 'P 50-500',
      location: 'Nationwide',
      icon: Icons.emergency,
      category: 'emergency',
      imagePath: 'assets/images/Emergency_Relief.jpg',
    ),
  ];

  List<DonationProgram> get _filteredPrograms {
    if (_searchQuery.isEmpty) {
      return _donationPrograms;
    }
    return _donationPrograms.where((program) {
      return program.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          program.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
          program.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          program.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF1A237E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Donations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Total Donations',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Text(
                    'P ---',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '---',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            '---',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '----',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search campaign...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // Donation Programs Grid
            Expanded(
              child: _filteredPrograms.isEmpty
                  ? const Center(
                      child: Text(
                        'No donation programs found matching your search.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _filteredPrograms.length,
                      itemBuilder: (context, index) {
                        final program = _filteredPrograms[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DonatePage(program: program),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Positioned.fill(
                                    child: Image.asset(
                                      program.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Fallback to colored container if image fails to load
                                        return Container(
                                          color: const Color(0xFF1A237E),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    program.icon,
                                                    color:
                                                        const Color(0xFF1A237E),
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Image not found',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Dark overlay for better text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Amount in top right
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 4.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Text(
                                                  program.amount,
                                                  style: const TextStyle(
                                                    color: Color(0xFF1A237E),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          // Title and description at bottom
                                          Text(
                                            program.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            program.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white54,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                program.location,
                                                style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonatePage extends StatefulWidget {
  final DonationProgram program;

  const DonatePage({super.key, required this.program});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  int? _selectedAmount;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _donationAmounts = [
    {'value': 100, 'label': 'P 100'},
    {'value': 200, 'label': 'P 200'},
    {'value': 300, 'label': 'P 300'},
    {'value': 400, 'label': 'P 400'},
    {'value': 500, 'label': 'P 500'},
  ];

  Future<void> _handleGiftWithPurpose() async {
    if (_selectedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a donation amount first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get Firebase Auth ID token
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        setState(() {
          _errorMessage = 'Please sign in to make a donation.';
        });
        return;
      }

      final String? token = await currentUser.getIdToken();

      if (token == null) {
        setState(() {
          _errorMessage =
              'Failed to get authentication token. Please try signing in again.';
        });
        return;
      }

      final url = Uri.parse(
          "https://asia-southeast1-teleo-church-application.cloudfunctions.net/donationApi/donate");

      final amount = _selectedAmount!;
      final category = widget.program.category;

      final body = jsonEncode(
          {"amount": amount, "category": category, "description": "Donation"});

      print('🚀 Making donation request to: $url');
      print('📦 Request body: $body');
      print('🔐 Using Firebase Auth token: ${token.substring(0, 20)}...');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['checkout_url'];

        if (checkoutUrl != null) {
          _showPaymentDialog(checkoutUrl);
        } else {
          setState(() {
            _errorMessage = 'No checkout URL received from server.';
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Authentication failed. Please sign in again.';
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ??
              'Failed to create donation. Please try again.';
        });
      }
    } catch (e) {
      print('❌ Error making donation request: $e');
      setState(() {
        _errorMessage = e.toString().contains('SocketException')
            ? 'Network error: Cannot reach server. Check your connection.'
            : 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPaymentDialog(String checkoutUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.payment,
                color: const Color(0xFF1A237E),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text('Payment Ready'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your donation of ₱${_selectedAmount} for ${widget.program.title} has been created successfully!',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Click the button below to proceed to payment.',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  checkoutUrl,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final Uri url = Uri.parse(checkoutUrl);
                final bool launched = await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
                if (!launched) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Could not open payment link.'),
                      backgroundColor: Colors.red[600],
                    ),
                  );
                } else {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Back to donations list
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
              ),
              icon: const Icon(Icons.open_in_browser,
                  color: Colors.white, size: 18),
              label: const Text(
                'Proceed to Payment',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with enhanced back button
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Program Image Header
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: Image.asset(
                                widget.program.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback to colored container if image fails to load
                                  return Container(
                                    color: const Color(0xFF6A1B9A),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Icon(
                                            widget.program.icon,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'CHARITY',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const Text(
                                          'MAKING A DIFFERENCE',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Dark overlay for better text readability
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Charity label overlay
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CHARITY',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const Text(
                                    'MAKING A DIFFERENCE',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Program Details
                    Text(
                      widget.program.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.program.description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),

                    // Organization
                    Row(
                      children: [
                        Icon(Icons.people, color: Colors.blue[400], size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Community Church',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.orange[400],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.program.location,
                          style: TextStyle(
                            color: Colors.orange[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Amount Selection
                    Row(
                      children: [
                        const Text(
                          'Select Your Gift Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Max: ₱500',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: _donationAmounts.length,
                      itemBuilder: (context, index) {
                        final amount = _donationAmounts[index];
                        final isSelected = _selectedAmount == amount['value'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAmount = amount['value'];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1A237E)
                                  : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFF1A237E),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                amount['label'],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1A237E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Gift with Purpose Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleGiftWithPurpose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Gift with Purpose',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Your gift helps us reach more hearts and homes.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),

                    // Error message display
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error,
                                  color: Colors.red[600], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

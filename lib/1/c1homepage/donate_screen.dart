import 'package:flutter/material.dart';

// For donation API
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  DonationProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.location,
    required this.icon,
    required this.category,
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
      id: 1,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 10',
      location: 'Metro Manila',
      icon: Icons.home,
      category: 'housing',
    ),
    DonationProgram(
      id: 2,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 5',
      location: 'Baguio',
      icon: Icons.favorite,
      category: 'housing',
    ),
    DonationProgram(
      id: 3,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 3',
      location: 'Davao City',
      icon: Icons.people,
      category: 'housing',
    ),
    DonationProgram(
      id: 4,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 5',
      location: 'Metro Manila',
      icon: Icons.school,
      category: 'education',
    ),
    DonationProgram(
      id: 5,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 3',
      location: 'Metro Manila',
      icon: Icons.home,
      category: 'housing',
    ),
    DonationProgram(
      id: 6,
      title: 'Bahay Pag-ibig',
      description: 'Help provide essential clothing and educational materials',
      amount: 'P 5',
      location: 'Metro Manila',
      icon: Icons.restaurant,
      category: 'food',
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
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF1A237E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Donations',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Text(
                    'P 1,500',
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
                        'Last Donation: April 1, 2025',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'This Month',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'P 500',
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
              child:
                  _filteredPrograms.isEmpty
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
                                  builder:
                                      (context) => DonatePage(program: program),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Icon(
                                          program.icon,
                                          color: const Color(0xFF1A237E),
                                          size: 24,
                                        ),
                                      ),
                                      Text(
                                        program.amount,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    program.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    program.description,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
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
    {'value': 25, 'label': 'P 25'},
    {'value': 50, 'label': 'P 50'},
    {'value': 100, 'label': 'P 100'},
    {'value': 200, 'label': 'P 200'},
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to donate.';
          _isLoading = false;
        });
        return;
      }

      String? idToken = await user.getIdToken();

      final url = Uri.parse(
        'https://dvpt2axvom47x.cloudfront.net/payment/create',
      );
      final amount = _selectedAmount!;

      final body = jsonEncode({
        "amount": amount,
        "description": "Donation to ${widget.program.title}",
        "currency": "PHP",
        "successUrl": "https://yourapp.com/success",
        "failureUrl": "https://yourapp.com/failure",
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to create donation. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black54,
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
                    // Charity Logo/Image
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A1B9A),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(16.0),
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
                            'TAGLINE HERE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
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
                    const Text(
                      'Select Your Gift Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
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
                              color:
                                  isSelected
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
                                  color:
                                      isSelected
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
                        child:
                            _isLoading
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
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
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

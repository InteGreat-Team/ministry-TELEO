import 'package:flutter/material.dart';
import '../c2inbox/service_request_notification.dart';
import 'c2s2_edit_service_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../c2homepage/home_page.dart';
import '../../3/nav_bar.dart';

class ServicePortfolioPage extends StatefulWidget {
  const ServicePortfolioPage({super.key});

  @override
  State<ServicePortfolioPage> createState() => _ServicePortfolioPageState();
}

class _ServicePortfolioPageState extends State<ServicePortfolioPage> {
  bool _showNotification = false;
  List<Map<String, dynamic>> _activeServices = [];
  bool _isLoading = true;
  String? _errorMessage;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredServices = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchActiveServices();

    Future.delayed(const Duration(seconds: 2), () {
      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _showNotification = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      _filterServices();
    });
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredServices = List.from(_activeServices);
    } else {
      _filteredServices =
          _activeServices.where((service) {
            return service['title'].toString().toLowerCase().contains(query) ||
                service['description'].toString().toLowerCase().contains(
                  query,
                ) ||
                service['location'].toString().toLowerCase().contains(query) ||
                (service['tags'] as List).any(
                  (tag) => tag.toString().toLowerCase().contains(query),
                );
          }).toList();
    }
  }

  Future<void> _fetchActiveServices() async {
    const String apiUrl =
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/getChurchServices';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Check if widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _activeServices =
                data
                    .map(
                      (service) => {
                        'c_id': 'CH0001',
                        'serv_id': service['serv_id'],
                        'title': service['serv_name'],
                        'description': service['description'],
                        'amount': service['amount'], // <-- add this!
                        'serv_type': service['serv_type'], // <-- add this!
                        'serv_mode': service['serv_mode'], // <-- add this!
                        'timeslot': service['timeslot'], // <-- add this!
                        'location': _getLocation(service['serv_mode']),
                        'tags': _generateTags(service),
                        'media': service['media'],
                      },
                    )
                    .toList();
            _filteredServices = List.from(_activeServices);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage =
                'Failed to load active services: ${response.statusCode}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error fetching active services: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _getLocation(String servMode) {
    switch (servMode) {
      case 'To the Church':
        return 'Church or set location';
      case 'To Your Location':
        return 'Set location';
      case 'Divine Link (Online)':
        return 'Online';
      default:
        return 'Church or set location';
    }
  }

  List<String> _generateTags(Map<String, dynamic> service) {
    switch (service['serv_type']) {
      case 'C0001':
        return ['Later'];
      case 'C0002':
        return ['Fast'];
      case 'C0003':
        return ['Fast', 'Later'];
      default:
        return []; // Or your default logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          'Service Portfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Icon(Icons.search, color: Colors.grey.shade500),
                      ),
                      suffixIcon:
                          _isSearching
                              ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _isSearching = false;
                                  });
                                },
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Services (${_activeServices.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000233),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          _showAddServiceBottomSheet(context);
                        },
                        icon: const Text(
                          'Add a Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        label: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchActiveServices,
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                          ? Center(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : _filteredServices.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isSearching
                                      ? 'No services match your search'
                                      : 'No active services',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: _showNotification ? 280 : 16,
                              left: 16,
                              right: 16,
                            ),
                            itemCount: _filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = _filteredServices[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ServiceCard(
                                  title: service['title'],
                                  description: service['description'],
                                  location: service['location'],
                                  tags: List<String>.from(service['tags']),
                                  media: service['media'],
                                  cId: 'CH0001',
                                  servId: service['serv_id'] ?? '',
                                  servName: service['title'] ?? '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ServiceDetailPage(
                                              title: service['title'] ?? '',
                                              description:
                                                  service['description'] ?? '',
                                              amount:
                                                  service['amount'] is int
                                                      ? service['amount']
                                                      : int.tryParse(
                                                            service['amount']
                                                                    ?.toString() ??
                                                                '0',
                                                          ) ??
                                                          0,
                                              servType:
                                                  service['serv_type'] ?? '',
                                              servMode:
                                                  service['serv_mode'] ?? '',
                                              timeslot:
                                                  service['timeslot'] ?? '',
                                              cId: 'CH0001',
                                              servName: service['title'] ?? '',
                                              servId: service['serv_id'] ?? '',
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
          if (_showNotification)
            ServiceRequestNotification(
              onAccept: () {
                if (mounted) {
                  setState(() {
                    _showNotification = false;
                  });
                }
              },
              onDecline: () {
                if (mounted) {
                  setState(() {
                    _showNotification = false;
                  });
                }
              },
              onClose: () {
                if (mounted) {
                  setState(() {
                    _showNotification = false;
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  void _showAddServiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddServiceBottomSheet(
          onServiceAdded: () {
            _fetchActiveServices();
          },
        );
      },
    );
  }
}

class AddServiceBottomSheet extends StatefulWidget {
  final VoidCallback onServiceAdded;

  const AddServiceBottomSheet({super.key, required this.onServiceAdded});

  @override
  _AddServiceBottomSheetState createState() => _AddServiceBottomSheetState();
}

class _AddServiceBottomSheetState extends State<AddServiceBottomSheet> {
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    const String apiUrl =
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/getServices';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Check if widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _services =
                data
                    .map(
                      (service) => {
                        'serv_id': service['serv_id'],
                        'name': service['name'],
                        'description': service['description'],
                        'amount': service['amount'],
                        'serv_type': service['catserv_id'],
                        'serv_mode': service['serv_mode'],
                        'timeslot': service['timeslot'],
                        'media': service['media'],
                        'selected': false,
                      },
                    )
                    .toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to load services: ${response.statusCode}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error fetching services: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addServicesToPortfolio() async {
    const String apiUrl =
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/addChurchServices';
    final selectedServices =
        _services
            .where((service) => service['selected'])
            .map(
              (service) => {
                'serv_id': service['serv_id'],
                'serv_name': service['name'],
                'serv_type': service['serv_type'],
                'description': service['description'],
                'amount': service['amount'],
                'serv_mode': service['serv_mode'],
                'timeslot': service['timeslot'],
                'media': service['media'],
                'status': 'ACTIVE',
              },
            )
            .toList();

    if (selectedServices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one service')),
        );
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'c_id': 'CH0001', 'services': selectedServices}),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          widget.onServiceAdded();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add services: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding services: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add a Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Inactive Services (${_services.where((s) => !s['selected']).length})',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : _services.isEmpty
                    ? const Center(child: Text('No services available'))
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildServiceItem(_services[index]),
                        );
                      },
                    ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF000233),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF000233),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000233),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _addServicesToPortfolio,
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Text(
                            'Add to Portfolio',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
            service['selected'] = !service['selected'];
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Container(width: 6, height: 56, color: const Color(0xFF757575)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    service['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: service['selected'] ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border:
                        service['selected']
                            ? null
                            : Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                  ),
                  child:
                      service['selected']
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Rest of your ServiceCard and ServiceDetailPage classes remain the same...
class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String cId; // Add this
  final String servId; // Add this
  final String servName; // Add this
  final List<String> tags;
  final String? media; // <-- Add this
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.tags,
    required this.cId, // Add this
    required this.servId, // Add this
    required this.servName, // Add this
    this.media,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59052),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child:
                      (media != null && media!.isNotEmpty)
                          ? Image.network(
                            media!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          )
                          : Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 20,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 0,
                                  child: Container(
                                    height: 1.5,
                                    width: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 16,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Positioned(
                                  left: 2.5,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children:
                            tags.map((tag) {
                              Color bgColor;
                              Color textColor;
                              if (tag == 'Fast' || tag == 'Later') {
                                bgColor = const Color(0xFFE6F4FF);
                                textColor = const Color(0xFF0078D4);
                              } else {
                                bgColor = const Color(0xFFE6FFE6);
                                textColor = const Color(0xFF00A300);
                              }
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
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
  }
}

// Updated Service Detail Page with buttons positioned closer to Time Slots
class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final int amount; // ✅ Add this
  final String servType;
  final String servMode;
  final String timeslot; // ⬅️ Add this field
  final String cId; // ✅ add this
  final String servName; // ✅ add this
  final String servId;

  const ServiceDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.amount, // ✅ Add this
    required this.servType, // ✅ add this
    required this.servMode, // ⬅️ Add this
    required this.timeslot, // ⬅️ Include here
    required this.cId, // ✅ add this
    required this.servName, // ✅ add this
    required this.servId, // ✅ Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split servMode by commas to handle multiple values
    List<String> modes = servMode.split(',');

    return Scaffold(
      body: Stack(
        children: [
          // Full-height column for the content
          Column(
            children: [
              // Header with image
              Container(
                width: double.infinity,
                height: 240, // Increased height to allow for overlap
                color: Colors.grey.shade400, // Grey placeholder
              ),
            ],
          ),

          // Back button - now just a white arrow without background
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Service title at the bottom of the image
          Positioned(
            bottom:
                MediaQuery.of(context).size.height -
                200, // Position near bottom of image
            left: 16,
            right: 16,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),

          // Content with rounded top corners that overlap the image
          Positioned(
            top: 220, // Positioned to overlap the image
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Main content area
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Reservation Mode
                          const Text(
                            'Reservation Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (servType == 'C0002' || servType == 'C0003')
                                _buildChip(
                                  'Fast Booking',
                                  Colors.blue.shade100,
                                  Colors.blue,
                                ),
                              if (servType == 'C0001' || servType == 'C0003')
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: _buildChip(
                                    'Scheduled for Later Booking',
                                    Colors.blue.shade100,
                                    Colors.blue,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Service Mode
                          const Text(
                            'Service Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Build service mode tiles for each mode
                          // Dynamically display service modes using Wrap
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                modes.map((mode) {
                                  switch (mode) {
                                    case 'church_location':
                                      return _buildServiceModeTile(
                                        icon: Icons.church,
                                        title: 'To the Church',
                                        subtitle:
                                            '2222 K Street, Samgyupsal, Salamat City, Napakasarap, Gutom 888',
                                        price: 'Free',
                                      );
                                    case 'user_location':
                                      return _buildServiceModeTile(
                                        icon: Icons.location_on,
                                        title: 'To Your Location',
                                        subtitle:
                                            'Additional fees may apply depending on your set location.',
                                        price: '₱$amount',
                                      );
                                    case 'divine_link':
                                      return _buildServiceModeTile(
                                        icon: Icons.videocam,
                                        title: 'Divine Link (Online)',
                                        subtitle: null,
                                        price: 'Free',
                                      );
                                    default:
                                      return Container(); // Return an empty container for unknown modes
                                  }
                                }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Time Slots
                          const Text(
                            'Time Slots',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                timeslot.split(',').map((slot) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, // white background
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ), // light gray border
                                    ),
                                    child: Text(
                                      slot.trim(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(
                            height: 40,
                          ), // More space between time slots and buttons
                        ],
                      ),
                    ),

                    // White background section with buttons - USING WHITE BACKGROUND FROM THE FIRST IMAGE
                    Container(
                      width: double.infinity,
                      height: 80, // Fixed height for the button area
                      color: Colors.white, // Plain white background
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            // Edit Service Button
                            // In ServiceDetailPage, within the build method, update the Edit Service button:
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(0xFF000233),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditServicePage(
                                                title: title,
                                                description: description,
                                                cId:
                                                    cId, // ✅ Ensure this is passed
                                                servName:
                                                    servName, // ✅ Ensure this is passed
                                                servId:
                                                    servId, // ✅ Ensure this is passed
                                              ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(28),
                                    child: const Center(
                                      child: Text(
                                        'Edit Service',
                                        style: TextStyle(
                                          color: Color(0xFF000233),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 20), // Gap: 20px from Figma
                            // Deactivate Button
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF000233,
                                  ), // Dark navy blue
                                  borderRadius: BorderRadius.circular(
                                    28,
                                  ), // Pill shape
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // Show deactivation confirmation dialog
                                      _showDeactivateConfirmationDialog(
                                        context,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(28),
                                    child: const Center(
                                      child: Text(
                                        'Deactivate',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceModeTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required String price,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ),
          _buildPriceTag(price),
        ],
      ),
    );
  }

  // Method to show the deactivation confirmation dialog
  void _showDeactivateConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E5), // Light orange background
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF59052), // Orange
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                const Text(
                  'Deactivate Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  'Are you sure you want to deactivate this service? This will remove it from your active services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28), // Pill shape
                          border: Border.all(
                            color: const Color(0xFF000233),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(28),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF000233),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Deactivate Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFF3B30,
                          ), // Red color for deactivate
                          borderRadius: BorderRadius.circular(28), // Pill shape
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Handle deactivation
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(
                                context,
                              ); // Go back to previous screen
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: const Center(
                              child: Text(
                                'Deactivate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build price tags
  Widget _buildPriceTag(String text) {
    final bool isFree = text == 'Free';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isFree ? const Color(0xFFE6FFE6) : const Color(0xFFE6F4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isFree ? const Color(0xFF00A300) : const Color(0xFF0078D4),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helper method to build chips
  Widget _buildChip(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

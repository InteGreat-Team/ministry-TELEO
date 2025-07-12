import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Service model to structure the data
class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final IconData? icon;
  final Color? backgroundColor;
  final VoidCallback? onBook;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.icon,
    this.backgroundColor,
    this.onBook,
  });

  // Factory constructor for JSON parsing
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      icon: _getIconFromString(json['icon']),
      backgroundColor: _getColorFromString(json['backgroundColor']),
    );
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'icon': icon?.codePoint,
      'backgroundColor': backgroundColor?.value,
    };
  }

  // Helper method to convert string to IconData
  static IconData? _getIconFromString(String? iconName) {
    if (iconName == null) return null;
    
    final iconMap = {
      'favorite': Icons.favorite,
      'water_drop': Icons.water_drop,
      'local_florist': Icons.local_florist,
      'group': Icons.group,
      'volunteer_activism': Icons.volunteer_activism,
      'church': Icons.church,
      'celebration': Icons.celebration,
      'support': Icons.support,
    };
    
    return iconMap[iconName] ?? Icons.miscellaneous_services;
  }

  // Helper method to convert string to Color
  static Color? _getColorFromString(String? colorString) {
    if (colorString == null) return null;
    
    final colorMap = {
      'pink': Colors.pink[50],
      'blue': Colors.blue[50],
      'grey': Colors.grey[100],
      'orange': Colors.orange[50],
      'green': Colors.green[50],
      'purple': Colors.purple[50],
    };
    
    return colorMap[colorString] ?? Colors.grey[50];
  }
}

// Configuration class for customization
class ServicesConfig {
  final String sectionTitle;
  final double cardWidth;
  final double cardHeight;
  final double cardSpacing;
  final EdgeInsets sectionPadding;
  final TextStyle? titleStyle;
  final TextStyle? cardTitleStyle;
  final TextStyle? cardDescriptionStyle;
  final ButtonStyle? buttonStyle;
  final bool showBookButton;
  final String bookButtonText;
  final int maxServices;

  const ServicesConfig({
    this.sectionTitle = 'Services',
    this.cardWidth = 160.0,
    this.cardHeight = 220.0,
    this.cardSpacing = 12.0,
    this.sectionPadding = const EdgeInsets.all(16.0),
    this.titleStyle,
    this.cardTitleStyle,
    this.cardDescriptionStyle,
    this.buttonStyle,
    this.showBookButton = true,
    this.bookButtonText = 'Book Now',
    this.maxServices = 10,
  });
}

class Services extends StatelessWidget {
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;
  final List<ServiceModel> services;
  final ServicesConfig config;
  final VoidCallback? onBookService;
  final Function(ServiceModel)? onServiceTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const Services({
    super.key,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
    this.services = const [],
    this.config = const ServicesConfig(),
    this.onBookService,
    this.onServiceTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = getResponsivePadding();
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        getResponsiveValue(20, 24, 28),
        0, // Remove right padding to allow cards to extend
        getResponsiveValue(20, 24, 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: Text(
              config.sectionTitle,
              style: config.titleStyle ?? TextStyle(
                fontSize: getResponsiveValue(18, 20, 22),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: getResponsiveValue(16, 18, 20)),
          
          // Content
          if (isLoading)
            _buildLoadingState()
          else if (errorMessage != null)
            _buildErrorState(horizontalPadding)
          else if (services.isEmpty)
            _buildEmptyState(horizontalPadding)
          else
            _buildServicesHorizontalList(),
        ],
      ),
    );
  }

  Widget _buildServicesHorizontalList() {
    final displayServices = services.take(config.maxServices).toList();
    
    return SizedBox(
      height: config.cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: getResponsivePadding()),
        itemCount: displayServices.length,
        itemBuilder: (context, index) {
          final service = displayServices[index];
          return Padding(
            padding: EdgeInsets.only(
              right: config.cardSpacing,
              bottom: 8, // Add bottom padding for shadow
            ),
            child: _buildServiceCard(service),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return GestureDetector(
      onTap: () => onServiceTap?.call(service),
      child: Container(
        width: config.cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceImage(service),
            Expanded(
              child: _buildServiceContent(service),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage(ServiceModel service) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        height: getResponsiveValue(100, 110, 120),
        width: double.infinity,
        color: service.backgroundColor ?? Colors.grey[200],
        child: service.imageUrl != null
            ? Image.network(
                service.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(service),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _buildFallbackIcon(service),
      ),
    );
  }

  Widget _buildFallbackIcon(ServiceModel service) {
    return Center(
      child: Icon(
        service.icon ?? Icons.miscellaneous_services,
        size: getResponsiveValue(32, 36, 40),
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildServiceContent(ServiceModel service) {
    return Padding(
      padding: EdgeInsets.all(getResponsiveValue(10, 12, 14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.title,
            style: config.cardTitleStyle ?? TextStyle(
              fontSize: getResponsiveValue(13, 14, 15),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: getResponsiveValue(3, 4, 5)),
          Expanded(
            child: Text(
              service.description,
              style: config.cardDescriptionStyle ?? TextStyle(
                fontSize: getResponsiveValue(10, 11, 12),
                color: Colors.grey[600],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (config.showBookButton) ...[
            SizedBox(height: getResponsiveValue(6, 8, 10)),
            _buildBookButton(service),
          ],
        ],
      ),
    );
  }

  Widget _buildBookButton(ServiceModel service) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          service.onBook?.call();
          onBookService?.call();
        },
        style: config.buttonStyle ?? ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3949ab),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: getResponsiveValue(6, 8, 10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 32),
        ),
        child: Text(
          config.bookButtonText,
          style: TextStyle(
            fontSize: getResponsiveValue(11, 12, 13),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: config.cardHeight,
      padding: EdgeInsets.symmetric(horizontal: getResponsivePadding()),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: config.cardSpacing),
            child: _buildLoadingCard(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: config.cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: getResponsiveValue(120, 140, 160),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(getResponsiveValue(12, 14, 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 32,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(double horizontalPadding) {
    return Container(
      height: config.cardHeight,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.all(getResponsiveValue(24, 28, 32)),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: getResponsiveValue(40, 50, 60),
              color: Colors.red[400],
            ),
            SizedBox(height: getResponsiveValue(12, 14, 16)),
            Text(
              errorMessage ?? 'Failed to load services',
              style: TextStyle(
                fontSize: getResponsiveValue(14, 15, 16),
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: getResponsiveValue(16, 18, 20)),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double horizontalPadding) {
    return Container(
      height: config.cardHeight,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.all(getResponsiveValue(32, 36, 40)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: getResponsiveValue(40, 50, 60),
              color: Colors.grey[400],
            ),
            SizedBox(height: getResponsiveValue(12, 14, 16)),
            Text(
              'No services available',
              style: TextStyle(
                fontSize: getResponsiveValue(14, 15, 16),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Service for backend integration
class ServicesService {
  // Mock API base URL - replace with your actual API
  static const String _baseUrl = 'https://your-api.com/api';

  // Fetch services from backend
  static Future<List<ServiceModel>> fetchServices() async {
    try {
      // Replace with your actual HTTP client implementation
      // Example using http package:
      // final response = await http.get(Uri.parse('$_baseUrl/services'));
      
      // Mock implementation - replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API response parsing
      final mockData = [
        {
          'id': 'wedding',
          'title': 'Wedding Services',
          'description': 'Make your special day even more special with our wedding services.',
          'icon': 'favorite',
          'backgroundColor': 'pink',
          'imageUrl': 'https://example.com/wedding.jpg',
        },
        {
          'id': 'baptism',
          'title': 'Baptism',
          'description': 'Welcome into the grace, rejoice in your new life with Christ.',
          'icon': 'water_drop',
          'backgroundColor': 'blue',
          'imageUrl': 'https://example.com/baptism.jpg',
        },
        {
          'id': 'funeral',
          'title': 'Funerals',
          'description': 'Commemorate a beautiful life told in prayer and song.',
          'icon': 'local_florist',
          'backgroundColor': 'grey',
          'imageUrl': 'https://example.com/funeral.jpg',
        },
        {
          'id': 'youth',
          'title': 'Youth',
          'description': 'Ignite your faith, where passion, purpose, and prayer collide.',
          'icon': 'group',
          'backgroundColor': 'orange',
          'imageUrl': 'https://example.com/youth.jpg',
        },
        {
          'id': 'outreach',
          'title': 'Outreach',
          'description': 'Spreading hope and kindness, guided by faith and love.',
          'icon': 'volunteer_activism',
          'backgroundColor': 'green',
          'imageUrl': 'https://example.com/outreach.jpg',
        },
      ];
      
      return mockData.map((json) => ServiceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  // Book a service
  static Future<bool> bookService(String serviceId) async {
    try {
      // Replace with your actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success response
      return true;
    } catch (e) {
      throw Exception('Failed to book service: $e');
    }
  }
}

// Example usage with state management
class ServicesExample extends StatefulWidget {
  const ServicesExample({super.key});

  @override
  State<ServicesExample> createState() => _ServicesExampleState();
}

class _ServicesExampleState extends State<ServicesExample> {
  List<ServiceModel> services = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedServices = await ServicesService.fetchServices();
      setState(() {
        services = fetchedServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _bookService(String serviceId) async {
    try {
      final success = await ServicesService.bookService(serviceId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service booked successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book service: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Services(
      getResponsiveValue: (mobile, tablet, desktop) {
        // Implement your responsive logic here
        final width = MediaQuery.of(context).size.width;
        if (width < 600) return mobile;
        if (width < 1200) return tablet;
        return desktop;
      },
      getResponsivePadding: () {
        // Implement your responsive padding logic here
        final width = MediaQuery.of(context).size.width;
        if (width < 600) return 16.0;
        if (width < 1200) return 24.0;
        return 32.0;
      },
      services: services,
      config: const ServicesConfig(
        sectionTitle: 'Our Services',
        cardWidth: 200.0,
        cardHeight: 280.0,
        cardSpacing: 16.0,
        bookButtonText: 'Book Now',
        maxServices: 10,
      ),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRetry: _loadServices,
      onBookService: () => print('General booking callback'),
      onServiceTap: (service) => print('Service tapped: ${service.title}'),
    );
  }
}
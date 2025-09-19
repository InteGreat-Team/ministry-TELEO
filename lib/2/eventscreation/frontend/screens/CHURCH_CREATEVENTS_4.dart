import 'package:flutter/material.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../screens/CHURCH_CREATEVENTS_5.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';

class EventMapScreen extends StatefulWidget {
  final Event event;

  const EventMapScreen({super.key, required this.event});

  @override
  State<EventMapScreen> createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  late EventMapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventMapViewModel();
    _viewModel.initializeFromEvent(widget.event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context),
        title: '',
      ),
      body: Column(
        children: [
          // Map Area (Placeholder for now)
          Expanded(
            child: Stack(
              children: [
                // Map Placeholder
                Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Map will be integrated here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Search Bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _viewModel.searchController,
                      decoration: InputDecoration(
                        hintText: 'Select Location',
                        prefixIcon: const Icon(Icons.menu),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            _viewModel.toggleSearch();
                            setState(() {});
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onTap: () {
                        _viewModel.setSearching(true);
                        setState(() {});
                      },
                    ),
                  ),
                ),

                // Search Results
                if (_viewModel.model.isSearching)
                  Positioned(
                    top: 70,
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _viewModel.model.recentLocations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              _viewModel.getLocationIcon(index),
                              color: _viewModel.getLocationIconColor(index),
                            ),
                            title:
                                Text(_viewModel.model.recentLocations[index]),
                            onTap: () {
                              _viewModel.selectLocation(
                                  _viewModel.model.recentLocations[index]);
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),

                // Location Pin
                if (!_viewModel.model.isSearching)
                  const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 2, 17, 91),
                        size: 40,
                      ),
                    ),
                  ),

                // Venue Info Card
                if (!_viewModel.model.isSearching)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Venue Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_viewModel.model.venueName),
                          const SizedBox(height: 4),
                          Text(_viewModel.model.distance),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                _viewModel.saveVenueToEvent(widget.event);
                                _viewModel.navigateToSummary(
                                    context, widget.event);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A0A4A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Choose this location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
// keeping a single import
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';

class EventApiErrorViewModel {
  final EventApiErrorModel errorModel = const EventApiErrorModel();

  void navigateBack(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class EventApiErrorScreen extends StatefulWidget {
  final Event event;

  const EventApiErrorScreen({super.key, required this.event});

  @override
  State<EventApiErrorScreen> createState() => _EventApiErrorScreenState();
}

class _EventApiErrorScreenState extends State<EventApiErrorScreen> {
  late EventApiErrorViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventApiErrorViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => _viewModel.navigateBack(context),
        title: '',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _viewModel.errorModel.errorIcon,
                size: _viewModel.errorModel.iconSize,
                color: _viewModel.errorModel.iconColor,
              ),
              const SizedBox(height: 24),
              Text(
                _viewModel.errorModel.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _viewModel.errorModel.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _viewModel.navigateBack(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _viewModel.errorModel.buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _viewModel.errorModel.buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2, // Set to the correct index for Events
        onTap: (index) {
          // Add navigation logic if needed
        },
      ),
    );
  }
}

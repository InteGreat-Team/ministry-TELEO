import 'package:flutter/material.dart';
import '../../../c2eventscreation/widgets/step_indicator.dart';
import '../../../c2eventscreation/widgets/required_asterisk.dart';
import '../../../c2eventscreation/widgets/event_app_bar.dart';
import 'package:teleo_organized_new/1/c1homepage/nav_bar.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';
import '../screens/CHURCH_CREATEVENTS_7.dart'; // EventInviteScreen

class ConsentFormScreen extends StatefulWidget {
  final String title;
  final String content;
  final Function(bool) onAccept;
  final Event event;

  const ConsentFormScreen({
    super.key,
    required this.title,
    required this.content,
    required this.onAccept,
    required this.event,
  });

  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  late ConsentFormViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ConsentFormViewModel();
    _viewModel.initializeFromEvent(widget.event, widget.content);
    _scrollController.addListener(_scrollListener);

    // Post-frame: detect if content is scrollable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.detectScrollability(_scrollController);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    _viewModel.handleScrollListener(_scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: EventAppBar(
            onBackPressed: () => Navigator.pop(context),
            title: widget.title,
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _viewModel.model.pageTitle,
                        style: TextStyle(
                          color: _viewModel.model.titleColor,
                          fontSize: _viewModel.model.titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _viewModel.model.subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.content,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_viewModel.model.isScrollable &&
                          !_viewModel.model.hasScrolledToBottom)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _viewModel.model.scrollPromptText,
                            style: TextStyle(
                              color: _viewModel.model.warningColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Checkbox(
                            value: _viewModel.model.hasAccepted,
                            onChanged: (value) =>
                                _viewModel.toggleAccept(value, context),
                            activeColor: _viewModel.model.primaryColor,
                          ),
                          Expanded(
                            child: Text(
                              _viewModel.model.checkboxText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _viewModel.model.primaryColor,
                          side:
                              BorderSide(color: _viewModel.model.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _viewModel.model.cancelButtonText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _viewModel.model.hasAccepted
                            ? () => _viewModel.handleComplete(
                                context, widget.onAccept, widget.event)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _viewModel.model.primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _viewModel.model.acceptButtonText,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//CHURCH_CREATEEVENTS_10.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'models/event.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'services/event_service.dart';
import 'CREATE_EVENTS_VAR.dart';
import 'CREATE_EVENTS_FUNC.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventDetailsViewModel _viewModel;
  late EventDetailsVariables _variables;

  @override
  void initState() {
    super.initState();
    _variables = EventDetailsVariables(event: widget.event);
    _viewModel = EventDetailsViewModel(_variables);
    
    // Save the event to the EventService if not already saved
    _viewModel.saveEventToService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.initializeDependencies(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        // Get MediaQuery in build method, not as a class field
        final mediaQuery = MediaQuery.of(context);
        final topPadding = mediaQuery.padding.top;

        return Scaffold(
          body: Stack(
            children: [
              // Main scrollable content
              CustomScrollView(
                slivers: [
                  // Event Image at the top
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        // Event Image
                        _buildEventImage(),

                        // Back Button
                        Positioned(
                          top: topPadding + 10,
                          left: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),

                        // Likes Button at top right
                        Positioned(
                          top: topPadding + 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: InkWell(
                              onTap: () => _viewModel.toggleLike(context),
                              child: Row(
                                children: [
                                  Icon(
                                    _viewModel.variables.hasLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _viewModel.variables.hasLiked ? Colors.red : _viewModel.variables.navyBlue,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${EventDetailsConstants.likesText}${_viewModel.variables.likeCount}',
                                    style: TextStyle(
                                      color: _viewModel.variables.navyBlue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content below the image
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Title
                            const SizedBox(height: 8),
                            Text(
                              widget.event.title ?? EventDetailsConstants.untitledEventText,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Organization name
                            Text(
                              EventDetailsConstants.organizationName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Event tags
                            if (widget.event.tags.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                children: widget.event.tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 16),

                            // Date Container
                            _buildInfoContainer(
                              backgroundColor: const Color(0xFFFEEBEB),
                              leading: Container(
                                width: 50,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: _viewModel.variables.navyBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.event.startDate != null
                                          ? _viewModel.variables.monthFormatter.format(widget.event.startDate!)
                                          : EventDetailsConstants.defaultMonthText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.event.startDate?.day.toString() ?? EventDetailsConstants.defaultDayText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              title: _viewModel.variables.formattedStartDate ?? EventDetailsConstants.defaultDateText,
                              subtitle: '${_viewModel.variables.formattedStartTime ?? EventDetailsConstants.defaultTimeText} - ${_viewModel.variables.formattedEndTime ?? EventDetailsConstants.defaultEndTimeText}',
                            ),

                            // Location Container
                            _buildInfoContainer(
                              backgroundColor: const Color(0xFFFFFBE6),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                              ),
                              title: widget.event.isOnline
                                  ? EventDetailsConstants.onlineEventText
                                  : (widget.event.venueName ?? EventDetailsConstants.defaultLocationText),
                              subtitle: widget.event.isOnline
                                  ? (widget.event.eventLink ?? EventDetailsConstants.noLinkProvidedText)
                                  : (widget.event.venueName ?? EventDetailsConstants.defaultLocationText),
                              subtitleColor: Colors.blue,
                            ),

                            // Contact Information Container
                            _buildInfoContainer(
                              backgroundColor: const Color(0xFFE6F4FF),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              title: EventDetailsConstants.contactInfoTitle,
                              subtitle: widget.event.contactInfo ?? EventDetailsConstants.defaultContactInfo2,
                            ),

                            const SizedBox(height: 16),
                            const Divider(),

                            // About Event Section
                            _buildSectionTitle(EventDetailsConstants.aboutEventTitle),

                            // Event Description with See More/Less
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.description ?? EventDetailsConstants.noDescriptionText,
                                  maxLines: _viewModel.variables.isDescriptionExpanded ? null : 3,
                                  overflow: _viewModel.variables.isDescriptionExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: _viewModel.toggleDescription,
                                  child: Text(
                                    _viewModel.variables.isDescriptionExpanded
                                        ? EventDetailsConstants.seeLessText
                                        : EventDetailsConstants.seeMoreText,
                                    style: TextStyle(
                                      color: _viewModel.variables.navyBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(),

                            // Event Details
                            _buildSectionTitle(EventDetailsConstants.eventDetailsTitle),
                            const SizedBox(height: 16),

                            // Simplified event details
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column - Organizers and Participants
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        EventDetailsConstants.organizersTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0A0A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        EventDetailsConstants.organizationName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        EventDetailsConstants.specialThanksText,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      Text(
                                        widget.event.contactInfo ?? EventDetailsConstants.defaultContactInfo,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        EventDetailsConstants.participantsTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0A0A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildParticipantsList(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Right column - Speakers/Guests and Dress code
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        EventDetailsConstants.speakersGuestsTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0A0A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (widget.event.speakers.isNotEmpty)
                                        ...widget.event.speakers
                                            .take(3)
                                            .map(
                                              (speaker) => Text(
                                                speaker,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            )
                                      else
                                        Text(
                                          EventDetailsConstants.noSpeakersText,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        EventDetailsConstants.dressCodeTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0A0A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.event.dressCode ?? EventDetailsConstants.notSpecifiedText,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Add extra padding at the bottom to ensure content isn't hidden behind buttons
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed overlay buttons at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Register Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _viewModel.variables.isRegistered ? Colors.grey[400] : Colors.amber,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _viewModel.variables.isRegistered ? null : _viewModel.registerForEvent,
                              borderRadius: BorderRadius.circular(25),
                              child: Center(
                                child: Text(
                                  _viewModel.variables.isRegistered 
                                      ? EventDetailsConstants.registeredText 
                                      : EventDetailsConstants.registerText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Go Home Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _viewModel.variables.navyBlue,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _viewModel.navigateToEventsTab(context),
                              borderRadius: BorderRadius.circular(25),
                              child: const Center(
                                child: Text(
                                  EventDetailsConstants.goHomeText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Chat Button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.chat_bubble_outline, color: _viewModel.variables.navyBlue),
                          onPressed: () => _viewModel.showChatFeature(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Share Button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.share, color: _viewModel.variables.navyBlue),
                          onPressed: () => _viewModel.showShareDialog(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Registration Success Notification
              if (_viewModel.variables.showRegistrationNotification)
                Positioned(
                  top: topPadding + 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            EventDetailsConstants.successfullyRegisteredText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _viewModel.dismissNotification,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Build the event image based on available sources - optimized for memory
  Widget _buildEventImage() {
    if (_viewModel.variables.isImageLoading) {
      return _buildPlaceholderImage(isLoading: true);
    }

    if (_viewModel.variables.cachedImage != null) {
      return Image(
        image: _viewModel.variables.cachedImage!,
        fit: BoxFit.cover,
        height: _viewModel.variables.screenHeight * 0.3,
        width: double.infinity,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return _buildPlaceholderImage(isLoading: true);
          }
          return child;
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
        filterQuality: FilterQuality.low,
        gaplessPlayback: true,
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  // Build a placeholder image when no image is available
  Widget _buildPlaceholderImage({bool isLoading = false}) {
    return Container(
      height: _viewModel.variables.screenHeight * 0.3,
      color: Colors.grey[300],
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                strokeWidth: 2.0,
              )
            : const Icon(Icons.image, size: 80, color: Colors.grey),
      ),
    );
  }

  // Extracted widget for event info container - reusable component
  Widget _buildInfoContainer({
    required Color backgroundColor,
    required Widget leading,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor ?? Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted widget for section title - reusable component
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Extracted widget for participant list - optimized for memory
  Widget _buildParticipantsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.event.expectedCapacity != null
                ? '${widget.event.expectedCapacity}${EventDetailsConstants.attendingText}'
                : '100${EventDetailsConstants.attendingText}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.event.inviteType == 'Open Invite')
          Text(
            EventDetailsConstants.openToEveryoneText,
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          )
        else if (widget.event.invitedChurches.isNotEmpty || widget.event.invitedGuests.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.invitedChurches.isNotEmpty) ...[
                const Text(
                  'Invited Churches:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                ...widget.event.invitedChurches
                    .take(EventDetailsConstants.maxItemsToShow)
                    .map(
                      (church) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• ${church.name}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                if (widget.event.invitedChurches.length > EventDetailsConstants.maxItemsToShow)
                  Text(
                    '+ ${widget.event.invitedChurches.length - EventDetailsConstants.maxItemsToShow} more',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
              if (widget.event.invitedGuests.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Invited Guests:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                ...widget.event.invitedGuests
                    .take(EventDetailsConstants.maxItemsToShow)
                    .map(
                      (guest) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• ${guest.fullName}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                if (widget.event.invitedGuests.length > EventDetailsConstants.maxItemsToShow)
                  Text(
                    '+ ${widget.event.invitedGuests.length - EventDetailsConstants.maxItemsToShow} more',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ],
          )
        else
          Text(
            EventDetailsConstants.noParticipantsText,
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}

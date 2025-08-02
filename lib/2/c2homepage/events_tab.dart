import 'package:flutter/material.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Hosted Events Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Hosted Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text(
                      'Create Event',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAF00),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All >',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF000233),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Showing (2/2)',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Hosted Events Cards
          _EventCard(
            title: 'Love! Live! Couples for Christ Community Night',
            assignedTo: '@Jake Sim',
            location: 'Paxton Hall, Yoshida Center',
            time: 'February 14, 2025 – 6:00 PM – 8:00 PM',
            color: Color(0xFFE8F5E9),
            borderColor: Color(0xFF4CAF50),
            assignedColor: Color(0xFF1976D2),
          ),
          const SizedBox(height: 8),
          _EventCard(
            title: 'Love! Live! Couples for Christ Community Night',
            assignedTo: '@Jake Sim',
            location: 'Paxton Hall, Yoshida Center',
            time: 'February 14, 2025 – 6:00 PM – 8:00 PM',
            color: Color(0xFFE8F5E9),
            borderColor: Color(0xFF4CAF50),
            assignedColor: Color(0xFF1976D2),
          ),
          const SizedBox(height: 24),
          // Under Review Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Events Under Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All >',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF000233),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Showing (2/5)',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _EventCard(
            title: 'Love! Live! Couples for Christ Community Night',
            assignedTo: null,
            location: 'Paxton Hall, Yoshida Center',
            time: 'February 14, 2025 – 6:00 PM – 8:00 PM',
            color: Color(0xFFF5F5F5),
            borderColor: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 8),
          _EventCard(
            title: 'Love! Live! Couples for Christ Community Night',
            assignedTo: null,
            location: 'Paxton Hall, Yoshida Center',
            time: 'February 14, 2025 – 6:00 PM – 8:00 PM',
            color: Color(0xFFF5F5F5),
            borderColor: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 24),
          // Accepted Invitations Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Accepted Invitations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All >',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF000233),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Showing (2/6)',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _AcceptedInvitationCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String? assignedTo;
  final String location;
  final String time;
  final Color color;
  final Color borderColor;
  final Color? assignedColor;
  const _EventCard({
    required this.title,
    this.assignedTo,
    required this.location,
    required this.time,
    required this.color,
    required this.borderColor,
    this.assignedColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          if (assignedTo != null)
            Row(
              children: [
                const Text(
                  'Assigned to: ',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    assignedTo!,
                    style: TextStyle(
                      fontSize: 13,
                      color: assignedColor ?? Color(0xFF1976D2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          if (assignedTo != null) const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                location,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcceptedInvitationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: Color(0xFF2196F3), width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pastor Meet and Celebration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 2,
            runSpacing: 2,
            children: const [
              Text(
                'Representatives: ',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              Text(
                '@Jake Sim',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' and 12 others',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                'Manila City Hall, M. Manila, 1003',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                'April 15, 2025 – 6:00 PM – 8:00 PM',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

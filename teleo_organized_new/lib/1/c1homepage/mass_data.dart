class Mass {
  final String title;
  final String time;
  final String location;
  final String type; // 'service', 'event', 'reading'

  Mass({
    required this.title,
    required this.time,
    required this.location,
    required this.type,
  });
}

class MassData {
  static final List<Mass> masses = [
    // Services
    Mass(
      title: 'Wedding Service',
      time: '2:00 PM',
      location: 'Main Chapel',
      type: 'service',
    ),
    Mass(
      title: 'Funeral Service',
      time: '10:00 AM',
      location: 'Main Chapel',
      type: 'service',
    ),
    Mass(
      title: 'Baptism Service',
      time: '3:00 PM',
      location: 'Main Chapel',
      type: 'service',
    ),

    // Events
    Mass(
      title: 'Celebration of Christ',
      time: '6:00 PM',
      location: 'Main Hall',
      type: 'event',
    ),

    // Readings
    Mass(
      title: 'Daily Reading',
      time: '8:00 AM',
      location: 'Prayer Room',
      type: 'reading',
    ),
  ];

  static List<Mass> getServices() {
    return masses.where((mass) => mass.type == 'service').toList();
  }

  static List<Mass> getEvents() {
    return masses.where((mass) => mass.type == 'event').toList();
  }

  static List<Mass> getReadings() {
    return masses.where((mass) => mass.type == 'reading').toList();
  }
}

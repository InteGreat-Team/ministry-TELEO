import 'package:flutter/material.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _bibleReadings = [
    {
      'title': 'Daily Devotional',
      'subtitle': 'May 15, 2025',
      'verse': 'Psalm 23:1-6',
      'content': 'The LORD is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters. He restores my soul. He leads me in paths of righteousness for his name\'s sake...',
      'image': 'assets/images/devotional.jpg',
    },
    {
      'title': 'Weekly Scripture',
      'subtitle': 'Week of May 12-18',
      'verse': 'John 3:16-17',
      'content': 'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life. For God did not send his Son into the world to condemn the world, but in order that the world might be saved through him.',
      'image': 'assets/images/scripture.jpg',
    },
    {
      'title': 'Bible Study',
      'subtitle': 'The Beatitudes',
      'verse': 'Matthew 5:1-12',
      'content': 'Seeing the crowds, he went up on the mountain, and when he sat down, his disciples came to him. And he opened his mouth and taught them, saying: "Blessed are the poor in spirit, for theirs is the kingdom of heaven..."',
      'image': 'assets/images/bible_study.jpg',
    },
  ];
  
  final List<Map<String, dynamic>> _churchPublications = [
    {
      'title': 'Monthly Newsletter',
      'subtitle': 'May 2025',
      'description': 'Updates on church activities, upcoming events, and community outreach programs.',
      'image': 'assets/images/newsletter.jpg',
    },
    {
      'title': 'Sermon Notes',
      'subtitle': 'Last Sunday\'s Message',
      'description': 'Notes from Pastor\'s sermon on "Faith in Action" with key points and scripture references.',
      'image': 'assets/images/sermon_notes.jpg',
    },
    {
      'title': 'Prayer Guide',
      'subtitle': 'May 2025',
      'description': 'Monthly prayer topics and scripture references to guide your daily prayer time.',
      'image': 'assets/images/prayer_guide.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A33),
      appBar: AppBar(
        title: const Text('Reading'),
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF3E9BFF),
          tabs: const [
            Tab(text: 'Bible Readings'),
            Tab(text: 'Church Publications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Bible Readings Tab
          _buildReadingsList(_bibleReadings),
          
          // Church Publications Tab
          _buildPublicationsList(_churchPublications),
        ],
      ),
    );
  }

  Widget _buildReadingsList(List<Map<String, dynamic>> readings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        final reading = readings[index];
        return _buildReadingCard(reading);
      },
    );
  }

  Widget _buildReadingCard(Map<String, dynamic> reading) {
    return GestureDetector(
      onTap: () {
        _showReadingDetails(reading);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF002642),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reading image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                reading['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.white54,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            
            // Reading details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reading['title'],
                    style: const TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reading['subtitle'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reading['verse'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reading['content'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Read more button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showReadingDetails(reading);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3E9BFF),
                        ),
                        child: const Text('Read More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationsList(List<Map<String, dynamic>> publications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: publications.length,
      itemBuilder: (context, index) {
        final publication = publications[index];
        return _buildPublicationCard(publication);
      },
    );
  }

  Widget _buildPublicationCard(Map<String, dynamic> publication) {
    return GestureDetector(
      onTap: () {
        _showPublicationDetails(publication);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF002642),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Publication image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                publication['image'],
                height: 120,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: 100,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.description,
                      color: Colors.white54,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            
            // Publication details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication['title'],
                      style: const TextStyle(
                        color: Color(0xFF3E9BFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      publication['subtitle'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      publication['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReadingDetails(Map<String, dynamic> reading) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ReadingDetailScreen(reading: reading),
      ),
    );
  }

  void _showPublicationDetails(Map<String, dynamic> publication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PublicationDetailScreen(publication: publication),
      ),
    );
  }
}

class _ReadingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reading;
  
  const _ReadingDetailScreen({required this.reading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A33),
      appBar: AppBar(
        title: Text(reading['title']),
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reading image
            Image.asset(
              reading['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white54,
                    size: 50,
                  ),
                );
              },
            ),
            
            // Reading details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reading['subtitle'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reading['verse'],
                    style: const TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    reading['content'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Reflection questions
                  const Text(
                    'Reflection Questions',
                    style: TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReflectionQuestion('What does this passage teach us about God?'),
                  _buildReflectionQuestion('How can you apply this to your life today?'),
                  _buildReflectionQuestion('What is one action step you can take based on this reading?'),
                  
                  const SizedBox(height: 30),
                  
                  // Prayer
                  const Text(
                    'Prayer',
                    style: TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lord, help me to understand and apply Your Word to my life. Guide me in the path of righteousness and give me wisdom to follow Your teachings. Amen.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002642),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.bookmark_border, 'Save'),
              _buildActionButton(Icons.share, 'Share'),
              _buildActionButton(Icons.format_quote, 'Highlight'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReflectionQuestion(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            color: Color(0xFF3E9BFF),
            size: 10,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PublicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> publication;
  
  const _PublicationDetailScreen({required this.publication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A33),
      appBar: AppBar(
        title: Text(publication['title']),
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Publication image
            Image.asset(
              publication['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.description,
                    color: Colors.white54,
                    size: 50,
                  ),
                );
              },
            ),
            
            // Publication details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    publication['subtitle'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    publication['description'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sample content
                  const Text(
                    'In This Issue',
                    style: TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContentItem('Pastor\'s Message', 'A word of encouragement from our pastor'),
                  _buildContentItem('Upcoming Events', 'Calendar of church activities for the month'),
                  _buildContentItem('Ministry Spotlight', 'Featuring our Youth Ministry this month'),
                  _buildContentItem('Community Outreach', 'Updates on our service projects'),
                  _buildContentItem('Prayer Requests', 'Join us in praying for our community'),
                  
                  const SizedBox(height: 30),
                  
                  // Download button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Publication downloaded successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E9BFF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002642),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.bookmark_border, 'Save'),
              _buildActionButton(Icons.share, 'Share'),
              _buildActionButton(Icons.print, 'Print'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF3E9BFF),
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

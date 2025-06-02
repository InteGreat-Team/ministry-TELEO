import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SetRoleScreen extends StatefulWidget {
  const SetRoleScreen({super.key});

  @override
  State<SetRoleScreen> createState() => _SetRoleScreenState();
}

class _SetRoleScreenState extends State<SetRoleScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRole;
  String? _selectedUser;
  bool _showConfirmation = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchUser() {
    // In a real app, this would search a database
    // For now, we'll just simulate a successful search
    setState(() {
      _selectedUser = _searchController.text.isNotEmpty 
          ? _searchController.text 
          : null;
    });
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      _showConfirmation = true;
    });
  }

  void _confirmRoleAssignment(bool confirm) {
    if (confirm) {
      // In a real app, this would update the user's role in a database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Role "$_selectedRole" assigned to $_selectedUser'),
          backgroundColor: Colors.green,
        ),
      );
    }
    
    setState(() {
      _showConfirmation = false;
      _selectedRole = null;
      _selectedUser = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showConfirmation) {
      return _buildConfirmationScreen();
    }
    
    if (_selectedUser != null) {
      return _buildRoleSelectionScreen();
    }
    
    return _buildSearchScreen();
  }

  Widget _buildSearchScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Set Role',
          style: TextStyle(
            color: Color(0xFF002642),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF002642),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002642),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _searchUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Roles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002642),
              ),
            ),
            const SizedBox(height: 20),
            _buildRoleCard('Pastor', '😇'),
            const SizedBox(height: 16),
            _buildRoleCard('Leader', '😇'),
            const SizedBox(height: 16),
            _buildRoleCard('Member', '😇'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelectionScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Set Role',
          style: TextStyle(
            color: Color(0xFF002642),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF002642),
          ),
          onPressed: () {
            setState(() {
              _selectedUser = null;
              _searchController.clear();
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select role for $_selectedUser',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002642),
              ),
            ),
            const SizedBox(height: 30),
            _buildRoleCard('Pastor', '😇', onTap: () => _selectRole('Pastor')),
            const SizedBox(height: 16),
            _buildRoleCard('Leader', '😇', onTap: () => _selectRole('Leader')),
            const SizedBox(height: 16),
            _buildRoleCard('Member', '😇', onTap: () => _selectRole('Member')),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Set Role to User',
          style: TextStyle(
            color: Color(0xFF002642),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF002642),
          ),
          onPressed: () {
            setState(() {
              _showConfirmation = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you?',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _confirmRoleAssignment(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _confirmRoleAssignment(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
  }

  Widget _buildRoleCard(String role, String emoji, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              role,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002642),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

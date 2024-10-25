import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? cachedUser;
  late Future<Map<String, dynamic>> userFuture;

  @override
  void initState() {
    super.initState();
    _loadCachedUser();
    userFuture = fetchUserProfile(widget.userId);
  }

  Future<void> _loadCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_user');
    if (cachedData != null) {
      try {
        setState(() {
          cachedUser = jsonDecode(cachedData) as Map<String, dynamic>?;
        });
      } catch (e) {
        print('Error decoding cached user data: $e');
      }
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://xjwmobilemassage.com.au/app/api.php?apicall=refreshingUID'),
        body: {'id': userId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('error') &&
            data.containsKey('user')) {
          if (!data['error']) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('cached_user', jsonEncode(data['user']));
            return data['user'];
          } else {
            throw Exception(data['message'] ?? 'Unknown error');
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  void _refreshUserProfile() {
    setState(() {
      userFuture = fetchUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(userId: widget.userId),
                ),
              );
              _refreshUserProfile();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshUserProfile();
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return _buildProfileContent(user);
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(user),
          const SizedBox(height: 30),
          _buildUserInfo(user),
          const Divider(height: 40, thickness: 1.2),
          _buildQuickActions(),
          const Divider(height: 40, thickness: 1.2),
          _buildSettingsOptions(),
          const SizedBox(height: 30),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.green,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              user['user_dp']?.isNotEmpty == true
                  ? user['user_dp']
                  : 'https://via.placeholder.com/150',
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          '${user['first_name']} ${user['last_name']}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          user['email'],
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _UserInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: user['phone'] ?? 'N/A',
            ),
            const Divider(height: 20),
            _UserInfoRow(
              icon: Icons.location_on,
              label: 'Address',
              value: user['ref_code'] ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.share, color: Colors.blue),
          title: const Text('Share App'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.orange),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.purple),
          title: const Text('Notifications'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.lock, color: Colors.red),
          title: const Text('Change Password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: Colors.green),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _UserInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

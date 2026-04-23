import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  String userName = "Preethi Kilari";
  String userRole = "Flutter Developer | CS Student";

  @override
  void initState() {
    super.initState();
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
    });
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void updateProfile(String newName, String newRole) {
    setState(() {
      userName = newName;
      userRole = newRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Assignment 5 Flutter App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
        userName: userName,
        userRole: userRole,
        updateProfile: updateProfile,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final String userName;
  final String userRole;
  final Function(String, String) updateProfile;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.userName,
    required this.userRole,
    required this.updateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: isDarkMode,
                    toggleTheme: toggleTheme,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to My Flutter App!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text("Go to Profile"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userName: userName,
                        userRole: userRole,
                        updateProfile: updateProfile,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text("Contact Info"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final Function(String, String) updateProfile;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userRole,
    required this.updateProfile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    roleController = TextEditingController(text: widget.userRole);
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 62,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.userRole,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Enter Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                  labelText: "Enter Role",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Update Profile"),
                onPressed: () {
                  widget.updateProfile(
                    nameController.text,
                    roleController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully"),
                    ),
                  );

                  setState(() {});
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text("Back to Home"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Text(
              "Settings Page",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Theme preference is saved locally"),
              value: isDarkMode,
              onChanged: (value) {
                toggleTheme();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contact_mail, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Contact Information",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Email: preethi@example.com",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Role: Graduate Student",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
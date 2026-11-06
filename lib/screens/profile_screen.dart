import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/app_data_store.dart';
import '../models/student.dart';
import '../services/theme_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  StudentProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() => _isLoading = true);
    final data = await AppDataStore.instance.getStudentProfile();
    if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    }
  }

  void showEditProfileDialog() {
    if (_profile == null) return;
    final nameController = TextEditingController(text: _profile!.name);
    final emailController = TextEditingController(text: _profile!.email);
    final uniController = TextEditingController(text: _profile!.university);
    final degreeController = TextEditingController(text: _profile!.degree);
    final semesterController = TextEditingController(text: _profile!.semester);
    final formKey = GlobalKey<FormState>();
    Uint8List? selectedImage = _profile!.profileImageBytes;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Student Profile', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatefulBuilder(
                    builder: (context, setImageState) {
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: AppColors.primaryPurple,
                            backgroundImage: selectedImage == null
                                ? null
                                : MemoryImage(selectedImage!),
                            child: selectedImage == null
                                ? Text(
                                    nameController.text.isNotEmpty
                                        ? nameController.text[0].toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () async {
                                final image = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 800,
                                  imageQuality: 85,
                                );
                                if (image == null) return;
                                final bytes = await image.readAsBytes();
                                setImageState(() => selectedImage = bytes);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: uniController,
                    decoration: const InputDecoration(labelText: 'University', prefixIcon: Icon(Icons.school)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter university' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: degreeController,
                    decoration: const InputDecoration(labelText: 'Degree Program', prefixIcon: Icon(Icons.menu_book)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter degree' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: semesterController,
                    decoration: const InputDecoration(labelText: 'Semester', prefixIcon: Icon(Icons.timeline)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter semester' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final updated = _profile!.copyWith(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    university: uniController.text.trim(),
                    degree: degreeController.text.trim(),
                    semester: semesterController.text.trim(),
                    profileImageBytes: selectedImage,
                  );
                  await AppDataStore.instance.updateStudentProfile(updated);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  loadProfile();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Program 6: TabBar and TabBarView with 4 tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Personal Info'),
              Tab(icon: Icon(Icons.school), text: 'Academic Info'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              Tab(icon: Icon(Icons.info), text: 'About'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'profile-avatar', // Program 3: Hero animation tag matching Home Dashboard
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryPurple,
                          backgroundImage: _profile?.profileImageBytes == null
                              ? null
                              : MemoryImage(_profile!.profileImageBytes!),
                          child: _profile?.profileImageBytes == null
                              ? Text(
                                  _profile?.name.isNotEmpty == true
                                      ? _profile!.name[0].toUpperCase()
                                      : 'S',
                                  style: const TextStyle(
                                    fontSize: 42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: IconButton(
                              onPressed: showEditProfileDialog,
                              icon: const Icon(Icons.camera_alt, size: 18),
                              color: AppColors.primaryPurple,
                              tooltip: 'Change profile picture',
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _profile?.name ?? 'Alex Johnson',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _profile?.email ?? 'alex.johnson@university.edu',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: showEditProfileDialog,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Personal Info
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person, color: AppColors.primaryPurple),
                                  title: const Text('Full Name'),
                                  subtitle: Text(_profile?.name ?? 'Alex Johnson'),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.email, color: AppColors.primaryPurple),
                                  title: const Text('Email Address'),
                                  subtitle: Text(_profile?.email ?? 'alex.johnson@university.edu'),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.badge, color: AppColors.primaryPurple),
                                  title: const Text('Student ID'),
                                  subtitle: const Text('STU-2026-8841'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Tab 2: Academic Info
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.account_balance, color: AppColors.primaryBlue),
                                  title: const Text('University'),
                                  subtitle: Text(_profile?.university ?? 'State University'),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.book, color: AppColors.primaryBlue),
                                  title: const Text('Degree Program'),
                                  subtitle: Text(_profile?.degree ?? 'Computer Science'),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.timeline, color: AppColors.primaryBlue),
                                  title: const Text('Current Semester'),
                                  subtitle: Text(_profile?.semester ?? 'Semester 5'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Tab 3: Settings
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              children: [
                                ValueListenableBuilder<ThemeMode>(
                                  valueListenable: ThemeService.instance.themeModeNotifier,
                                  builder: (context, mode, child) {
                                    final isDark = mode == ThemeMode.dark;
                                    return SwitchListTile(
                                      secondary: const Icon(Icons.dark_mode, color: AppColors.accentCyan),
                                      title: const Text('Dark Theme'),
                                      value: isDark,
                                      onChanged: (val) {
                                        ThemeService.instance.toggleTheme(val);
                                      },
                                    );
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.tune, color: AppColors.accentCyan),
                                  title: const Text('Select Active Name'),
                                  subtitle: const Text('Test returning data from Select Name screen'),
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(context, AppRoutes.selectName);
                                    if (result != null && result is String) {
                                      if (_profile != null) {
                                        final updated = _profile!.copyWith(name: result);
                                        await AppDataStore.instance.updateStudentProfile(updated);
                                        loadProfile();
                                      }
                                    }
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.restore, color: Colors.red),
                                  title: const Text('Reset Application Data'),
                                  subtitle: const Text('Restore database to sample initial state'),
                                  onTap: () async {
                                    await AppDataStore.instance.resetAllData();
                                    loadProfile();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Database reset to sample state!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Tab 4: About
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Student Life Organizer App',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Built with Flutter and Material Design 3.'),
                                  SizedBox(height: 12),
                                  Text(
                                    'Features integrated: Splash, Hero animations, TabBars, Side Navigation Drawer, Floating Action quick-add, named routes, and in-memory data management.',
                                    style: TextStyle(color: Colors.grey, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
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
}

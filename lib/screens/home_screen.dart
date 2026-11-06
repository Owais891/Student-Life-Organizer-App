import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/app_data_store.dart';
import '../models/birthday.dart';
import '../models/gratitude.dart';
import '../models/reminder.dart';
import '../models/student.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/dashboard_card.dart';
import 'birthday_screen.dart';
import 'gratitude_screen.dart';
import 'reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final GlobalKey<BirthdayScreenState> _birthdayKey = GlobalKey<BirthdayScreenState>();
  final GlobalKey<GratitudeScreenState> _gratitudeKey = GlobalKey<GratitudeScreenState>();
  final GlobalKey<ReminderScreenState> _reminderKey = GlobalKey<ReminderScreenState>();

  StudentProfile? _profile;
  List<Birthday> _birthdays = [];
  List<Gratitude> _gratitudes = [];
  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await AppDataStore.instance.getStudentProfile();
      final birthdays = await AppDataStore.instance.getBirthdays();
      final gratitudes = await AppDataStore.instance.getGratitudes();
      final reminders = await AppDataStore.instance.getReminders();

      if (mounted) {
        setState(() {
          _profile = profile;
          _birthdays = birthdays;
          _gratitudes = gratitudes;
          _reminders = reminders;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _profile = StudentProfile(
          name: 'Alex Johnson',
          email: 'alex.johnson@university.edu',
          university: 'State University',
          degree: 'Computer Science',
          semester: 'Semester 5',
        );
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data could not be loaded. Showing default information.')),
      );
    }
  }

  int get _pendingRemindersCount => _reminders.where((r) => !r.isCompleted).length;
  int get _completedRemindersCount => _reminders.where((r) => r.isCompleted).length;

  Widget _buildDashboardView() {
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    final studentName = _profile?.name ?? 'Student';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Welcome Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AppColors.primaryGradient,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Welcome Back,\n$studentName!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: _showEditNameDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_horiz, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Change Name',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Program 3: Hero animation profile avatar
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile).then((_) => _loadDashboardData());
                    },
                    child: Hero(
                      tag: 'profile-avatar',
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        backgroundImage: _profile?.profileImageBytes == null
                            ? null
                            : MemoryImage(_profile!.profileImageBytes!),
                        child: _profile?.profileImageBytes == null
                            ? Text(
                                studentName.isNotEmpty
                                    ? studentName[0].toUpperCase()
                                    : 'S',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Activity Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 2x2 Grid Summary Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              DashboardCard(
                title: 'Birthdays',
                count: '${_birthdays.length}',
                icon: Icons.cake,
                color: AppColors.secondaryPurple,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              DashboardCard(
                title: 'Pending Tasks',
                count: '$_pendingRemindersCount',
                icon: Icons.alarm,
                color: AppColors.primaryBlue,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              DashboardCard(
                title: 'Gratitude Notes',
                count: '${_gratitudes.length}',
                icon: Icons.auto_awesome,
                color: AppColors.accentCyan,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              DashboardCard(
                title: 'Completed Tasks',
                count: '$_completedRemindersCount',
                icon: Icons.task_alt,
                color: AppColors.priorityLow,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Upcoming Birthdays Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Birthdays',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _birthdays.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No upcoming birthdays recorded.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _birthdays.length,
                    itemBuilder: (context, index) {
                      final item = _birthdays[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          color: AppColors.secondaryPurple.withOpacity(0.12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.relationship,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.date,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 24),

          // Today's Reminders Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Reminders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 3),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _reminders.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No pending reminders.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _reminders.length > 3 ? 3 : _reminders.length,
                  itemBuilder: (context, index) {
                    final item = _reminders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isCompleted,
                          onChanged: (val) async {
                            await AppDataStore.instance.toggleReminderCompletion(item.id!, item.isCompleted);
                            _loadDashboardData();
                          },
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text('${item.date} at ${item.time} • Priority: ${item.priority}'),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Student Life Organizer';
      case 1:
        return 'Birthdays Manager';
      case 2:
        return 'Gratitude Journal';
      case 3:
        return 'Task Reminders';
      default:
        return 'Student Life Organizer';
    }
  }

  Future<void> _showEditNameDialog() async {
    final nameController =
        TextEditingController(text: _profile?.name ?? 'Alex Johnson');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Edit your name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Display name',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: AppColors.primaryPurple.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pop(dialogContext, value.trim());
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final value = nameController.text.trim();
                Navigator.pop(dialogContext, value.isEmpty ? null : value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == null || !mounted || _profile == null) return;
    final updated = _profile!.copyWith(name: result);
    await AppDataStore.instance.updateStudentProfile(updated);
    await _loadDashboardData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Name changed to $result')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _isLoading ? const Center(child: CircularProgressIndicator()) : _buildDashboardView(),
      BirthdayScreen(key: _birthdayKey),
      GratitudeScreen(key: _gratitudeKey),
      ReminderScreen(key: _reminderKey),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: _getAppBarTitle()),
      drawer: AppDrawer(
        profile: _profile,
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
          _loadDashboardData();
        },
      ),
      body: pages[_currentIndex],
      // Program 4: BottomNavigationBar with StatefulWidget & setState
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _loadDashboardData();
        },
      ),
      // Program 5: BottomAppBar & FloatingActionButton with Quick Add bottom sheet
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-quick-add',
        onPressed: () {
          // Open Quick Add Modal
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (ctx) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quick Add Item',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.secondaryPurple,
                        child: Icon(Icons.cake, color: Colors.white),
                      ),
                      title: const Text('Add Birthday'),
                      subtitle: const Text('Save friend & family birth dates'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 1);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _birthdayKey.currentState?.showAddOrEditDialog();
                        });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.accentCyan,
                        child: Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                      title: const Text('Add Gratitude Note'),
                      subtitle: const Text('Record a daily thankful moment'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 2);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _gratitudeKey.currentState?.showAddOrEditDialog();
                        });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: Icon(Icons.alarm, color: Colors.white),
                      ),
                      title: const Text('Add Reminder'),
                      subtitle: const Text('Set academic tasks & alerts'),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 3);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _reminderKey.currentState?.showAddOrEditDialog();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}

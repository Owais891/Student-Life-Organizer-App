import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/app_data_store.dart';
import '../models/reminder.dart';
import '../utils/app_colors.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => ReminderScreenState();
}

class ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> _reminders = [];
  bool _isLoading = true;
  String _filter = 'All'; // 'All', 'Pending', 'Completed'

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    setState(() => _isLoading = true);
    final data = await AppDataStore.instance.getReminders();
    if (mounted) {
      setState(() {
        _reminders = data;
        _isLoading = false;
      });
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return AppColors.priorityMedium;
    }
  }

  void showAddOrEditDialog([Reminder? reminder]) {
    final titleController = TextEditingController(text: reminder?.title ?? '');
    final descController = TextEditingController(text: reminder?.description ?? '');
    
    DateTime selectedDate = reminder != null && reminder.date.isNotEmpty
        ? DateTime.tryParse(reminder.date) ?? DateTime.now()
        : DateTime.now();
    TimeOfDay selectedTime = reminder != null && reminder.time.isNotEmpty
        ? TimeOfDay(
            hour: int.parse(reminder.time.split(':')[0]),
            minute: int.parse(reminder.time.split(':')[1]),
          )
        : TimeOfDay.now();

    final dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedDate));
    final timeController = TextEditingController(
      text: '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
    );

    String selectedPriority = reminder?.priority ?? 'Medium';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                reminder == null ? 'Add Reminder' : 'Edit Reminder',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  selectedDate = picked;
                                  setDialogState(() {
                                    dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: timeController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
                                  selectedTime = picked;
                                  setDialogState(() {
                                    timeController.text =
                                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority Level',
                          prefixIcon: Icon(Icons.flag),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'High', child: Text('High Priority')),
                          DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
                          DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedPriority = val;
                            });
                          }
                        },
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
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newReminder = Reminder(
                        id: reminder?.id,
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        date: dateController.text,
                        time: timeController.text,
                        priority: selectedPriority,
                        isCompleted: reminder?.isCompleted ?? false,
                      );

                      if (reminder == null) {
                        await AppDataStore.instance.insertReminder(newReminder);
                        if (!ctx.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reminder created!')),
                        );
                      } else {
                        await AppDataStore.instance.updateReminder(newReminder);
                        if (!ctx.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reminder updated!')),
                        );
                      }

                      Navigator.pop(ctx);
                      loadReminders();
                    }
                  },
                  child: Text(reminder == null ? 'Save' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteReminder(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await AppDataStore.instance.deleteReminder(id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              loadReminders();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Reminder> get filteredReminders {
    if (_filter == 'Pending') {
      return _reminders.where((r) => !r.isCompleted).toList();
    } else if (_filter == 'Completed') {
      return _reminders.where((r) => r.isCompleted).toList();
    }
    return _reminders;
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredReminders;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((tab) {
                final isSelected = _filter == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filter = tab;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.alarm_off_outlined, size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No $_filter reminders found!',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => showAddOrEditDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Reminder'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          final priorityColor = getPriorityColor(item.priority);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: item.isCompleted,
                                    activeColor: AppColors.primaryPurple,
                                    onChanged: (val) async {
                                      await AppDataStore.instance.toggleReminderCompletion(item.id!, item.isCompleted);
                                      loadReminders();
                                    },
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: priorityColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: priorityColor),
                                              ),
                                              child: Text(
                                                item.priority,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: priorityColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${item.date} at ${item.time}',
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        onPressed: () => showAddOrEditDialog(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _deleteReminder(item.id!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-reminder',
        onPressed: () => showAddOrEditDialog(),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

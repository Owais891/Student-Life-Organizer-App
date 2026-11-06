import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/app_data_store.dart';
import '../models/birthday.dart';
import '../utils/app_colors.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => BirthdayScreenState();
}

class BirthdayScreenState extends State<BirthdayScreen> {
  List<Birthday> _birthdays = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  Future<void> loadBirthdays() async {
    setState(() => _isLoading = true);
    final data = await AppDataStore.instance.getBirthdays();
    if (mounted) {
      setState(() {
        _birthdays = data;
        _isLoading = false;
      });
    }
  }

  void showAddOrEditDialog([Birthday? birthday]) {
    final nameController = TextEditingController(text: birthday?.name ?? '');
    final relationshipController = TextEditingController(text: birthday?.relationship ?? 'Friend');
    DateTime selectedDate = birthday != null && birthday.date.isNotEmpty
        ? DateTime.tryParse(birthday.date) ?? DateTime.now()
        : DateTime.now();
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                birthday == null ? 'Add Birthday' : 'Edit Birthday',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Person Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter a name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: relationshipController,
                        decoration: const InputDecoration(
                          labelText: 'Relationship / Description',
                          prefixIcon: Icon(Icons.people),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter relationship' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
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
                      final newBirthday = Birthday(
                        id: birthday?.id,
                        name: nameController.text.trim(),
                        relationship: relationshipController.text.trim(),
                        date: dateController.text,
                      );

                      if (birthday == null) {
                        await AppDataStore.instance.insertBirthday(newBirthday);
                        if (!ctx.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Birthday added successfully!')),
                        );
                      } else {
                        await AppDataStore.instance.updateBirthday(newBirthday);
                        if (!ctx.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Birthday updated successfully!')),
                        );
                      }

                      Navigator.pop(ctx);
                      loadBirthdays();
                    }
                  },
                  child: Text(birthday == null ? 'Save' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteBirthday(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: const Text('Are you sure you want to delete this birthday?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await AppDataStore.instance.deleteBirthday(id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              loadBirthdays();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Birthday deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _birthdays.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake_outlined, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No birthdays added yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => showAddOrEditDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Birthday'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _birthdays.length,
                  itemBuilder: (context, index) {
                    final item = _birthdays[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.secondaryPurple,
                          radius: 24,
                          child: Icon(Icons.cake, color: Colors.white),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${item.relationship} • DOB: ${item.date}',
                          style: const TextStyle(height: 1.3),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showAddOrEditDialog(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBirthday(item.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-birthday',
        onPressed: () => showAddOrEditDialog(),
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/app_data_store.dart';
import '../models/gratitude.dart';
import '../utils/app_colors.dart';

class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({Key? key}) : super(key: key);

  @override
  State<GratitudeScreen> createState() => GratitudeScreenState();
}

class GratitudeScreenState extends State<GratitudeScreen> {
  List<Gratitude> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGratitude();
  }

  Future<void> loadGratitude() async {
    setState(() => _isLoading = true);
    final data = await AppDataStore.instance.getGratitudes();
    if (mounted) {
      setState(() {
        _entries = data;
        _isLoading = false;
      });
    }
  }

  void showAddOrEditDialog([Gratitude? entry]) {
    final titleController = TextEditingController(text: entry?.title ?? '');
    final descController = TextEditingController(text: entry?.description ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            entry == null ? 'Add Gratitude Note' : 'Edit Gratitude Note',
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
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'What are you thankful for?',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter description' : null,
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
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final nowStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final newEntry = Gratitude(
                    id: entry?.id,
                    title: titleController.text.trim(),
                    description: descController.text.trim(),
                    createdAt: entry?.createdAt ?? nowStr,
                  );

                  if (entry == null) {
                    await AppDataStore.instance.insertGratitude(newEntry);
                    if (!ctx.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gratitude note saved!')),
                    );
                  } else {
                    await AppDataStore.instance.updateGratitude(newEntry);
                    if (!ctx.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gratitude note updated!')),
                    );
                  }

                  Navigator.pop(ctx);
                  loadGratitude();
                }
              },
              child: Text(entry == null ? 'Save' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this gratitude note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await AppDataStore.instance.deleteGratitude(id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              loadGratitude();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry deleted')),
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withOpacity(0.15),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.accentCyan),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"Be thankful for every little thing."',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome_outlined, size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'No gratitude notes yet!',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => showAddOrEditDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Entry'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final item = _entries[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                            onPressed: () => showAddOrEditDialog(item),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                            onPressed: () => _deleteEntry(item.id!),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.description,
                                    style: const TextStyle(fontSize: 14, height: 1.3),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Chip(
                                      avatar: const Icon(Icons.access_time, size: 14),
                                      label: Text(
                                        item.createdAt,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.grey.withOpacity(0.15),
                                    ),
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
        heroTag: 'fab-gratitude',
        onPressed: () => showAddOrEditDialog(),
        backgroundColor: AppColors.accentCyan,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

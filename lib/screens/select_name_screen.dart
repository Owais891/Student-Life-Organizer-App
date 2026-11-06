import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SelectNameScreen extends StatelessWidget {
  const SelectNameScreen({Key? key}) : super(key: key);

  static const List<String> studentNames = [
    'Alex Johnson',
    'Sophia Martinez',
    'Liam Smith',
    'Emma Watson',
    'Noah Williams',
    'Ethan Brown',
    'Olivia Davis',
    'Lucas Miller',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Student Name'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: studentNames.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final name = studentNames[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondaryPurple,
                child: Text(
                  name[0],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: const Text('Tap to set active student profile name'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Program Bonus requirement: Navigator.pop(context, selectedName)
                Navigator.pop(context, name);
              },
            ),
          );
        },
      ),
    );
  }
}

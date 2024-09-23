import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          ListTile(
            leading: const Checkbox(value: false, onChanged: null),
            title: const Text("Do the Dishes"),
            subtitle: const Text('13/11/2002'),
            trailing: const Icon(Icons.delete_rounded),
            tileColor: const Color.fromARGB(255, 233, 224, 248),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Checkbox(value: true, onChanged: null),
            title: const Text("Go for a walk"),
            subtitle: const Text('13/11/2002'),
            trailing: const Icon(Icons.delete_rounded),
            tileColor: const Color.fromARGB(255, 233, 224, 248),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}

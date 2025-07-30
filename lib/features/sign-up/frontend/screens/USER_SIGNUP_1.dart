import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Corrected import
import '../../backend/viewmodels/USER_SIGNUP_FUNC.dart'; // Corrected import

class PersonListView extends StatelessWidget {
  const PersonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person List')),
      body: Consumer<PersonViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.persons.length,
            itemBuilder: (context, index) {
              final person = viewModel.persons[index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text('Age: ${person.age}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => viewModel.removePerson(person),
                ),
                onTap: () => _showEditDialog(context, viewModel, person),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              final name = nameController.text;
              final age = int.tryParse(ageController.text) ?? 0;
              final person = Person(name: name, age: age);
              final viewModel = Provider.of<PersonViewModel>(context, listen: false);
              viewModel.addPerson(person);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, PersonViewModel viewModel, Person person) {
    final nameController = TextEditingController(text: person.name);
    final ageController = TextEditingController(text: person.age.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              final name = nameController.text;
              final age = int.tryParse(ageController.text) ?? 0;
              final oldPerson = person;
              final newPerson = Person(name: name, age: age);
              viewModel.updatePerson(oldPerson, newPerson);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box peopleBox;

  @override
  void initState() {
    super.initState();
    peopleBox = Hive.box("petBox");
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController vaccinatedController = TextEditingController();
  String name = '';
  String type = '';
  String breed = '';
  String age = '';
  bool vaccinated = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("Pet Adoption App"),
          centerTitle: true,
          actions: [Icon(Icons.account_circle)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addPetForm(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget? addPetForm({String? key}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Type (Dog/Cat/etc)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: breedController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Breed",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Age ",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: vaccinatedController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Vaccinated true/false",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  onPressed: () {
                    submitPetForm();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  submitPetForm({String? key}) {
    final name = nameController.text;
    final age = ageController.text;
    final breed = breedController.text;
    final type = typeController.text;
    final vaccinated = vaccinatedController.text;

    if (name.isEmpty ||
        age.isEmpty ||
        breed.isEmpty ||
        type.isEmpty ||
        vaccinated.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter all the fields")));

      if (key != null) {
        peopleBox.put(key, {
          "name": name,
          "age": age,
          "breed": breed,
          "type": type,
          "vaccinated": vaccinated,
        });
      } else {
        final newKey = DateTime.now().millisecondsSinceEpoch.toString();
        peopleBox.put(newKey, {
          "name": name,
          "age": age,
          "breed": breed,
          "type": type,
          "vaccinated": vaccinated,
        });
        nameController.clear();
        ageController.clear();
        breedController.clear();
        vaccinatedController.clear();
        typeController.clear();
        Navigator.of(context).pop();
      }
    }
  }
}

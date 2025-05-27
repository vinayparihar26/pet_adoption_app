import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_adoption_app/pet_model.dart';
import 'package:pet_adoption_app/pet_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Filter { all, dog, cat, parrot }

class _HomeScreenState extends State<HomeScreen> {
  late Box peopleBox;
  Filter selectedFilter = Filter.all;
  String sortType = 'Name';

  PetModel pets = PetModel();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  //TextEditingController vaccinatedController = TextEditingController();
  bool isVaccinated = false;

  @override
  void initState() {
    super.initState();
    peopleBox = Hive.box("petsBox");
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    typeController.dispose();
    breedController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.menu, color: Colors.white),
        title: Text("Pet Adoption App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            filterByPetType(),
            SizedBox(height: 15),
            sortBy(),
            SizedBox(height: 15),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: peopleBox.listenable(),
                builder: (context, box, widget) {
                  if (box.isEmpty) {
                    return Center(child: Text("No Pet Added Yet!"));
                  }
                  return ListView.builder(
                    //itemCount: box.length,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      //final key = box.keyAt(index).toString();
                      final pets = filteredItems[index];
                      final key = pets['key'].toString();
                      //print(dogs.toString());
                      if (pets == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 150,
                          child: GestureDetector(
                            onDoubleTap: () {
                              deleteOperation(key);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pets?["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                        Text(
                                          pets?["type"] ?? "Unknown",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          pets?["age"] ?? "Unknown",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          pets?["breed"] ?? "Unknown",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          "Vaccinated: ${pets["vaccinated"] == true ? 'Yes' : 'No'}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => addPetForm(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget? addPetForm({String? key}) {
    if (key != null) {
      final dog = peopleBox.get(key);
      if (dog != null) {
        nameController.text = dog['name'] ?? "";
        typeController.text = dog['type'] ?? "";
        breedController.text = dog['breed'] ?? "";
        ageController.text = dog['age'] ?? "";
        isVaccinated = dog['vaccinated'] ?? false;
      }
    } else {
      nameController.clear();
      typeController.clear();
      breedController.clear();
      ageController.clear();
      isVaccinated = false;
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 15,
              right: 15,
              top: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                StatefulBuilder(
                  builder: (context, setStateBottomSheet) {
                    return CheckboxListTile(
                      title: Text("Vaccinated true/false"),
                      value: isVaccinated,
                      onChanged: (bool? value) {
                        setStateBottomSheet(() {
                          isVaccinated = value ?? false;
                        });
                      },
                    );
                  },
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
                  child: Text(key != null ? "Update" : "Add"),
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

    if (name.isEmpty || age.isEmpty || breed.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter all the fields")));
    } else {
      final newKey = DateTime.now().millisecondsSinceEpoch.toString();
      peopleBox.put(newKey, {
        'name': name,
        'type': type,
        'breed': breed,
        'age': age,
        'vaccinated': isVaccinated,
      });
      nameController.clear();
      ageController.clear();
      breedController.clear();
      isVaccinated = false;
      typeController.clear();

    }
    Navigator.pop(context);
  }

  filterByPetType() {
    return Row(
      children: [
        FilterChip(
          label: Text("All"),
          onSelected: (value) {
            setState(() {
              selectedFilter = Filter.all;
            });
          },
        ),
        SizedBox(width: 10),
        FilterChip(
          label: Text("Dog"),
          onSelected: (value) {
            setState(() {
              selectedFilter = Filter.dog;
            });
          },
        ),
        SizedBox(width: 10),
        FilterChip(
          label: Text("Cat"),
          onSelected: (value) {
            setState(() {
              selectedFilter = Filter.cat;
            });
          },
        ),
        SizedBox(width: 10),
        FilterChip(
          label: Text("Parrot"),
          onSelected: (value) {
            setState(() {
              selectedFilter = Filter.parrot;
            });
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  sortBy() {
    return Row(
      children:
          ['Name', 'Age'].map((type) {
            final isSelected = sortType == type;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    sortType = type;
                  });
                },
                child: Text(type),
              ),
            );
          }).toList(),
    );
  }

  List<Map<String, dynamic>> get filteredItems {
    var box = Hive.box('petsBox');
    var allPets = box.values.map((e) => Map<String, dynamic>.from(e)).toList();

    var filtered =
        allPets.where((pet) {
          switch (selectedFilter) {
            case Filter.all:
              return true;
            case Filter.dog:
              return pet['type'].toString().toLowerCase() == 'dog';
            case Filter.cat:
              return pet['type'].toString().toLowerCase() == 'cat';
            case Filter.parrot:
              return pet['type'].toString().toLowerCase() == 'parrot';
            default:
              return true;
          }
        }).toList();

    if (sortType == 'Name') {
      filtered.sort(
        (a, b) => a['name'].toString().compareTo(b['name'].toString()),
      );
    } else {
      filtered.sort((a, b) {
        final ageA = int.tryParse(a['age'].toString()) ?? 0;
        final ageB = int.tryParse(b['age'].toString()) ?? 0;
        return ageB.compareTo(ageA);
      });
    }

    return filtered;
  }

  void deleteOperation(String key) {
    peopleBox.delete(key);
  }
}

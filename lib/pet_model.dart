import 'package:hive/hive.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 0)
class PetModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String breed;

  @HiveField(3)
  String type;

  @HiveField(4)
  bool vaccinated;

  PetModel({
     this.name='',
     this.age=0,
     this.breed='',
     this.type='',
    this.vaccinated = false,
  });
}

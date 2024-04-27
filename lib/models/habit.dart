import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'habit.g.dart';


@Collection()
class Habit{
  // habit id
  Id id = Isar.autoIncrement;

  //habit name
late String name;

//comlated days
List <DateTime> completeDays =[
  // DataTime(year,month, day),
  //DataTime(2024,1,1),
  //DataTime(2024,1,2),
];
}
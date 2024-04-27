import 'package:habbits/models/app_settings.dart';
import 'package:habbits/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;
  
  get currentHabits => null;



// Setup


// INITIALIZE- DATABASE
static Future<void> initialize() async {
final dir = await getApplicationDocumentsDirectory();
isar = await Isar.open(
[HabitSchema, AppSettingsSchema],
directory: dir.path,
);
}

//SAVE FIRST DATE OF APP STARTUP (FOR HEATMAP)
Future<void> saveFirstLaunchDate() async {
final existingSettings = await isar.appSettings.where().findFirst();
if (existingSettings== null) {
final settings = AppSettings().. firstLaunchDate = DateTime.now();
await isar.writeTxn(() => isar.appSettings.put(settings));
}
}
//GET first date of app startup for heatmap
Future<DateTime?> getFirstLaunchDate() async{
final settings = await isar.appSettings.where().findFirst();
return settings?. firstLaunchDate;
}
//   CRUDXOPERATIONS


//LIST OF HABITS

//CREATE -- ADD ANEW HABIT
Future<void> addHabit(String habitName)async{
  //creat new habit
  final newHabit = Habit()..name = habitName;

  //save to db
  await isar.writeTxn(() => isar.habits.put(newHabit));
}
// READ -- READ SAVED HABITS FROM DB
Future<void> readHabits() async{
  //fetch all hbits from db
  List<Habit> fetchedHabits = await isar.habits.where().findAll();

  //give current habits
  currentHabits.clear();
  currentHabits.addAll(fetchedHabits);

  //update UI
  notifyListeners();
}
//UPDATE CHECK HABIT ON AND OFF

// UPDATE -- EDIT HABIT NAME

//DELETE -- DELETE HABITS

}
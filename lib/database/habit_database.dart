import 'package:habbits/models/app_settings.dart';
import 'package:habbits/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
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
Future<void> updateHabitComplation(int id, bool isComplated) async{
  //find the specific habit
  final habit = await isar.habits.get(id);
//update complate status
if(habit != null){
  await isar.writeTxn(()  async{
// if habit is comlated => add the current date to the comlateDays List
if(isComplated && !habit.completeDays.contains(DateTime.now())){
  final today = DateTime.now();
  //add current date if it's not already in the list
  habit.completeDays.add(
    DateTime(
      today.year,
      today.month,
      today.day,
    ),
  );
}

// if habit isNot comlated => remove the rurrent date from the list
else{
  habit.completeDays.removeWhere((date) =>
   date.year == DateTime.now().year &&
   date.month == DateTime.now().month &&
   date.day == DateTime.now().day,
   );
}
// save the update habits back to the db
await isar.habits.put(habit);
  });
}
//re-read from db
readHabits();
}
// UPDATE -- EDIT HABIT NAME
Future<void> uodateHbitName(int id, String newName) async{
  //find specific habit
  final habit =await isar.habits.get(id);

  // edit habit name
  if(habit != null){
    // update name
    await isar.writeTxn(() async{
      habit.name = newName;
      //save update habit back ti the db
      await isar.habits.put(habit);
    });
  }
  readHabits();
}
//DELETE -- DELETE HABITS
Future<void> deleteHabit(int id)async{
  await isar.writeTxn(() async{
      await isar.habits.delete(id);
});
readHabits();
}
}
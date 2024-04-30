import 'package:flutter/material.dart';
import 'package:habbits/components/my_drawer.dart';
import 'package:habbits/database/habit_database.dart';
import 'package:habbits/models/habit.dart';
import 'package:habbits/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    //read exisiting habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }
  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Create a new habit"
          ),
        ),
        actions: [
          // Save button
          MaterialButton(onPressed: (){
            //get new habit name
            String newHabitName =textController.text;

            //save db
            context.read<HabitDatabase>().addHabit(newHabitName);

            //pop box
            Navigator.pop(context);
            //clear controller
            textController.clear();
          },
          child: const Text("save"),
          ),
          //cancel button
          MaterialButton(
            onPressed:(){
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text("Cancel"),
            )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add,
        color: Colors.black,),
      ),
      body: _buildHabitList(),
    );
  }

  //build habit list
  Widget _buildHabitList(){
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index){
        //get each indivudial habit
        final habit =currentHabits[index];
        // check if the habit is comlet4ed today
        bool  isCompletedToday = isHabitCompletedToday(habit.completedDays);

        //return habit tile UI
        return ListTile(
          title: Text(habit.name),
        );
      },
    );
  }
}

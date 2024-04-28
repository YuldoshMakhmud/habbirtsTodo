import 'package:flutter/material.dart';
import 'package:habbits/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget{
  const MyDrawer({super.key});


  @override
  Widget build(BuildContext context){
    return   Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ),
      );
  }
}
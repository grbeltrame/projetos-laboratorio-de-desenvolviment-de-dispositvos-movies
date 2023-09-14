import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // // Set up the SettingsController, which will glue user settings to multiple
  // // Flutter Widgets.
  // final settingsController = SettingsController(SettingsService());

  // // Load the user's preferred theme while the splash screen is displayed.
  // // This prevents a sudden theme change when the app is first displayed.
  // await settingsController.loadSettings();

  // // Run the app and pass in the SettingsController. The app listens to the
  // // SettingsController for changes, then passes it further down to the
  // // // SettingsView.
  // runApp(MyApp(settingsController: settingsController));

  runApp(MaterialApp(
      title: "Hello App",
      debugShowCheckedModeBanner: false,
      home: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Texto 1",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text("Texto 2"),
              Text("Texto 3"),
              ElevatedButton(
                  onPressed: () {
                    print("Clicado!");
                  },
                  child: Text("Clique Aqui")),
            ],
          ))));
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Accueil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chauffage villeurbanne',
      debugShowCheckedModeBanner: false,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Accueil(),
      },
      theme: ThemeData(
        // Define the default brightness and colors.
        // brightness: Brightness.dark,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 26.0, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

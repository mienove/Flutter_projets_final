import 'package:flutter/material.dart';
import 'taches/acceuil.dart';

void main() {
  runApp(const MesNotes());
}

class MesNotes extends StatelessWidget {
  const MesNotes({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list ',
      debugShowCheckedModeBanner: false,
      home:  const PageAccueil(),
    );
  }
}


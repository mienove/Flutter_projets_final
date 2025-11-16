import 'package:flutter/material.dart';
import 'package:projetfinalinterm/taches/connexion.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text("Mes notes", style: TextStyle(
          color: Colors.white, fontSize: 40, fontFamily: "Times New Romain"
          
        )),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        
      ),
      
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // centre verticalement
            crossAxisAlignment: CrossAxisAlignment.center, // centre horizontalement
            children: [
              const SizedBox(height: 20), 
              Image.asset(
                'assets/images/notes.jpg',
                width: 500,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),

              const Text(
                "Bienvenue dans votre To-Do List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Organisez vos tâches, libérez votre esprit.\n"
                  "Créez, planifiez et cochez vos tâches facilement.\n"
                  "Chaque tâche accomplie vous rapproche de vos objectifs.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 10),   //espace avant le bouton

              ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PageLogin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15,),
            ],
               
          ),
          
        ),
      ),

    );
    
  }
}
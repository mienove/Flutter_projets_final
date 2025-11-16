import 'package:flutter/material.dart';
import 'package:projetfinalinterm/Data/database_manager.dart';
import 'package:projetfinalinterm/taches/traitement.dart';
import 'package:projetfinalinterm/taches/inscription.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _nomutilisateurController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Vérification et connexion
  void _login(BuildContext context) async {
    String utilisateur = _nomutilisateurController.text.trim();
    String password = _passwordController.text.trim();

    // Champs vides
    if (utilisateur.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs."), backgroundColor: Colors.red),
      );
      return;
    }

    // Mot de passe trop court
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le mot de passe doit contenir au moins 8 caractères."), backgroundColor: Colors.red),
      );
      return;
    }

    // Vérifier dans la base de données
    bool ok = await Databasemanager().verifierLogin(utilisateur, password);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connexion réussie !"), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageTraitement()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nom d'utilisateur ou mot de passe incorrect."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nomutilisateurController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To do list",
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login.png',
                height: 200,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 20),

              Text(
                'Connexion',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Container(
                width: 350,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomutilisateurController,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 15),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () => _login(context),
                      child: Text(
                        'Connexion',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 10),

                    // 🔵 BOUTON CRÉER UN COMPTE
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageInscription()),
                        );
                      },
                      child: Text(
                        "Créer un compte",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

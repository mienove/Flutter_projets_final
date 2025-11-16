import 'package:flutter/material.dart';
import 'package:projetfinalinterm/Data/database_manager.dart';
import 'package:projetfinalinterm/taches/modelutilisateur.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Méthode de création de compte
  void _creerCompte() async {
    String user = _userController.text.trim();
    String pass = _passController.text.trim();

    // Vérification : champs vides
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs."), backgroundColor: Colors.red),
      );
      return;
    }

    // Vérification : mot de passe trop court
    if (pass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le mot de passe doit contenir au moins 8 caractères."), backgroundColor: Colors.red),
      );
      return;
    }

    // Vérifier si l'utilisateur existe déjà
    bool existe = await Databasemanager().utilisateurExiste(user);

    if (existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ce nom d'utilisateur existe déjà."), backgroundColor: Colors.red),
      );
      return;
    }

    // Enregistrement
    Utilisateur newUser = Utilisateur(
      nomUtilisateur: user,
      motDePasse: pass,
    );

    await Databasemanager().enregistrerUtilisateur(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compte créé avec succès !"), backgroundColor: Colors.green),
    );

    Navigator.pop(context); // Retour à login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Créer un compte",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
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
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: "Nom d'utilisateur",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 15),

                    TextField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _creerCompte,
                      child: Text(
                        "Créer le compte",
                        style: TextStyle(fontSize: 18),
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

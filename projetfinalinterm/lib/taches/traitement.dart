import 'package:flutter/material.dart';
import 'package:projetfinalinterm/taches/modeleTac.dart';
import 'package:projetfinalinterm/Data/database_manager.dart';
import 'package:projetfinalinterm/taches/acceuil.dart';
import 'package:projetfinalinterm/taches/connexion.dart';

class PageTraitement extends StatefulWidget {
  const PageTraitement({super.key});

  @override
  State<PageTraitement> createState() => _PageTraitementState();
}

class _PageTraitementState extends State<PageTraitement> {
  final TextEditingController _noteController = TextEditingController();
  final List<Notes> _notes = [];

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  void _chargerNotes() async {
    final notesFromDb = await Databasemanager().getAllNotes();
    if (!mounted) return;
    setState(() {
      _notes
        ..clear()
        ..addAll(notesFromDb);
    });
  }

  void ajoutNotes() async {
    final String texte = _noteController.text.trim();
    if (texte.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez saisir une note !'),
            backgroundColor: Colors.red),
      );
      return;
    }

    Notes note = Notes(description: texte);
    int id = await Databasemanager().addNote(note);
    note.id = id;

    if (!mounted) return;
    setState(() {
      _notes.add(note);
      _noteController.clear();
    });
  }

  void supprimerNote(Notes note) async {
    await Databasemanager().deleteNote(note.id!);
    if (!mounted) return;
    setState(() {
      _notes.remove(note);
    });
  }

  void modifierNoteDialog(Notes note) {
    _noteController.text = note.description;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier la note"),
        content: TextField(
          controller: _noteController,
          decoration: InputDecoration(hintText: "Nouvelle note"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final texte = _noteController.text.trim();
              if (texte.isEmpty) return;

              note.description = texte;
              await Databasemanager().updateNote(note);
              _chargerNotes();
              _noteController.clear();

              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text("Modifier"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------------------- APPBAR --------------------
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "To do list",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),

        // ----------- Bouton Déconnexion dans AppBar -----------
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PageLogin()),
              );
            },
          ),
        ],
      ),

      // -------------------- BODY --------------------
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Zone de saisie
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: "Ajouter une note",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: ajoutNotes,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Liste des notes
            Expanded(
              child: _notes.isEmpty
                  ? Center(
                      child: Text(
                        "Aucune note enregistrée",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(note.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () =>
                                      modifierNoteDialog(note),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => supprimerNote(note),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // -------------------- BOUTON RETOUR PAGE D’ACCUEIL --------------------
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.home),
              label: Text("Retour à l'accueil"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PageAccueil()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

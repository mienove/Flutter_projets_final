import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projetfinalinterm/taches/modeleTac.dart';
import 'package:projetfinalinterm/taches/modelutilisateur.dart';

class Databasemanager {
  static final Databasemanager _instance = Databasemanager._internal();
  factory Databasemanager() => _instance;
  Databasemanager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // INITIALISATION
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gestionsNotes.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // Table Tâches
        await db.execute('''
          CREATE TABLE taches(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT NOT NULL
          )
        ''');

        // Table Utilisateurs
        await db.execute('''
          CREATE TABLE utilisateurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nomUtilisateur TEXT UNIQUE,
            motDePasse TEXT
          )
        ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE utilisateurs(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nomUtilisateur TEXT UNIQUE,
              motDePasse TEXT
            )
          ''');
        }
      },
    );
  }

  // ---------------------------------------------------------------------
  //                GESTION DES TÂCHES
  // ---------------------------------------------------------------------
  Future<List<Notes>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('taches');
    return maps.map((n) => Notes.fromMap(n)).toList();
  }

  Future<int> addNote(Notes note) async {
    final db = await database;
    return await db.insert('taches', note.toMap());
  }

  Future<int> updateNote(Notes note) async {
    final db = await database;
    return await db.update(
      'taches',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'taches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------------------------------------------------------------
  //                GESTION DES UTILISATEURS
  // ---------------------------------------------------------------------

  // Enregistrer un nouvel utilisateur
  Future<int> enregistrerUtilisateur(Utilisateur user) async {
    final db = await database;
    return await db.insert(
      'utilisateurs',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Vérifier si un utilisateur existe déjà
  Future<bool> utilisateurExiste(String nomUtilisateur) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ?',
      whereArgs: [nomUtilisateur],
    );
    return result.isNotEmpty;
  }

  // Vérifier login → retourne TRUE ou FALSE
  Future<bool> verifierLogin(String user, String pass) async {
    final db = await database;

    List<Map<String, dynamic>> res = await db.query(
      "utilisateurs",
      where: "nomUtilisateur = ? AND motDePasse = ?",
      whereArgs: [user, pass],
    );

    return res.isNotEmpty;
  }

  // Vérifier connexion → retourne l'utilisateur complet
  Future<Utilisateur?> verifierConnexion(String user, String pass) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ? AND motDePasse = ?',
      whereArgs: [user, pass],
    );

    if (result.isNotEmpty) {
      return Utilisateur.fromMap(result.first);
    }
    return null;
  }
}



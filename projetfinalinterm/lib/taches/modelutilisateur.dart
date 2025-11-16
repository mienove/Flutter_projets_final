class Utilisateur {
  int? id;
  String nomUtilisateur;
  String motDePasse;

  Utilisateur({
    this.id,
    required this.nomUtilisateur,
    required this.motDePasse,
  });

  // Convertir un objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'motDePasse': motDePasse,
    };
  }

  // Convertir une Map SQLite en objet Utilisateur
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nomUtilisateur: map['nomUtilisateur'],
      motDePasse: map['motDePasse'],
    );
  }
}

class Notes{
   int? id;
   String description;

  Notes( {this.id, required this.description});
  
  
  Map<String, dynamic> toMap(){
    return {
      if(id != null ) 'id': id,
      'description': description,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'],
      description: map['description'],
    );
  }

}
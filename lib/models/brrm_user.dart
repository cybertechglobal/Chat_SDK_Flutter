class BrrmUser {
  String id;
  String email;
  String name;
  bool isGroupAdmin;

  BrrmUser(
      {required this.id,
      required this.email,
      required this.name,
      this.isGroupAdmin = false});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'name': name,
        'isGroupAdmin': isGroupAdmin,
      };
}

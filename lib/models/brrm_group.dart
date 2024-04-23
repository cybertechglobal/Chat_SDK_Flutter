class BrrmGroup {
  String id;
  String name;

  BrrmGroup({required this.id, required this.name});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}

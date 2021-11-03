class Response {
  final String id;
  final String name;
  final String age;

  const Response._(this.id, this.name, this.age);

  factory Response.fromJson(Map json) {
    final id = json['_id'].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final name = json['name'];
    final names = name.split(' ');
    final age = json['age'];
    return Response._(id, name, age);
  }

}
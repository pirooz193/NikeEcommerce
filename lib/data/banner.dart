class Banner {
  final int id;
  final String imageUrl;

  Banner.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['image'];
}

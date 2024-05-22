class Product {
  String title;
  String description;
  List images;

  Product({
    required this.title,
    required this.description,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'].toString(),
      description: json['description'].toString(),
      images: json['images']!! as List,
    );
  }

  Product.fromMap(Map map)
      : this.title = map["title"],
        this.description = map["description"],
        this.images = map["images"];

  Map toMap() {
    return {
      "title": this.title,
      "description": this.description,
      "images": this.images,
    };
  }
}

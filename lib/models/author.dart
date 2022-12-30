class Author {
  String name;
  String bookName;
  String imageURL;

  Author({
    required this.name,
    required this.bookName,
    required this.imageURL,
  });

  factory Author.fromMap({required Map<String, dynamic> data}) {
    return Author(
      name: data['name'],
      bookName: data['bookName'],
      imageURL: data['imageURL'],
    );
  }
}

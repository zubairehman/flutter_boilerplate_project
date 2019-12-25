class Stock {
  int id;
  String title;
  String body;

  Stock({
    this.id,
    this.title,
    this.body,
  });

  factory Stock.fromMap(Map<String, dynamic> json) => Stock(
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
      };
}

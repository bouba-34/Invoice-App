class Article {
  String description;
  double quantity;
  double unitPrice;

  Article({
    this.description = '',
    this.quantity = 0.0,
    this.unitPrice = 0.0,
  });

  double get totalHT => quantity * unitPrice;

  bool get isValid => description.isNotEmpty && quantity > 0 && unitPrice > 0;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
    );
  }

  Article copy() {
    return Article(
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
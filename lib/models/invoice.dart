import 'article.dart';

class Invoice {
  String clientName;
  String clientEmail;
  DateTime invoiceDate;
  List<Article> articles;
  static const double TVA_RATE = 0.20;

  Invoice({
    this.clientName = '',
    this.clientEmail = '',
    DateTime? invoiceDate,
    List<Article>? articles,
  }) :
        invoiceDate = invoiceDate ?? DateTime.now(),
        articles = articles ?? [];

  double get totalHT {
    return articles.fold(0.0, (sum, article) => sum + article.totalHT);
  }

  double get totalTVA {
    return totalHT * TVA_RATE;
  }

  double get totalTTC {
    return totalHT + totalTVA;
  }

  bool get isValid {
    return clientName.isNotEmpty &&
        clientEmail.isNotEmpty &&
        articles.isNotEmpty &&
        articles.every((article) => article.isValid);
  }

  int get validArticlesCount {
    return articles.where((article) => article.isValid).length;
  }
}
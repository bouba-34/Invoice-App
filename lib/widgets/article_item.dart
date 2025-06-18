import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/article.dart';
import '../utils/validators.dart';

class ArticleItem extends StatefulWidget {
  final Article article;
  final VoidCallback onArticleChanged;
  final VoidCallback? onRemove;

  const ArticleItem({
    super.key,
    required this.article,
    required this.onArticleChanged,
    this.onRemove,
  });

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _unitPriceController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.article.description);
    _quantityController = TextEditingController(
      text: widget.article.quantity > 0 ? widget.article.quantity.toString() : '',
    );
    _unitPriceController = TextEditingController(
      text: widget.article.unitPrice > 0 ? widget.article.unitPrice.toString() : '',
    );

    _descriptionController.addListener(_updateDescription);
    _quantityController.addListener(_updateQuantity);
    _unitPriceController.addListener(_updateUnitPrice);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _updateDescription() {
    widget.article.description = _descriptionController.text;
    widget.onArticleChanged();
  }

  void _updateQuantity() {
    final value = double.tryParse(_quantityController.text) ?? 0.0;
    widget.article.quantity = value;
    widget.onArticleChanged();
  }

  void _updateUnitPrice() {
    final value = double.tryParse(_unitPriceController.text) ?? 0.0;
    widget.article.unitPrice = value;
    widget.onArticleChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Article',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onRemove,
                    tooltip: 'Supprimer l\'article',
                  ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantité *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _unitPriceController,
                    decoration: InputDecoration(
                      labelText: 'Prix unitaire HT *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.euro),
                      suffixText: '€',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total HT:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    Validators.formatCurrency(widget.article.totalHT),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
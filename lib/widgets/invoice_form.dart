import 'package:flutter/material.dart';

import '../models/article.dart';
import '../models/invoice.dart';
import '../utils/validators.dart';
import 'article_item.dart';


class InvoiceForm extends StatefulWidget {
  final Invoice invoice;
  final VoidCallback onInvoiceChanged;
  final VoidCallback onAddArticle;
  final Function(int) onRemoveArticle;

  const InvoiceForm({
    super.key,
    required this.invoice,
    required this.onInvoiceChanged,
    required this.onAddArticle,
    required this.onRemoveArticle,
  });

  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _clientEmailController;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(text: widget.invoice.clientName);
    _clientEmailController = TextEditingController(text: widget.invoice.clientEmail);

    _clientNameController.addListener(_updateClientName);
    _clientEmailController.addListener(_updateClientEmail);
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  void _updateClientName() {
    widget.invoice.clientName = _clientNameController.text;
    widget.onInvoiceChanged();
  }

  void _updateClientEmail() {
    widget.invoice.clientEmail = _clientEmailController.text;
    widget.onInvoiceChanged();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.invoice.invoiceDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != widget.invoice.invoiceDate) {
      setState(() {
        widget.invoice.invoiceDate = picked;
      });
      widget.onInvoiceChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildClientSection(),
          SizedBox(height: 20),
          _buildDateSection(),
          SizedBox(height: 20),
          _buildArticlesSection(),
          SizedBox(height: 20),
          _buildTotalsSection(),
        ],
      ),
    );
  }

  Widget _buildClientSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations Client',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clientNameController,
              decoration: InputDecoration(
                labelText: 'Nom du client *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => Validators.validateRequired(value, 'Nom du client'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clientEmailController,
              decoration: InputDecoration(
                labelText: 'Email du client *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date de Facturation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date de facture',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  Validators.formatDate(widget.invoice.invoiceDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Articles (${widget.invoice.articles.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: widget.onAddArticle,
                  icon: Icon(Icons.add),
                  label: Text('Ajouter'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (widget.invoice.articles.isEmpty)
              Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Aucun article ajouté',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ...widget.invoice.articles.asMap().entries.map((entry) {
                int index = entry.key;
                Article article = entry.value;
                return ArticleItem(
                  article: article,
                  onArticleChanged: widget.onInvoiceChanged,
                  onRemove: widget.invoice.articles.length > 1
                      ? () => widget.onRemoveArticle(index)
                      : null,
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Totaux',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total HT:', style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  Validators.formatCurrency(widget.invoice.totalHT),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TVA (20%):', style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  Validators.formatCurrency(widget.invoice.totalTVA),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total TTC:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Validators.formatCurrency(widget.invoice.totalTTC),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
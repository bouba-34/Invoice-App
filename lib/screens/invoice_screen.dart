import 'package:flutter/material.dart';

import '../models/article.dart';
import '../models/invoice.dart';
import '../widgets/invoice_form.dart';
import '../widgets/invoice_preview.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Invoice _invoice;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _invoice = Invoice();
    _addInitialArticle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addInitialArticle() {
    _invoice.articles.add(Article());
  }

  void _updateInvoice() {
    setState(() {});
  }

  void _addArticle() {
    setState(() {
      _invoice.articles.add(Article());
    });
  }

  void _removeArticle(int index) {
    setState(() {
      if (_invoice.articles.length > 1) {
        _invoice.articles.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module Facturation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.edit),
              text: 'Création',
            ),
            Tab(
              icon: Icon(Icons.preview),
              text: 'Aperçu',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InvoiceForm(
            invoice: _invoice,
            onInvoiceChanged: _updateInvoice,
            onAddArticle: _addArticle,
            onRemoveArticle: _removeArticle,
          ),
          InvoicePreview(invoice: _invoice),
        ],
      ),
    );
  }
}
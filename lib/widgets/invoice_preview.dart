import 'package:flutter/material.dart';

import '../models/article.dart';
import '../models/invoice.dart';
import '../utils/validators.dart';

class InvoicePreview extends StatelessWidget {
  final Invoice invoice;

  const InvoicePreview({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        SizedBox(height: 30),
        _buildClientInfo(context),
        SizedBox(height: 30),
        _buildArticlesTable(context),
        SizedBox(height: 30),
        _buildTotals(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FACTURE',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'N° ${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Date: ${Validators.formatDate(invoice.invoiceDate)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FACTURÉ À',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            if (invoice.clientName.isNotEmpty)
              Text(
                invoice.clientName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Text(
                'Nom du client non renseigné',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            SizedBox(height: 4),
            if (invoice.clientEmail.isNotEmpty)
              Text(
                invoice.clientEmail,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              Text(
                'Email non renseigné',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTable(BuildContext context) {
    final validArticles = invoice.articles.where((a) => a.isValid).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DÉTAIL DES ARTICLES',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            if (validArticles.isEmpty)
              Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Aucun article valide',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              Table(
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                },
                children: [
                  _buildTableHeader(context),
                  ...validArticles.map((article) => _buildTableRow(context, article)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      children: [
        _buildTableHeaderCell(context, 'Description'),
        _buildTableHeaderCell(context, 'Qté'),
        _buildTableHeaderCell(context, 'P.U. HT'),
        _buildTableHeaderCell(context, 'Total HT'),
      ],
    );
  }

  Widget _buildTableHeaderCell(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, Article article) {
    return TableRow(
      children: [
        _buildTableCell(context, article.description),
        _buildTableCell(context, article.quantity.toString()),
        _buildTableCell(context, Validators.formatCurrency(article.unitPrice)),
        _buildTableCell(context, Validators.formatCurrency(article.totalHT)),
      ],
    );
  }

  Widget _buildTableCell(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTotalRow(context, 'Sous-total HT', invoice.totalHT, false),
            SizedBox(height: 12),
            _buildTotalRow(context, 'TVA (20%)', invoice.totalTVA, false),
            Divider(thickness: 2),
            SizedBox(height: 12),
            _buildTotalRow(context, 'TOTAL TTC', invoice.totalTTC, true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context, String label, double amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          Validators.formatCurrency(amount),
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          )
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
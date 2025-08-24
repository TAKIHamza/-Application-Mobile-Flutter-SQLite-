import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  final List<Map<String, Object?>> dataFromDatabase;
  final String responsibleName;
  final String quarterYear;
  late bool completed;

  PDFScreen(this.dataFromDatabase, this.responsibleName, this.quarterYear, this.completed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(
          Icons.picture_as_pdf_outlined,
          size: 70,
          color: completed ? Color.fromARGB(255, 31, 159, 106) : Colors.red,
        ),
        onPressed: () async {
          final pdf = pw.Document();

          // Ajouter une page au PDF
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // En-tête avec le logo, la date, le nom du responsable et les informations de trimestre/année
                    _buildHeader(),
                    pw.SizedBox(height: 20),
                    // Tableau avec les données du consommateur
                    _buildTable(),
                  ],
                );
              },
            ),
          );

          // Enregistrer le PDF dans le répertoire des documents de l'application
          final directory = await getExternalStorageDirectory();
          final file = File('${directory?.path}/exemple.pdf');
          await file.writeAsBytes(await pdf.save());

          // Ouvrir le fichier PDF
          OpenFile.open(file.path);
        },
      ),
    );
  }

  pw.Widget _buildHeader() {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
             pw.Text('Date: $formattedDate'),
            pw.Text('Responsable: $responsibleName'),
            pw.Text('Trimestre/Année: $quarterYear'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTable() {
    // Convertir les données de la base de données au format attendu par le tableau
    final data = dataFromDatabase.map((entry) {
      return [
        '${entry['nomConsommateur'] ?? ''} ${entry['prenomConsommateur'] ?? ''}',
        entry['zoneCompteur'] ?? '',
        entry['numeroSerieCompteur'] ?? '',
        entry['dernierReleveCompteur'] != null ? entry['dernierReleveCompteur'].toString() : '',
        entry['quantiteConsommation'] != null ? entry['quantiteConsommation'].toString() : '',
        entry['montantFacture'] != null ? entry['montantFacture'].toString() : '',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      border: pw.TableBorder.all(),
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
      },
      cellStyle: pw.TextStyle(fontSize: 12),
      headers: [
        'Nom et Prénom',
        'Zone',
        'Numéro de série du compteur',
        'Valeur du compteur',
        'Quantité consommée',
        'Prix à payer',
      ],
      data: data,
    );
  }
}

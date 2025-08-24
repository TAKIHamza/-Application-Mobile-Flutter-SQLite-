import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/widgets/confirmationDialog.dart';
import 'package:ifsan/widgets/snackbar_utils.dart';

class ConsumptionCard extends StatelessWidget {
  final Consommation consumption;
 final Function() refresh; 
  const ConsumptionCard({
    Key? key,
    required this.consumption,
    required this.refresh, // Pass delete function as a parameter
  }) : super(key: key);
Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        message: 'Voulez-vous vraiment supprimer cette consommation ?',
        onConfirm: () async {
          await _deleteConsommation(context);
        },
      );
    },
  );
}

Future<void> _deleteConsommation(BuildContext context) async {
  try {
     if (consumption.imagePath != null) {
      final imageFile = File(consumption.imagePath!);
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
    final rowsDeleted = await DatabaseProvider.db.deleteConsommation(consumption.id);
    if (rowsDeleted > 0) {
      // Show snackbar only if the context is still valid
      SnackbarUtils.showSnackbar(context, 'Consommation supprimée avec succès!', true);
      refresh(); // Call the refresh function after successful deletion
    } else {
      // Show snackbar only if the context is still valid
      SnackbarUtils.showSnackbar(context, 'Impossible de supprimer la consommation.', false);
    }
  } catch (error) {
    print('Error deleting consommation: $error');
    // Show snackbar only if the context is still valid
    SnackbarUtils.showSnackbar(context, 'Une erreur s\'est produite lors de la suppression de la consommation.', false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'T${consumption.trimestre} | ${consumption.annee}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 86, 89, 88),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Vérifiez si imagePath est null avant de l'utiliser
                    print(consumption.imagePath);
                    if (consumption.imagePath != null) {
                      _showImageDialog(context, consumption.imagePath!);
                    } else {
                      // Gérez le cas où l'image n'est pas disponible
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('L\'image n\'est pas disponible.'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.image),
                  tooltip: 'Show Image',
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[400],
          ),
          ListTile(
            title: Text("Année: ${consumption.annee}"),
            subtitle: Text("Trimestre: ${consumption.trimestre}"),
          ),
          ListTile(
            title: Text("Quantité: ${consumption.quantite}"),
            subtitle: Text("Valeur de compteur: ${consumption.valeurCompteur}"),
          ),
          ListTile(
            title: Text("ID Compteur: ${consumption.idCompteur}"),
            subtitle: Text("Valeur de compteur: ${consumption.valeurCompteur}"),
          ),
           Divider(
            height: 1,
            color: Colors.grey[400],
          ),
          IconButton(onPressed: (){_showDeleteConfirmationDialog(context);}, icon: Icon(Icons.delete_outline_outlined,color: Colors.red,))
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image'),
          content: Image.file(File(imagePath)), // Import 'dart:io' for File
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
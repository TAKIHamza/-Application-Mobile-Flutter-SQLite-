
import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/compteur.dart'; 
import 'package:ifsan/views/pageView.dart';
import 'package:ifsan/widgets/confirmationDialog.dart';
import 'package:ifsan/widgets/snackbar_utils.dart';

class CounterCard extends StatelessWidget {
    final Compteur compteur;
  final Function() refresh;

  const CounterCard({
    required this.compteur,
    required this.refresh,
  });
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous vraiment supprimer ce compteur ?',
          onConfirm: () async {
            await _deleteCompteur(context);
          },
        );
      },
    );
  }

  Future<void> _deleteCompteur(BuildContext context) async {
    try {
    final rowsDeleted = await DatabaseProvider.db.deleteCompteur(compteur.id);
    if (rowsDeleted > 0) {
        // Deletion successful
        SnackbarUtils.showSnackbar(context, 'Compteur supprimé avec succès!', true);
        refresh(); // Call the refresh function after successful deletion
      } else {
        // Deletion failed
        SnackbarUtils.showSnackbar(context, 'Échec de la suppression du compteur.', false);
      }
    } catch (error) {
      print('Error deleting compteur: $error');
      // Show snackbar for any error during deletion
      SnackbarUtils.showSnackbar(context, 'Une erreur s\'est produite lors de la suppression du compteur.', false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Passez l'objet Compteur à la page des consommations lorsqu'on appuie sur la carte
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPage(compteurId: compteur.id)),
        );
      },
      child: _buildCompteurCard(context), // Utilisez l'objet Compteur pour construire la carte
    );
  }

  Widget _buildCompteurCard(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Image.asset(
            'assets/compteurIcon.png', // URL de l'image de placeholder
            height: 70,
            width: 70,
          ),
          _buildInfoItem(Icons.fitbit_outlined, 'ID', compteur.id.toString()),
          _buildInfoItem(Icons.fitbit_outlined, 'Numero serie', compteur.numeroSerie), 
          _buildInfoItem(Icons.fitbit_outlined, 'Dernier Releve', compteur.dernierReleve), // Utilisez les propriétés de Compteur
           _buildInfoItem(Icons.fitbit_outlined, ' Date installation', compteur.dateInstallation), 
           _buildInfoItem(Icons.fitbit_outlined, 'ID consommateur', compteur.consommateurID.toString()),
          _buildInfoItem(Icons.fitbit_outlined, 'Zone', compteur.zone),
            
            IconButton(onPressed: (){_showDeleteConfirmationDialog( context);}, icon: Icon(Icons.delete_outline_outlined,color: Color.fromARGB(255, 21, 108, 163),size: 30,))
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 87, 86, 86),
                ),
              ),
            ],
          ),
          value.isEmpty
              ? IconButton(
                  icon: Icon(Icons.location_on_outlined,size: 20),
                  color: Color.fromARGB(255, 34, 60, 82),
                  onPressed: () {
                    // Gérer l'action onPressed
                  },
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 115, 121),
                  ),
                ),
        ],
      ),
    );
  }
}

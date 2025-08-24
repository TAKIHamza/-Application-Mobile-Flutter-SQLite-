
import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/compteur.dart';
import 'package:ifsan/widgets/snackbar_utils.dart';

class AddCounterPage extends StatefulWidget {
  final int consommateurID; // Pass consumer ID as a parameter
 
  const AddCounterPage({Key? key, required this.consommateurID}) : super(key: key);

  @override
  _AddCounterFormState createState() => _AddCounterFormState();
}

class _AddCounterFormState extends State<AddCounterPage> {
  final _formKey = GlobalKey<FormState>();
  late int id;
 
  String _numeroSerie = '';
  String _dateInstallation = '';
  String _dernierReleve = '';
  String _zone = '';
  @override
  void initState() {
    super.initState();
    initializeId();
  }

  Future<void> initializeId() async {
    id = await DatabaseProvider.db.getMaxId(DatabaseProvider.TABLE_NAME_COMPTEUR, 'id');
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter Compteur"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 SizedBox(height: 26),
                  Image.asset(
            'assets/compteurIcon.png', // URL de l'image de placeholder
            height: 100,
            width: 100,
          ),
           SizedBox(height: 25),
              
               
                // Serial number field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Numero serie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a serial number';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _numeroSerie = value),
                ),
                SizedBox(height: 16),
                // Installation date field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date Installation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the installation date';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _dateInstallation = value),
                ),
                SizedBox(height: 16),
                // Last reading field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Dernier Releve',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the last reading';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _dernierReleve = value),
                ),
                SizedBox(height: 16),
               
                // Zone field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Zone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the zone';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _zone = value),
                ),
                SizedBox(height: 40),
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addCounterToDatabase();
                    }
                  },
                  child: Text('Ajouter Compteur'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addCounterToDatabase() async {
    final compteur = Compteur(
      id: id,
      numeroSerie: _numeroSerie,
      dateInstallation: _dateInstallation,
      dernierReleve: _dernierReleve,
      zone: _zone,
      localisationID: 1, // Replace with actual localisation ID if needed
      consommateurID: widget.consommateurID,
    );

   final dbProvider = await DatabaseProvider.db; // Get database instance
    final result = await dbProvider.insertRecord(DatabaseProvider.TABLE_NAME_COMPTEUR, compteur.toJson());
    if (result > 0) {
      // Handle successful insertion (e.g., show success message, navigate)
      SnackbarUtils.showSnackbar(context, 'Compteur ajouter avec succès!', true);
      initializeId();
      // You can navigate to another page here
    } else {
      // Handle failed insertion (e.g., show error message)
      SnackbarUtils.showSnackbar(context, 'Erreur lors de l\'ajout du compteur!', false);
      
    }
  }
}

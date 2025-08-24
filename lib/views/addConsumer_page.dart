import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommateur.dart';
import 'package:ifsan/widgets/snackbar_utils.dart'; // Import DatabaseProvider

class AddConsumerPage extends StatefulWidget {
  @override
  _AddConsumerPageState createState() => _AddConsumerPageState();
}


class _AddConsumerPageState extends State<AddConsumerPage> {
  late int id;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _errorMessage = '';
   // Initial selected category

  

@override
  void initState() {
    super.initState();
    initializeId();
  }
Future<void> initializeId() async {
    id = await DatabaseProvider.db.getMaxId(DatabaseProvider.TABLE_NAME_CONSOMMATEUR, 'id');
    
  }

  // Handle database insertion and error checking
  void _saveConsumer() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String address = _addressController.text.trim();
    String phone = _phoneController.text.trim();

    if ( firstName.isEmpty || lastName.isEmpty || address.isEmpty || phone.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    

    // **Database Interaction:**
    final db = DatabaseProvider.db;

    // Create Consommateur object
    final consommateur = Consommateur(
      id: id,
      cni: 'cni',
      nom: lastName,
      prenom: firstName,
      adresse: address,
      telephone: phone,
     
    );

    // Insert into database
    int insertedId = await db.insertRecord(DatabaseProvider.TABLE_NAME_CONSOMMATEUR, consommateur.toJson());

    if(insertedId>0){
 SnackbarUtils.showSnackbar(context, 'Consommateur enregistré avec succès.', true);
    setState(() {
      
      _firstNameController.text = '';
      _lastNameController.text = '';
      _addressController.text = '';
      _phoneController.text = '';
      initializeId();
       
    });
     }
     else SnackbarUtils.showSnackbar(context, 'Error inserting consommateur.', false);
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Ajouter Consommateur'),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CircleAvatar for profile picture (optional)
          // ...
 CircleAvatar(
                        radius: 55,
                        backgroundColor: Color.fromARGB(255, 212, 245, 242),
                        child: Icon(
                          Icons.person,
                          size: 60, // Adjust the size as needed
                          color: Color.fromARGB(255, 37, 137, 142), // Change the color if necessary
                        ),
                      ),
                  SizedBox(height: 10.0), 
                    Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),    
          
         
          SizedBox(height: 10.0),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Nom',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'Prénom',
            ),
          ),
          SizedBox(height: 10.0),
          
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Adresse',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone, // Set keyboard type for phone number
            decoration: InputDecoration(
              labelText: 'Téléphone',
            ),
          ),
          SizedBox(height: 14.0),
          // Category Dropdown
         
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _saveConsumer,
            child: Text('Enregistrer'),
          ),
        
        ],
      ),
    ),
  );
}
}
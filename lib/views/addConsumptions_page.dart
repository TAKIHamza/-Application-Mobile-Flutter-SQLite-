import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ifsan/functions/calculateCost.dart';
import 'package:ifsan/functions/trimestre.dart';
import 'package:ifsan/models/facture.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/widgets/snackbar_utils.dart';

class AddConsumptionsPage extends StatefulWidget {
  final int idCompteur;
  final int value ;

  const AddConsumptionsPage({Key? key, required this.idCompteur,required this.value}) : super(key: key);

  @override
  _AddConsumptionsPageState createState() => _AddConsumptionsPageState();
}

class _AddConsumptionsPageState extends State<AddConsumptionsPage> {
  late DateTime now ;
  late Parametre _trimestreParam;
  late Parametre _anneeParam ;
  late Parametre _volume1Param;
  late Parametre _price1Param;
  late Parametre _volume2Param;
  late Parametre _price2Param;
  late Parametre _volume3Param;
  late Parametre _price3Param;
  late Parametre _fixedTariffParam;
  final _formKey = GlobalKey<FormState>();
  final _trimestreController = TextEditingController();
  final _anneeController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _valeurCompteurController = TextEditingController();
  File? _image;
  String _errorMessage = '';
  late int id;
   final DatabaseProvider  db = DatabaseProvider.db;
  

  @override
  void initState() {
    super.initState();
     now = DateTime.now();
    _trimestreParam = Parametre(name: 'trimestre', value: getTrimestreFromDate(now).toString());
    _anneeParam = Parametre(name: 'annee', value: now.year.toString());
    _volume1Param = Parametre(name: 'volume1', value: '0');
    _price1Param = Parametre(name: 'price1', value: '0');
    _volume2Param = Parametre(name: 'volume2', value: '0');
    _price2Param = Parametre(name: 'price2', value: '0');
    _volume3Param = Parametre(name: 'volume3', value: '0');
    _price3Param = Parametre(name: 'price3', value: '0');
    _fixedTariffParam = Parametre(name: 'fixed_tariff', value: '0');
    loadParameters();
  
    initializeId();
  }
void loadParameters() async {
      _trimestreParam = (await  db.getParameterByName('trimestre')) ?? _trimestreParam;
      _anneeParam = (await db.getParameterByName('annee')) ?? _anneeParam;
      _volume1Param = (await db.getParameterByName('volume1')) ?? _volume1Param;
      _price1Param = (await db.getParameterByName('price1')) ?? _price1Param;
      _volume2Param = (await db.getParameterByName('volume2')) ?? _volume2Param;
      _price2Param = (await db.getParameterByName('price2')) ?? _price2Param;
      _volume3Param = (await db.getParameterByName('volume3')) ?? _volume3Param;
      _price3Param = (await db.getParameterByName('price3')) ?? _price3Param;
      _fixedTariffParam = (await db.getParameterByName('fixed_tariff')) ?? _fixedTariffParam;
   
      _trimestreController.text = _trimestreParam.value;
      _anneeController.text = _anneeParam.value;
    
    setState(() {});
  }
  Future<void> addInvoice(BuildContext context, int consommationId, double montant, DateTime dateEmission, DateTime dateLimitePaiement) async {
  
  Facture facture = Facture(
    id: 0, // L'ID sera généré automatiquement par la base de données
    montant: montant,
    dateEmission: dateEmission.toIso8601String(), // Convertir la date en format ISO 8601 pour la sauvegarde
    dateLimitePaiement: dateLimitePaiement.toIso8601String(),
    datePaiement: '', 
    estPayee: 0, 
    idConsommation: consommationId,
  );

  try {
    // Insérer la facture dans la base de données
      await db.insertRecord(DatabaseProvider.TABLE_NAME_FACTURE, facture.toJson());
   
  } catch (error) {
    // Afficher un message d'erreur en cas d'échec de l'insertion
    SnackbarUtils.showSnackbar(context, 'Erreur lors de l\'ajout de la facture.', false);
    print('Erreur lors de l\'ajout de la facture : $error');
  }
}

  Future<void> initializeId() async {
    id = await db.getMaxId(DatabaseProvider.TABLE_NAME_CONSOMMATION, 'id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Consommation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: _image == null
                      ? ElevatedButton.icon(
                          onPressed: () => _takePicture(),
                          icon: Icon(Icons.camera),
                          label: Text('Prendre une photo'),
                        )
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
                SizedBox(height: 6.0),
              Text(
                _errorMessage.isNotEmpty ? _errorMessage : '',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 6.0),
              
              TextFormField(
                controller: _valeurCompteurController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valeur Compteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la valeur du compteur.';
                  }
                  return null;
                },
                onChanged: (value) {
                  try{
                  if(value.length>0){
                  if(int.parse(value) > widget.value )
                          _quantiteController.text=(int.parse(value) - widget.value ).toString();
                          else _quantiteController.text="";
                           }
                           } catch (e) {}
                           }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantité'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la quantité.';
                  }
                  return null;
                },
               
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _trimestreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Trimestre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le trimestre.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _anneeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Année'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir l\'année.';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20.0),
            
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    int trimestre, annee, quantite, valeurCompteur;
                    try {
                      trimestre = int.parse(_trimestreController.text);
                      annee = int.parse(_anneeController.text);
                      quantite = int.parse(_quantiteController.text);
                      valeurCompteur = int.parse(_valeurCompteurController.text);
                    } on FormatException {
                      setState(() {
                        _errorMessage = 'Les valeurs saisies doivent être des nombres entiers.';
                      });
                      return;
                    }
                    int existe = await db.getConsommationsForIdConsumerAndYearAndTrimester( widget.idCompteur,annee,  trimestre);
                    if (existe > 0) {
                       setState(() {
                        _errorMessage = ' la consommation exist déjà .';
                      });
                      return;
                    }
                     if (_image == null) {
                       setState(() {
                        _errorMessage = 'prendre une photo .';
                      });
                      return;
                    }

                    final consommation = Consommation(
                      id: id, 
                      trimestre: trimestre,
                      annee: annee,
                      quantite: quantite,
                      valeurCompteur: valeurCompteur,
                      idCompteur:  widget.idCompteur,
                      imagePath: _image != null ? _image!.path : '',
                    );
                  double lastReading = 0.0;
                  double currentReading =double.parse(_quantiteController.text );
                  double rate1 = double.parse(_price1Param.value);
                  double rate2 = double.parse(_price2Param.value);
                  double rate3 = double.parse(_price3Param.value);
                  double threshold1 = double.parse(_volume1Param.value);
                  double threshold2 = double.parse(_volume2Param.value);
                  double maxReading = double.parse(_volume3Param.value); 
                  double fixedPrice = 10;
                   
                    try {
                     double totalCost = calculateCost(lastReading, currentReading, rate1, rate2, rate3, threshold1, threshold2, maxReading, fixedPrice);
                     await db.insertRecord(DatabaseProvider.TABLE_NAME_CONSOMMATION, consommation.toJson());
                      await addInvoice(context, id, totalCost , DateTime.now(), DateTime.now().add(Duration(days: 30)));
                      setState(() {
                        _image = null;
                        _quantiteController.text = '';
                        _valeurCompteurController.text = '';
                        initializeId();
                        SnackbarUtils.showSnackbar(context, 'Consommation enregistrée avec succès.', true);
                      });
                    } catch (error) {
                      SnackbarUtils.showSnackbar(context, 'Error inserting consommation', false);
                      print('Error inserting consommation: $error');
                    }
                  }
                 
                },
                child: Text('Ajouter Consommation'),
              ),
            ],
          ),
        ),
      ),
    );
  }


Future<void> _takePicture() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);
  if (pickedImage != null) {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      
      final fileName = path.basename(pickedImage.path);
      final savedImage = await File(pickedImage.path).copy('${directory.path}/$fileName');
      setState(() {
        _image = savedImage;
        _errorMessage = '';
        print(savedImage.path);
      });
      print(savedImage.path); // Affiche le chemin d'accès à l'image enregistrée
    } else {
      print('Erreur: Impossible de récupérer le répertoire de stockage externe.');
    }
  }
}


}

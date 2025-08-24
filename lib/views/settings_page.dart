import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/widgets/parameterInputDialog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Parametre _trimestreParam;
  late Parametre _anneeParam ;
  late Parametre _userNameParam;
  late Parametre _volume1Param;
  late Parametre _price1Param;
  late Parametre _volume2Param;
  late Parametre _price2Param;
  late Parametre _volume3Param;
  late Parametre _price3Param;
  late Parametre _fixedTariffParam;

  @override
  void initState() {
    super.initState();

    _trimestreParam = Parametre(name: 'trimestre', value: '');
    _anneeParam = Parametre(name: 'annee', value: '');
    _userNameParam = Parametre(name: 'username', value: '');
    _volume1Param = Parametre(name: 'volume1', value: '');
    _price1Param = Parametre(name: 'price1', value: '');
    _volume2Param = Parametre(name: 'volume2', value: '');
    _price2Param = Parametre(name: 'price2', value: '');
    _volume3Param = Parametre(name: 'volume3', value: '');
    _price3Param = Parametre(name: 'price3', value: '');
    _fixedTariffParam = Parametre(name: 'fixed_tariff', value: '');

    // Charger les paramètres depuis la base de données
    loadParameters();
  }

  void loadParameters() async {
    int count = await DatabaseProvider.db.getCount(DatabaseProvider.TABLE_NAME_PARAMETRE);

    // Charger les paramètres depuis la base de données s'il y en a
    if (count != 0) {
      _trimestreParam = (await DatabaseProvider.db.getParameterByName('trimestre')) ?? _trimestreParam;
      _anneeParam = (await DatabaseProvider.db.getParameterByName('annee')) ?? _anneeParam;
      _userNameParam = (await DatabaseProvider.db.getParameterByName('username')) ?? _userNameParam;
      _volume1Param = (await DatabaseProvider.db.getParameterByName('volume1')) ?? _volume1Param;
      _price1Param = (await DatabaseProvider.db.getParameterByName('price1')) ?? _price1Param;
      _volume2Param = (await DatabaseProvider.db.getParameterByName('volume2')) ?? _volume2Param;
      _price2Param = (await DatabaseProvider.db.getParameterByName('price2')) ?? _price2Param;
      _volume3Param = (await DatabaseProvider.db.getParameterByName('volume3')) ?? _volume3Param;
      _price3Param = (await DatabaseProvider.db.getParameterByName('price3')) ?? _price3Param;
      _fixedTariffParam = (await DatabaseProvider.db.getParameterByName('fixed_tariff')) ?? _fixedTariffParam;
    }
    setState(() {});
  }

  Future<void> _saveParameter(String parameterName, String value) async {
  Parametre parameter = Parametre(name: parameterName, value: value);

  // Vérifier si le paramètre existe déjà dans la base de données
  Parametre? existingParameter = await DatabaseProvider.db.getParameterByName(parameterName);

  if (existingParameter != null) {
    // Le paramètre existe déjà, donc le mettre à jour
    await DatabaseProvider.db.updateRecord(DatabaseProvider.TABLE_NAME_PARAMETRE, parameter.toJson(), 'name = ?', [parameterName]);
  } else {
    // Le paramètre n'existe pas, donc l'insérer
    await DatabaseProvider.db.insertRecord(DatabaseProvider.TABLE_NAME_PARAMETRE, parameter.toJson());
  }

  loadParameters();
}


  void _showParameterInputDialog(String parameterName, String initialValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ParameterInputDialog(
          parameterName: parameterName,
          initialValue: initialValue,
          onSave: (newValue) async {
            await _saveParameter(parameterName, newValue);
          },
        );
      },
    );
  }

  Widget _buildParameterCard(String displayName, String parameterName, String value) {
    return Card(
      child: ListTile(
        title: Text(displayName),
        subtitle: Text(value),
        onTap: () {
          _showParameterInputDialog(parameterName, value);
        },
      ),
    );
  }

  Widget _buildSectionDivider(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
       
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_4_outlined,
                          size: 60, // Adjust the size as needed
                          color: Color.fromARGB(255, 19, 143, 157), // Change the color if necessary
                        ),
                      ),
                 
                  
                  Text(
                    '${_userNameParam.value} ',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 19, 143, 157),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 12),
              _buildParameterCard('Nom d\'utilisateur', _userNameParam.name, _userNameParam.value),
               _buildSectionDivider('Consommaion actual'),
              _buildParameterCard('Timestre ', _trimestreParam.name, _trimestreParam.value),
              _buildParameterCard('Annee ', _anneeParam.name, _anneeParam.value),
              _buildSectionDivider('Tranche 1'),
              _buildParameterCard('Volume ', _volume1Param.name, _volume1Param.value),
              _buildParameterCard('Prix ', _price1Param.name, _price1Param.value),
              _buildSectionDivider('Tranche 2'),
              _buildParameterCard('Volume ', _volume2Param.name, _volume2Param.value),
              _buildParameterCard('Prix ', _price2Param.name, _price2Param.value),
              _buildSectionDivider('Tranche 3'),
              _buildParameterCard('Volume ', _volume3Param.name, _volume3Param.value),
              _buildParameterCard('Prix ', _price3Param.name, _price3Param.value),
              _buildSectionDivider('Tarif'),
              _buildParameterCard('Tarif fixe', _fixedTariffParam.name, _fixedTariffParam.value),
            ],
          ),
        ),
      ),
    );
    
  }
}

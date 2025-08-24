import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommation.dart';
import 'package:ifsan/controllers/SyncService.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/widgets/exportPDF_button.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  int _selectedTrimestre = 1;
  int _selectedAnnee = DateTime.now().year;
  late bool completed ;
 List<Map<String, Object?>> dataFromDatabase = []; 
  List<Consommation> _consommations = [];
  final SyncService syncService = new SyncService();
late Parametre _username;
@override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
     _username =Parametre(name: 'username', value: 'User');
    _loadUsername();
  }
  void fetchDataFromDatabase() async {
    _consommations = await DatabaseProvider.db.getConsommationsByCNI("cni");
    dataFromDatabase = await DatabaseProvider.db.getInfoForQuarterYear(
        _selectedTrimestre, _selectedAnnee);
         int nbcompteurs =  await DatabaseProvider.db.getCount(DatabaseProvider.TABLE_NAME_COMPTEUR);
      int nbconsomationsInserted = await DatabaseProvider.db.getConsommationsCountForYearAndTrimester(
         _selectedAnnee, _selectedTrimestre);
        completed = nbconsomationsInserted == nbcompteurs;
    setState(() {});
        setState(() {
          print(dataFromDatabase);
          
        });
  }
   Future<void> _loadUsername() async {
    Parametre? username = await DatabaseProvider.db.getParameterByName('username');
    setState(() {
      _username = username ?? Parametre(name: 'username', value: 'User');
    });
  }
   void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content=="success"? Icon(Icons.check_circle ,size: 80,color: Color.fromARGB(255, 20, 149, 108),):Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<int>(
                  value: _selectedTrimestre,
                  hint: Text('Select Trimestre'),
                  onChanged: (value) {
                 
                    
                       setState(() {  _selectedTrimestre = value!; });
                       fetchDataFromDatabase();
                         
                    
                    
                  },
                  items: <int>[1, 2, 3, 4].map((trimestre) {
                    return DropdownMenuItem<int>(
                      value: trimestre,
                      child: Text('Trimestre $trimestre'),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16),
                DropdownButton<int>(
                  value: _selectedAnnee,
                  hint: Text('Select Annee'),
                  onChanged: (value) {
                    setState(() {
                      _selectedAnnee = value!;
                      fetchDataFromDatabase();
                
                    });
                    setState(() { });
                  },
                  items: _getYearList().map((annee) {
                    return DropdownMenuItem<int>(
                      value: annee,
                      child: Text('$annee'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
         const SizedBox(height: 150,),
          dataFromDatabase.isNotEmpty?
            Column(
              children: [
                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(onPressed: ()
                  async {
try {
       if(completed) await syncService.syncConsommations(_consommations);  
      _showResultDialog('Import successful', 'success');
    } catch (e) {
     
      _showResultDialog('Import failed', e.toString());
    }
                  }
                  , icon: Icon(Icons.cloud_upload_outlined ,size: 120,color: completed? Color.fromARGB(255, 30, 154, 96) :Color.fromARGB(255, 249, 75, 32) ) ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: PDFScreen(
                    dataFromDatabase,
                    
                    _username.value,
                    'T${_selectedTrimestre}  / ${_selectedAnnee} ',
                    completed
                  ),
                ),
              
              ],
            ):  Center(widthFactor: 90, child: Image.asset('assets/nodata.jpg')),
            
        ],
      ),
    );
  }

  List<int> _getYearList() {
    final currentYear = DateTime.now().year;
    return [currentYear - 2, currentYear - 1, currentYear];
  }
}

import 'package:flutter/material.dart';
import 'package:ifsan/functions/calculateCost.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _lastReadingController = TextEditingController();
  final TextEditingController _currentReadingController = TextEditingController();
  String _selectedTier1 = '1';
  String _selectedTier2 = '2';
  String _selectedTier3 = '3';
  String _selectedSizeTier1 = '20';
  String _selectedSizeTier2 = '40';
  double _selectedFixedPrice = 10;
  double _cost = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              Text(
                ' $_cost DH',
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              TextField(
                controller: _lastReadingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ancienne '),
                textDirection: TextDirection.ltr,
              ),
              SizedBox(height: 22),
              TextField(
                controller: _currentReadingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nouvelle '),
                textDirection: TextDirection.ltr,
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Paramètres',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedTier1,
                              items: <String>['1', '2', '3'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value DH/m³'),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedTier1 = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Prix tranche 1'),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedTier2,
                              items: <String>['1', '2', '3','4'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value DH/m³'),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedTier2 = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Prix tranche 2'),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedTier3,
                              items: <String>['1', '2', '3','4','5'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value DH/m³'),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedTier3 = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Prix tranche 3'),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedSizeTier1,
                              items: <String>['10', '20', '30','40'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value m³'),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSizeTier1 = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Volume tranche 1'),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedSizeTier2,
                              items: <String>['40', '30', '50','60'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value m³'),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSizeTier2 = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Volume tranche 2'),
                            ),
                            DropdownButtonFormField<double>(
                              value: _selectedFixedPrice,
                              items: <double>[0, 5, 10, 15, 20].map((double value) {
                                return DropdownMenuItem<double>(
                                  value: value,
                                  child: Text('$value DH'),
                                );
                              }).toList(),
                              onChanged: (double? value) {
                                setState(() {
                                  _selectedFixedPrice = value!;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Prix fixe'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text('Paramètres'),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  double lastReading = double.tryParse(_lastReadingController.text) ?? 0.0;
                  double currentReading = double.tryParse(_currentReadingController.text) ?? 0.0;
                  double rate1 = double.parse(_selectedTier1);
                  double rate2 = double.parse(_selectedTier2);
                  double rate3 = double.parse(_selectedTier3);
                  double threshold1 = double.parse(_selectedSizeTier1);
                  double threshold2 = double.parse(_selectedSizeTier2);

                  double maxReading = 20.0; // Valeur maximale par défaut

                  double fixedPrice = _selectedFixedPrice;
                  double totalCost = calculateCost(lastReading, currentReading, rate1, rate2, rate3, threshold1, threshold2, maxReading, fixedPrice);

                  setState(() {
                    _cost = totalCost;
                  });
                },
                child: Text('Calculer le coût'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lastReadingController.dispose();
    _currentReadingController.dispose();
    super.dispose();
  }
}

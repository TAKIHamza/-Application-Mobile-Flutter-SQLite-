import 'package:flutter/material.dart';
import 'package:ifsan/views/consumptions_page.dart';
import 'package:ifsan/views/facture_page.dart';

class ViewPage extends StatefulWidget {
  final int compteurId;

  const ViewPage({Key? key, required this.compteurId}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 255, 238),
      ),
      body: Column(
        children: [
        Container(
  height: 50,
  color: Color.fromARGB(255, 213, 255, 238),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            
            border: Border(
              bottom: BorderSide(
                color: _currentPageIndex == 0 ? Color.fromARGB(255, 16, 129, 105) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            'Consommations',
            style: TextStyle(
              color: _currentPageIndex == 0 ? Color.fromARGB(255, 16, 129, 105) : Colors.black,
              fontWeight: _currentPageIndex == 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
          
            border: Border(
              bottom: BorderSide(
                color: _currentPageIndex == 1 ? Color.fromARGB(255, 16, 129, 105) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            '       Factures      ',
            style: TextStyle(
              color: _currentPageIndex == 1 ? Color.fromARGB(255, 16, 129, 105) : Colors.black,
              fontWeight: _currentPageIndex == 1 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
       Divider(),
    ],
  ),
),


          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                ConsumptionsPage(compteurId: widget.compteurId),
                FacturePage(idCompteur:  widget.compteurId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

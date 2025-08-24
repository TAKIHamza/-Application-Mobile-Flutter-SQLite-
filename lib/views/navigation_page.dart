import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifsan/views/calculator_page.dart';
import 'package:ifsan/views/consumers_page.dart';
import 'package:ifsan/views/counterSearchDelegate.dart';
import 'package:ifsan/views/export_page.dart';
import 'package:ifsan/views/home_page.dart';
import 'package:ifsan/views/settings_page.dart';
import 'package:ifsan/views/statistiques.dart';
import 'package:ifsan/widgets/appDrawer.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    StatistiquesPage(),
    CalculatorPage(),
    HomePage(),
    ConsumersPage(),
    ExportPage()
  ];

  void _onDrawerItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 14, 129, 109),
        title: Center(
          child: Text(
            'IFSANE',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CounterSearchDelegate(),
              );
            },
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            color: Colors.white,
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(onItemSelected: _onDrawerItemSelected),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _pages[_currentIndex],
        switchOutCurve: Curves.easeOut,
        switchInCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(43, 123, 102, 1),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
           BottomNavigationBarItem(
            icon: Icon(Icons.cloud_done_outlined),
            label: 'backend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'calcule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_outlined),
            label: 'export',
          ),
        ],
      ),
    );
  }
}

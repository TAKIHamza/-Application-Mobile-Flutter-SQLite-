import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/parametre.dart';
import 'package:ifsan/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  final Function(int) onItemSelected;

  AppDrawer({required this.onItemSelected});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Parametre _username;
  late Parametre _email;

  @override
  void initState() {
    super.initState();
    _username =Parametre(name: 'username', value: 'User');
    _loadUsername();
     _email = Parametre(name: 'email', value: 'example@example.com');
    _loadEmail();
  }

 Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    setState(() {
      _email = Parametre(name: 'email', value: email ?? 'example@example.com');
    });
  }

  Future<void> _loadUsername() async {
    Parametre? username = await DatabaseProvider.db.getParameterByName('username');
    setState(() {
      _username = username ?? Parametre(name: 'username', value: 'User');
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:  Text(_username.value) ,
            accountEmail: Text(_email.value),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _username.value[0] ,
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              widget.onItemSelected(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate_outlined),
            title: Text('Calculator'),
            onTap: () {
              widget.onItemSelected(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.people_alt_outlined),
            title: Text('Members'),
            onTap: () {
              widget.onItemSelected(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.upload_file_outlined),
            title: Text('Export'),
            onTap: () {
              widget.onItemSelected(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_done_outlined),
            title: Text('data'),
            onTap: () {
              widget.onItemSelected(0);
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

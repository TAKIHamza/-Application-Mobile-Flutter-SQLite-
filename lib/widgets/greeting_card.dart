import 'package:flutter/material.dart';


class GreetingWidget extends StatelessWidget {
  final String name;

  GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting();
    return Container(
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          SizedBox(width: 10),
          Text(
            '> $greeting, $name',
            style: TextStyle(
              color:Color.fromARGB(223, 42, 43, 43),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(width: 10),
          Icon(
            Icons.waving_hand_outlined, // You can replace this with any suitable greeting icon
            color: Color.fromARGB(255, 235, 195, 73),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }
}

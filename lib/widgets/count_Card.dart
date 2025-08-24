import 'package:flutter/material.dart';

class CountCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final int value;

  const CountCard({
    required this.icon,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
                  Row(
                    children: [
                      Icon(icon, size: 30.0 , color: Color.fromARGB(255, 92, 96, 96),),
                     SizedBox(width: 10.0),
                  
              Text(
                text,
                
                style: TextStyle(fontSize: 14.0, color: Colors.grey ,fontWeight: FontWeight.w500),
              ),
                    ],
                  ),
                 
              Text(
                    value.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
               
            ],
          ),
        
    );
  }
}

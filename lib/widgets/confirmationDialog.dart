import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final String message;
  final Function onConfirm;

  const ConfirmationDialog({required this.message, required this.onConfirm});

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
             
                
            
              SizedBox(height: 16.0),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                 TextButton(
                    onPressed: () {
                      widget.onConfirm();
                      Navigator.pop(context);
                      
                    },
                    child: Text("Confirmer",
                    style: TextStyle(color: Colors.green),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

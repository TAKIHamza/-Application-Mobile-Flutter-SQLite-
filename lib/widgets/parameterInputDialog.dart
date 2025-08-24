import 'package:flutter/material.dart';

class ParameterInputDialog extends StatefulWidget {
  final String parameterName;
  final String initialValue;
  final Function(String) onSave;

  const ParameterInputDialog({
    required this.parameterName,
    required this.initialValue,
    required this.onSave,
  });

  @override
  _ParameterInputDialogState createState() => _ParameterInputDialogState();
}

class _ParameterInputDialogState extends State<ParameterInputDialog> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier ${widget.parameterName}'),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(labelText: widget.parameterName),
         keyboardType: widget.parameterName=='username'?TextInputType.text:TextInputType.number,
        
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_textController.text);
            Navigator.pop(context);
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }
}

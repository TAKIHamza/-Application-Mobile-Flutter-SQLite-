import 'package:flutter/material.dart';
import 'package:ifsan/controllers/database_provider.dart';
import 'package:ifsan/models/consommateur.dart'; 
import 'package:ifsan/views/consumer_page.dart';
import 'package:ifsan/widgets/confirmationDialog.dart';
import 'package:ifsan/widgets/snackbar_utils.dart'; 

class MemberCard extends StatefulWidget {
  final Consommateur consommateur;
  final Function() refreshConsumers; 

  const MemberCard({
    required this.consommateur,
    required this.refreshConsumers, 
  });
  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), 
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

Future<void> _deleteConsommateur() async {
    try {
      final rowsDeleted = await DatabaseProvider.db.deleteConsommateur(widget.consommateur.id);
      if (rowsDeleted > 0) {
        SnackbarUtils.showSnackbar(context, 'Consommateur supprimé avec succès!', true);
        widget.refreshConsumers();
      } else {
        SnackbarUtils.showSnackbar(context, 'Impossible de supprimer le consommateur.', false);
      }
    } catch (error) {
      print('Error deleting consommateur: $error');
      SnackbarUtils.showSnackbar(
          context, 'Une erreur s\'est produite lors de la suppression du consommateur.', false);
    }
  }
   Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous vraiment supprimer ce consommateur ?',
          onConfirm: () {
            _deleteConsommateur();
           
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building MemberCard widget...');
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
     onTap: () {
  try {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConsumerPage(consommateur: widget.consommateur)),
    );
  } catch (error) {
    print('Error navigating to ConsumerPage: $error');
    // Optionally, display an error message to the user
  }
},
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Hero(
                 tag: 'avatar-${widget.consommateur.id}',

                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    // Placeholder user avatar, you can replace it with actual user avatar
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color.fromARGB(255, 49, 170, 174),
                    ),),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.consommateur.nom.toUpperCase(), // Access the properties of Consommateur
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.consommateur.prenom, // Access the properties of Consommateur
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
               IconButton(
  onPressed: () {
    setState(() {
      _showDeleteConfirmationDialog();
    });
    
  },
  icon: Icon(Icons.delete),
  tooltip: 'Delete',
  color: Colors.red,
),
                const SizedBox(width: 6),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

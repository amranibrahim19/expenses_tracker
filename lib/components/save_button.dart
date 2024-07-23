import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;

  const SaveButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
  });

  @override
  SaveButtonState createState() => SaveButtonState();
}

class SaveButtonState extends State<SaveButton> {
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 50,
      child: ElevatedButton(
        onPressed:
            _isButtonDisabled || widget.isLoading ? null : _handleButtonPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Set border radius
          ),
        ),
        child: widget.isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(widget.text),
      ),
    );
  }

  void _handleButtonPress() {
    setState(() {
      _isButtonDisabled = true;
    });

    widget.onPressed();

    // Add any additional logic here after button press

    setState(() {
      _isButtonDisabled = false;
    });
  }
}

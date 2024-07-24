import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;

  const UploadButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
  });

  @override
  UploadButtonState createState() => UploadButtonState();
}

class UploadButtonState extends State<UploadButton> {
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
          backgroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Set border radius
            side: const BorderSide(
                color: Colors.black, width: 1.5), // Border color and width
          ),
        ),
        child: widget.isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
            : Text(
                widget.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
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

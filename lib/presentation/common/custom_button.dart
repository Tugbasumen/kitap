import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;

  const CustomButton({
    super.key,
    this.isLoading = false,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style;

    switch (type) {
      case ButtonType.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(50),
        );
        break;
      case ButtonType.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(50),
        );
        break;
      case ButtonType.text:
        style = TextButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
        );
        break;
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : SizedBox(
            width: double.infinity,
            child: type == ButtonType.text
                ? TextButton(
                    onPressed: onPressed,
                    style: style,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: null,
                    ),
                  )
                : ElevatedButton(
                    onPressed: onPressed,
                    style: style,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
          );
  }
}

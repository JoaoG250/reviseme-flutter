import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  const ImageDialog({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(imageUrl),
      ),
    );
  }
}

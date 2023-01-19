import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String? image;
  const ShowImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(
        image!,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

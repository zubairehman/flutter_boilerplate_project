import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final image;

  const AppIconWidget({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getting screen size
    var size = MediaQuery.of(context).size;

    //calculating container width
    double imageSize;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imageSize = (size.width * 0.20);
    } else {
      imageSize = (size.height * 0.20);
    }

    return Image.asset(
      image,
      height: imageSize,
    );
  }
}

import 'package:flutter/material.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 100,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(100, 105, 105, 105)),
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

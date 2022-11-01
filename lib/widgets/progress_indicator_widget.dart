// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 100,
        constraints: const BoxConstraints.expand(),
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Card(
              child: const Padding(
                padding: EdgeInsets.all(25.0),
                child: CircularProgressIndicator(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),),
            ),
          ),
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(100, 105, 105, 105),
        ),
      ),
    );
  }
}

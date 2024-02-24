import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    this.height = 75,
    this.width = 75,
  }) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData?>(
      builder: (BuildContext context, AsyncSnapshot<ByteData?> snapshot) {
        Widget child = Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator();
        if (snapshot.hasData) {
          child = Image.memory(snapshot.data!.buffer.asUint8List());
        }
        return Center(
          child: SizedBox(
            height: height,
            width: width,
            child: child,
          ),
        );
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingIndicator()),
    );
  }
}

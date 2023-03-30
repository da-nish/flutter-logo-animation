import 'package:flutter/material.dart';

class Rotate1 extends StatefulWidget {
  @override
  _Rotate1State createState() => _Rotate1State();
}

class _Rotate1State extends State<Rotate1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Icon(Icons.stars),
            ),
            ElevatedButton(
              child: Text("go"),
              onPressed: () => _controller.forward(),
            ),
            ElevatedButton(
              child: Text("reset"),
              onPressed: () => _controller.reset(),
            ),
          ],
        ),
      ),
    );
  }
}

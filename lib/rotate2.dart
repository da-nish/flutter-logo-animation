import 'package:flutter/material.dart';

class Rotate2 extends StatefulWidget {
  @override
  _Rotate2State createState() => _Rotate2State();
}

class _Rotate2State extends State<Rotate2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animTurn;
  bool clockwise = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animTurn = Tween<double>(begin: 0.0, end: -1.0).animate(_controller);

    // _controller.reverse();
    // _controller.repeat(reverse: false);
    super.initState();
  }

  bool isSlow = false;
  void speedUp() {
    if (!isSlow) {
      print("called spedup 1");
      _controller.duration = const Duration(milliseconds: 4000);
    } else {
      print("called spedup 2");
      _controller.duration = const Duration(milliseconds: 1000);
    }
    isSlow = !isSlow;
    if (clockwise) {
      back();
    } else {
      forr();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void call() {
    if (_controller.isAnimating) {
      _controller.stop();
      _controller.animateBack(1, curve: Curves.ease);
      // _controller.animateTo(1,
      //     duration: Duration(milliseconds: 2000), curve: Curves.bounceIn);
      // _controller.reset();
      return;
    }

    if (clockwise) {
      forr();
    } else {
      back();
    }

    clockwise = !clockwise;
  }

  void forr() {
    print("running forward");
    _animTurn = Tween<double>(
      begin: _controller.lowerBound,
      end: _controller.upperBound,
    ).animate(
      _controller,
    );

    _controller.repeat();
    setState(() {});
  }

  void back() {
    _controller.animateTo(_controller.value);
    _animTurn = Tween<double>(
      begin: _controller.upperBound,
      end: _controller.lowerBound,
    ).animate(_controller);

    _controller.repeat();
    setState(() {});
  }

  void pause() {
    if (_controller.isAnimating) {
      print("stop animation");

      _controller.stop();
      return;
    }
    if (clockwise) {
      back();
    } else {
      forr();
    }
    // clockwise = !clockwise;
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
            InkWell(
              onLongPress: () => pause(),

              onDoubleTap: () => speedUp(),
              // onTapDown: (_) => pause(),
              // onTapUp: (_) => pause(),

              onTap: () => call(),
              child: RotationTransition(
                turns: _animTurn,
                child: Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 200,
                ),
              ),
            ),
            // ElevatedButton(
            //   child: Text("go"),
            //   onPressed: () => _controller.forward(),
            // ),
            ElevatedButton(
              child: Text("change"),
              onPressed: () => call(),
            ),
            ElevatedButton(
              child: Text("forward"),
              onPressed: () => forr(),
            ),
            ElevatedButton(
              child: Text("backword"),
              onPressed: () => back(),
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

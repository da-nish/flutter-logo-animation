import 'package:flutter/material.dart';
import 'package:rotate_animation/core/values/app_assets.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  LogoScreenState createState() => LogoScreenState();
}

class LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animTurn;
  bool clockwise = true;
  int normalSpeed = 2000;
  int slowSpeed = 6000;
  bool isNormalSpeed = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: normalSpeed),
      vsync: this,
    );
    _animTurn = Tween<double>(begin: 0.0, end: -1.0).animate(_controller);
    super.initState();
  }

  void speedUp() {
    _controller.duration =
        Duration(milliseconds: isNormalSpeed ? slowSpeed : normalSpeed);
    isNormalSpeed = !isNormalSpeed;
    continueAnimation();
  }

  void stopRotation() {
    if (_controller.isAnimating) {
      _controller.stop();
      _controller.animateBack(1,
          curve: Curves.ease,
          duration:
              Duration(milliseconds: isNormalSpeed ? normalSpeed : slowSpeed));
      return;
    }
    continueAnimation(reverse: true);
    clockwise = !clockwise;
  }

  void forwardAnimation() {
    _animTurn = Tween<double>(
      begin: _controller.lowerBound,
      end: _controller.upperBound,
    ).animate(
      _controller,
    );
    _controller.repeat();
  }

  int selectedLogoIndex = 0;
  List<String> logoList = [
    AppAssets.kapivaLogo,
    AppAssets.kapivaTextLogo,
    AppAssets.mercedesLogo,
    AppAssets.arrow
  ];

  void reverseAnimation() {
    _controller.animateTo(_controller.value);
    _animTurn = Tween<double>(
      begin: _controller.upperBound,
      end: _controller.lowerBound,
    ).animate(_controller);

    _controller.repeat();
  }

  void pauseOrResume() {
    if (_controller.isAnimating) {
      _controller.stop();
      return;
    }
    continueAnimation();
  }

  void continueAnimation({bool reverse = false}) {
    if (reverse) {
      !clockwise ? reverseAnimation() : forwardAnimation();
      return;
    }
    clockwise ? reverseAnimation() : forwardAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              InkWell(
                onLongPress: () => pauseOrResume(),
                onDoubleTap: () => speedUp(),
                onTap: () => stopRotation(),
                child: Center(
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return RotationTransition(
                              turns: _animTurn,
                              child: Image.asset(
                                logoList[selectedLogoIndex],
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                    onPressed: () => changeLogo(),
                    child: const Text("Change logo")),
              ),
              const Spacer(),
              const Text("Tap: Start/Stop rotation"),
              const Text("Double Tap: Change speed"),
              const Text("Long Press: Pause/Resume rotation"),
            ],
          ),
        ),
      ),
    );
  }

  changeLogo() {
    if (selectedLogoIndex + 1 == logoList.length) {
      selectedLogoIndex = 0;
    } else {
      selectedLogoIndex++;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

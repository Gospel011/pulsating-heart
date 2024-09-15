import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> sizeAnimation;
  late Animation<Color?> colorAnimation;
  bool liked = false;

  @override
  void initState() {
    super.initState();

    // Define animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Create Enlarging animation from 32 to 40 and back to 32
    sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 32, end: 40), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 40, end: 32), weight: 50),
    ]).animate(_animationController);

    // Create color animation
    colorAnimation = ColorTween(begin: Colors.grey[100], end: Colors.red)
        .animate(_animationController);

    // listen to animation status
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        liked = true;
      } else if (status == AnimationStatus.dismissed) {
        liked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuad,
          builder: (BuildContext context, double value, Widget? child) {
            return Padding(
              padding: EdgeInsets.only(left: value * 16),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: const Text('Material App Bar'),
        ),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return IconButton(
              onPressed: () {
                liked
                    ? _animationController.reverse()
                    : _animationController.forward();
              },
              icon: Icon(
                Icons.favorite_rounded,
                size: sizeAnimation.value,
                color: colorAnimation.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

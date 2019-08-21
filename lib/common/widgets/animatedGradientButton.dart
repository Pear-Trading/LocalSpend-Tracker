import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  final List<Color> animateColors;
  final Color lastColor;
  final Alignment begin, end;
  final int duration;

  AnimatedBackground(
    this.animateColors,
    this.lastColor,
    this.begin,
    this.end,
    this.duration,
  );

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: this.duration),
          ColorTween(begin: this.animateColors[0], end: this.animateColors[1])),
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: this.begin,
                  end: this.end,
                  colors: [animation["color1"], this.lastColor])),
        );
      },
    );
  }
}
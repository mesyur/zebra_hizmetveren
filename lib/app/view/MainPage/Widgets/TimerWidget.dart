import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'dart:math' as math;

import '../../../controller/BillingInformationController.dart';
import '../../../controller/MainPageController.dart';



class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin{

  MainPageController initialController = Get.find();
  late AnimationController animationController;
  String get timerString {
    Duration duration = animationController.duration! * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    super.initState();
    animationController.stop();
    animationController.reset();
    animationController.reverse(from: animationController.value == 0.0 ? 1.0 : animationController.value);
    animationController.addListener(() {
      if(animationController.isDismissed && animationController.value == 0.0){
        initialController.closeDialog();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WidgetCircularAnimator(
          outerColor: Colors.black,
          size: 60,
          innerIconsSize: 1,
          innerColor: Colors.transparent,
          innerAnimation: Curves.linear,
          child: Container(),
        ),
        Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(left: 0, right: 0,top: 0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: ( context,  child) {
                      return CustomPaint(
                          painter: TimerPainter(
                            animation: animationController,
                            backgroundColor: Colors.grey,
                            color: Colors.red,
                          )
                      );
                    },
                  ),
                ),

                Align(
                  alignment: FractionalOffset.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.lens,size: 50,color: Colors.white,),
                      AnimatedBuilder(
                          animation: animationController,
                          builder: ( context,  child) {
                            return Text(timerString,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red));
                          }
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}



class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double>? animation;
  final Color? backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor!
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color!;
    double progress = (1.0 - animation!.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation!.value != oldDelegate.animation!.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
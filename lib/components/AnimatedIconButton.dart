import 'package:flutter/material.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';

class AnimatedIconButton extends StatefulWidget {
  const AnimatedIconButton({Key? key}) : super(key: key);

  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currIndex = _currIndex == 0 ? 1 : 0;
        });
      },
      child: Container(
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: child.key == ValueKey('icon1')
                ? Tween<double>(begin: 1, end: 1).animate(anim)
                : Tween<double>(begin: 0.75, end: 1).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: _currIndex == 0
              ? Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 20,
                  key: const ValueKey('icon1'),
                )
              : Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                  key: const ValueKey('icon2'),
                ),
        ),
      ),
    );
  }
}

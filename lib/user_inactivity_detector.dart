// library user_inactivity_detector;
import 'package:flutter/material.dart';

// import 'package:user_inactivity_detector/user_inactivity_detector.dart';

import 'service/timer_service.dart';

class UserInactivityDetector extends StatefulWidget {
  final Duration duration;
  final Function() onStopped;
  final bool enabled;
  final Widget? child;

  const UserInactivityDetector({
    Key? key,
    this.child,
    required this.duration,
    required this.onStopped,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<UserInactivityDetector> createState() => _UserInactivityDetectorState();
}

class _UserInactivityDetectorState extends State<UserInactivityDetector> {
  TimerService? _timerService;

  @override
  Widget build(BuildContext context) {
    initService();
    return GestureDetector(
      onTap: _userInteraction,
      onDoubleTap: _userInteraction,
      onSecondaryLongPress: _userInteraction,
      onScaleStart: _userInteraction,
      onDoubleTapCancel: _userInteraction,
      onLongPress: _userInteraction,
      onTapDown: _userInteraction,
      onLongPressDown: _userInteraction,
      onLongPressStart: _userInteraction,
      onLongPressEnd: _userInteraction,
      onForcePressStart: _userInteraction,
      onForcePressEnd: _userInteraction,
      onForcePressPeak: _userInteraction,
      onForcePressUpdate: _userInteraction,
      onVerticalDragDown: _userInteraction,
      onHorizontalDragCancel: _userInteraction,
      onScaleUpdate: _userInteraction,
      onSecondaryTap: _userInteraction,
      onLongPressMoveUpdate: _userInteraction,
      child: widget.child,
    );
  }

  void initService() {
    if (_timerService == null) {
      _timerService = TimerService.of(context);
      _timerService!.setCurrentDuration(widget.duration);
      _timerService!.start();
      _timerService!.addListener(() {
        if (widget.enabled) {
          _handleTimerService();
        }
      });
    }
  }

  void _userInteraction([_]) => _timerService!.reset();

  void _handleTimerService() => widget.onStopped();
}

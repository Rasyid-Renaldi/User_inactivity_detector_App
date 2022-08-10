import 'package:flutter/material.dart';
import 'package:user_inactivity_detector/user_inactivity_detector.dart';

import '../services/auth_service.dart';

class RootScreen extends StatefulWidget {
  static route(Widget child) => MaterialPageRoute(
        builder: (context) => RootScreen(child: child),
      );

  final Widget child;

  const RootScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  late final AuthService service;
  bool isLock = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // This function listen app life cycle
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    service = AuthService(
      text: 'Enter biometric data to enter app',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void enableLock() => setState(() => isLock = true);

  void disableLock() => setState(() => isLock = false);

  void checkIsLock() async {
    if (isLock) {
      await service.auth();
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsLock();
    return UserInactivityDetector(
      duration: const Duration(minutes: 1),
      onStopped: () async {
        await service.auth();
      },
      child: widget.child,
    );
  }

  void onAppResumed() {
    //* fungsi ini akan berjalan jika aplikasi dilanjutkan

    print('Melanjutkan');
  }

  void onAppPaused() {
    //* fungsi ini akan berjalan jika aplikasi dijeda

    enableLock();
    print('Dijeda');
  }

  void onAppDetached() {
    //* fungsi ini akan berjalan jika aplikasi dimatikan

    enableLock();
    print('Dimatikan');
  }

  void onAppInactive() {
    //* fungsi ini akan berjalan jika aplikasi di non-aktifkan

    print('Di Non-Aktifkan');
  }
}

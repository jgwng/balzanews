import 'dart:async';
import 'dart:ui';

class DeBouncer {
  final int milliSeconds;
  Timer? _timer;

  DeBouncer({required this.milliSeconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSeconds), action);
  }

  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  bool get isRun {
    if (_timer == null) return false;
    return _timer!.isActive;
  }
}

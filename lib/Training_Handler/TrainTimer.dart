import 'dart:async';

class TrainTimer {
  int _lastStop;
  int _time = 0;
  Timer _timer;
  int _start = 0;
  bool running = false;
  StreamController onSecond;
  StreamController onMillis;
  TrainTimer(this.onSecond, this.onMillis );

  int getTime() {
    return _time;
  }

  int getRelativeTime() {
    return _time - (_lastStop - _start);
  }
  int getOverflow(duration){
    return (DateTime.now().millisecondsSinceEpoch - _lastStop)-duration;
  }
  void round({overflow = 0}) {
    _lastStop = DateTime.now().millisecondsSinceEpoch-overflow;
    onSecond.add(this);
    onMillis.add(this);
  }

  void start() {
    _start = _lastStop = DateTime.now().millisecondsSinceEpoch;
    if (!running) {
      running = true;
      this._timer = Timer.periodic(Duration(milliseconds: 2), (timer) {
        //Prüft alle 2 Milisekunden ob die Zeit sich geändert hat (Abgleich mit RTC)
        int oldTime = _time;
        _time = DateTime.now().millisecondsSinceEpoch - _start;
        if (_time ~/ 1000 != oldTime ~/ 1000) {
          onSecond.add(this);
        }
        onMillis.add(this);

      });
    }
  }

  void stop() {
    if (running) {
      _timer.cancel();
      running = false;
    }
  }
}
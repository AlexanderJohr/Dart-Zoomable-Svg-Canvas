part of topology_of_the_photography;

class GenreOverviewViewBox {

  final svg.SvgElement svgElement;

  KeySpline cubicBezier = new KeySpline(0.42, 0, 0.58, 1.0);

  num wrapperViewportWidth;
  num wrapperViewportHeight;

  Rectangle<num> viewboxBounds = new Rectangle<num>(10, 0, 2200, 1000);

  final int animationDuration;
  Rectangle<num> _currentViewBox;
  Rectangle<num> _startViewBox;
  Rectangle<num> _desiredViewBox;
  DateTime _timeDesiredPosWasSet = new DateTime.now();

  StreamController<Rectangle> viewBoxChangedController = new StreamController<Rectangle>.broadcast();

  Stream get viewBoxChanged => viewBoxChangedController.stream;

  GenreOverviewViewBox(this.svgElement, this.animationDuration, this._desiredViewBox) {

    updateWrapperViewport();


    window.onResize.listen(onWindowResize);

    _currentViewBox = _desiredViewBox;
    _startViewBox = _desiredViewBox;
  }

  void updateWrapperViewport() {
    Math.Rectangle wrapperRect = svgElement.client;
    wrapperViewportWidth = wrapperRect.width;
    wrapperViewportHeight = wrapperRect.height - 50;
    if (_desiredViewBox != null) desiredViewBox = _desiredViewBox;
  }


  num ease(x) {
    return cubicBezier.get(x);
  }


  static num map(num value, num istart, num istop, num ostart, num ostop) {
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
  }

  animationLoop(num delta) {

    _currentViewBox = currentPos;

    viewBoxChangedController.add(_currentViewBox);

    if (animationInProgress) {
      window.animationFrame.then(animationLoop);
    }
  }



  Duration get durationSinceAnimationStarted {
    return new DateTime.now().difference(_timeDesiredPosWasSet);
  }
  bool get animationInProgress {
    return durationSinceAnimationStarted.inMilliseconds < animationDuration;
  }

  set desiredViewBox(Rectangle<num> value) {

    _startViewBox = _currentViewBox;

    Rectangle<num> intersection = viewboxBounds.intersection(value);

    _desiredViewBox = intersection;

    _timeDesiredPosWasSet = new DateTime.now();

    window.animationFrame.then(animationLoop);

  }



  Rectangle<num> get currentPos {

    int passedMilliseconds = durationSinceAnimationStarted.inMilliseconds;


    num passedMillisecondsPassedToOne = map(passedMilliseconds, 0, animationDuration, 0, 1);

    num eased = ease(passedMillisecondsPassedToOne);

    num easedLeft = map(eased, 0, 1, _startViewBox.left, _desiredViewBox.left);
    num easedTop = map(eased, 0, 1, _startViewBox.top, _desiredViewBox.top);
    num easedWidth = map(eased, 0, 1, _startViewBox.width, _desiredViewBox.width);
    num easedHeight = map(eased, 0, 1, _startViewBox.height, _desiredViewBox.height);

    return new Rectangle<num>(easedLeft, easedTop, easedWidth, easedHeight);
  }


  String get viewBox {
    Rectangle<num> rect = _currentViewBox;
    return "${rect.left} ${rect.top} ${rect.width} ${rect.height}";
  }

  void onWindowResize(Event event) {
    updateWrapperViewport();

  }
}

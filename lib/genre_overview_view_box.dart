part of zoomable_svg_canvas;

class GenreOverviewViewBox {

  final SvgElement svgElement;
  final DivElement genreOverviewDiv;
  
  num wrapperViewportWidth;
  num wrapperViewportHeight;
  
  
  final int animationDuration;
  Rectangle<num> _currentViewBox;
  Rectangle<num> _startViewBox;
  Rectangle<num> _desiredViewBox;
  DateTime _timeDesiredPosWasSet = new DateTime.now();

  StreamController<Rectangle> viewBoxChangedController = new StreamController<Rectangle>.broadcast();

  Stream get viewBoxChanged => viewBoxChangedController.stream;

  GenreOverviewViewBox(this.svgElement, this.genreOverviewDiv, this.animationDuration) {

    updateWrapperViewport();
    
    window.onResize.listen(onWindowResize);
    
    _currentViewBox = svgElement.client;
    _startViewBox = svgElement.client;
    _desiredViewBox = svgElement.client;

  }

  void updateWrapperViewport() {
    Math.Rectangle wrapperRect = genreOverviewDiv.client;
    wrapperViewportWidth = wrapperRect.width;
    wrapperViewportHeight = wrapperRect.height;
  }


  static num ease(x) {
    KeySpline cubicBezier = new KeySpline(0.42, 0, 0.58, 1.0);
    return cubicBezier.get(x);
    //return pow(x, 2) / pow((x + (1 - x)), 2);
  }


  static num map(num value, num istart, num istop, num ostart, num ostop) {
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
  }

  animationLoop(num delta) {

    _currentViewBox = currentPos;

    viewBoxChangedController.add(_currentViewBox);

    //svgElement.attributes["viewBox"] = viewBox;

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
    _desiredViewBox = value;

    _timeDesiredPosWasSet = new DateTime.now();

    window.animationFrame.then(animationLoop);

  }



  Rectangle<num> get currentPos {

    int passedMilliseconds = durationSinceAnimationStarted.inMilliseconds;


    num passedMillisecondsPassedToOne = map(passedMilliseconds, 0, animationDuration, 0, 1);

    num eased = ease(passedMillisecondsPassedToOne);

    //print(eased);

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

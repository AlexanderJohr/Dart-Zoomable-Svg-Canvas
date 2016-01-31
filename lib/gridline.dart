part of topology_of_the_photography;

class Gridline {
  Math.Point<num> _initialPoint1;
  Math.Point<num> _initialPoint2;

  final svg.LineElement lineElement;
  final GenreOverviewViewBox parentViewbox;

  set viewPort(Rectangle newViewPort) {
    lineElement.attributes['x1'] = "${((_initialPoint1.x / newViewPort.width) * parentViewbox.wrapperViewportWidth)    - ((newViewPort.left / newViewPort.width)* parentViewbox.wrapperViewportWidth)}";
    lineElement.attributes['y1'] = "${((_initialPoint1.y / newViewPort.height) * parentViewbox.wrapperViewportHeight)   -  ((newViewPort.top / newViewPort.height)* parentViewbox.wrapperViewportHeight)}";

    lineElement.attributes['x2'] = "${((_initialPoint2.x / newViewPort.width) * parentViewbox.wrapperViewportWidth)    - ((newViewPort.left / newViewPort.width)* parentViewbox.wrapperViewportWidth)}";
    lineElement.attributes['y2'] = "${((_initialPoint2.y / newViewPort.height) * parentViewbox.wrapperViewportHeight)   -  ((newViewPort.top / newViewPort.height)* parentViewbox.wrapperViewportHeight)}";
  }

  Gridline(this.lineElement, this.parentViewbox) {
    lineElement..attributes["vector-effect"] = "non-scaling-stroke";

    _initialPoint1 = new Math.Point(num.parse(lineElement.attributes["x1"]), num.parse(lineElement.attributes["y1"]));
    _initialPoint2 = new Math.Point(num.parse(lineElement.attributes["x2"]), num.parse(lineElement.attributes["y2"]));

    this.parentViewbox.viewBoxChanged.listen(ParentsViewBoxChanged);
  }

  void ParentsViewBoxChanged(Rectangle newViewport) {
    viewPort = newViewport;
  }
}

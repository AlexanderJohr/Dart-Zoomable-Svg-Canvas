part of topology_of_the_photography;

class Griddate {

  Math.Point<num> _initialPoint;

  final svg.TextElement textElement;
  final GenreOverviewViewBox parentViewbox;

  set viewPort(Rectangle newViewPort) {
    textElement.attributes['x'] = "${((_initialPoint.x / newViewPort.width) * parentViewbox.wrapperViewportWidth)    - ((newViewPort.left / newViewPort.width)* parentViewbox.wrapperViewportWidth)}";
    textElement.attributes['y'] = "25";
  }

  Griddate(this.textElement, this.parentViewbox) {

    _initialPoint = new Math.Point(num.parse(textElement.attributes["x"]), num.parse(textElement.attributes["y"]));

    this.parentViewbox.viewBoxChanged.listen(ParentsViewBoxChanged);
  }

  void ParentsViewBoxChanged(Rectangle newViewport) {
    viewPort = newViewport;
  }
}

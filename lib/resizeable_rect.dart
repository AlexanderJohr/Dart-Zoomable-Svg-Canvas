part of topology_of_the_photography;

class ResizeableRect {

  Rectangle _initialRectPos;
  
  final svg.RectElement rectElement;
  final GenreOverviewViewBox parentViewbox;

  static const int margin = 10;

  Rectangle<num> get pos => _initialRectPos;
  Rectangle<num> get posWithMargin => new Rectangle<num>(_initialRectPos.left -margin, _initialRectPos.top - margin, _initialRectPos.width +(margin*2), _initialRectPos.height +(margin*2));

  set viewPort(Rectangle newViewPort){
    // x vom Rechteck durch breite des Viewports = Anteil von X am Viewport. Diesen Anteil mal Wrapperbreite ist tatsächliches X     viewport X durch viewportbreite = anteil vom Viewport x am Viewport, dieser Anteil mal dem Wrapperbreite ist tatsäches ViewBox X . Tatsaechliches X durch tatsächliches Viewport X ist X relativ zum Viewport
    rectElement.attributes['x'] = "${((_initialRectPos.left / newViewPort.width) * parentViewbox.wrapperViewportWidth)    - ((newViewPort.left / newViewPort.width)* parentViewbox.wrapperViewportWidth)}";
    rectElement.attributes['y'] = "${((_initialRectPos.top / newViewPort.height) * parentViewbox.wrapperViewportHeight)   -  ((newViewPort.top / newViewPort.height)* parentViewbox.wrapperViewportHeight)}";
    // breite des rechtecks durch breite des Viewports ist der Anteil am Viewport. Anteil am Viewport mal Wrapperbreite ist tatsaechliche Groesse
    rectElement.attributes['width'] = "${(_initialRectPos.width / newViewPort.width) *  parentViewbox.wrapperViewportWidth}";
    rectElement.attributes['height'] = "${(_initialRectPos.height / newViewPort.height) *  parentViewbox.wrapperViewportHeight}";
  }

  ResizeableRect(this.rectElement, this.parentViewbox) {
    rectElement
        ..attributes["vector-effect"] = "non-scaling-stroke"
        ..attributes["stroke-linecap"] = "round";
    
    _initialRectPos = new Rectangle(
       num.parse(rectElement.attributes['x'])
    , num.parse(rectElement.attributes['y'])
    , num.parse(rectElement.attributes['width'])
    , num.parse(rectElement.attributes['height']));

    this.parentViewbox.viewBoxChanged.listen(ParentsViewBoxChanged);
  }

  void ParentsViewBoxChanged(Rectangle newViewport) {
    viewPort = newViewport;
  }
}

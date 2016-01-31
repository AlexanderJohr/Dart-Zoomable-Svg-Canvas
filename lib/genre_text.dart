part of topology_of_the_photography;

class GenreText {

  Math.Point<num> _initialPos;
  
  final svg.TextElement textElement;
  final GenreOverviewViewBox parentViewbox;
  
  static const int margin = 10;

  Math.Point<num> get pos => _initialPos;
  
  set viewPort(Rectangle newViewPort){
    // x vom Rechteck durch breite des Viewports = Anteil von X am Viewport. Diesen Anteil mal Wrapperbreite ist tatsächliches X     viewport X durch viewportbreite = anteil vom Viewport x am Viewport, dieser Anteil mal dem Wrapperbreite ist tatsäches ViewBox X . Tatsaechliches X durch tatsächliches Viewport X ist X relativ zum Viewport
    textElement.attributes['x'] = "${((_initialPos.x / newViewPort.width) * parentViewbox.wrapperViewportWidth)    - ((newViewPort.left / newViewPort.width)* parentViewbox.wrapperViewportWidth)}";
    textElement.attributes['y'] = "${((_initialPos.y / newViewPort.height) * parentViewbox.wrapperViewportHeight)   -  ((newViewPort.top / newViewPort.height)* parentViewbox.wrapperViewportHeight)}";
    
  }
  
  GenreText(this.textElement, this.parentViewbox) {
    textElement
        ..attributes["vector-effect"] = "non-scaling-stroke";
    
    _initialPos = new Math.Point(
      num.parse(textElement.attributes['x'])
    , num.parse(textElement.attributes['y']));
    
    this.parentViewbox.viewBoxChanged.listen(ParentsViewBoxChanged);
  }
  
  void ParentsViewBoxChanged(Rectangle newViewport) {
    viewPort = newViewport;
  }
}

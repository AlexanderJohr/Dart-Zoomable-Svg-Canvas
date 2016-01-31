part of topology_of_the_photography;

class BackgroundRect extends ResizeableRect {
  final RectElement backgroundRectElement;
  final GenreOverviewViewBox parentViewbox;

  BackgroundRect(
      RectElement rectElement, GenreOverviewViewBox genreOverviewViewBox)
      : super(rectElement, genreOverviewViewBox),
        backgroundRectElement = rectElement,
        parentViewbox = genreOverviewViewBox {
    rectElement.onClick.listen(onBackgroundClick);
  }

  void onBackgroundClick(MouseEvent event) {
    parentViewbox.desiredViewBox = pos;
    ApplicationState.instance.activateSubgenres(0);
  }
}

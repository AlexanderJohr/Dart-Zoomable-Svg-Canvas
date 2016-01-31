part of topology_of_the_photography;

class TitledGenre extends Genre {

  final GenreText genreText;
  bool _rectVisible = false;
  set rectVisible(bool value) {
    _rectVisible = value;
    if (_rectVisible) {
      genreRect.rectElement.classes.add("visible");
      genreRect.rectElement.classes.remove("hidden");
    } else {
      genreRect.rectElement.classes.add("hidden");
      genreRect.rectElement.classes.remove("visible");
    }
  }


  set active(bool value) {

    _active = value;
    if (_active) {
      rectVisible = false;
      genreText.textElement.classes.add("visible");
      genreText.textElement.classes.remove("hidden");
    } else {
      genreText.textElement.classes.add("hidden");
      genreText.textElement.classes.remove("visible");
    }
  }

  TitledGenre(svg.RectElement rectElement, svg.TextElement titleElement, GenreOverviewViewBox genreOverviewViewBox, [Genre parentGenre = null, int level = 0])
      : super(rectElement, titleElement.text, genreOverviewViewBox, parentGenre, level),
        genreText = new GenreText(titleElement, genreOverviewViewBox) {
    genreText.textElement.onClick.listen(onGenreClick);
    genreText.textElement.onMouseOver.listen(onGenreMouseOver);

    genreText.textElement.onMouseOver.listen(onGenreTextMouseOver);
    genreText.textElement.onMouseOut.listen(onGenreTextMouseOut);

    genreText.textElement.text = "+ ${genreText.textElement.text}";

    genreRect.rectElement.onMouseOver.listen(onGenreMouseOver);
        genreRect.rectElement.onMouseOver.listen(showDescription);

  }

  ParagraphElement createNavigationLink(String title) {

    ParagraphElement naviLink = new ParagraphElement();
    naviLink
        ..text = "-  $title"
        ..classes.add("navigation_link");
    return naviLink;
  }

  void onGenreTextMouseOver(MouseEvent event) {
    rectVisible = true;
  }

  void onGenreTextMouseOut(MouseEvent event) {
    rectVisible = false;
  }
}

part of topology_of_the_photography;

class ApplicationState {
  static ApplicationState _singleton = new ApplicationState._internal();
  ApplicationState._internal() {
    currentDetailViewState = DetailViewState.IMAGE_VIEW;
  }
  static ApplicationState get instance => _singleton;

  List<Genre> _genresList;

  List<Genre> get genresList => _genresList;
  set genresList(List<Genre> value) {
    _genresList = value;
    makeAllRectsInvisible();
    activateSubgenres(1);
    ApplicationState.instance.currentGenre = _genresList.first;
    ApplicationState.instance.currentGenre.parentViewbox
        .updateWrapperViewport();
  }

  void makeAllRectsInvisible() {
    for (TitledGenre genre
        in genresList.where((genre) => genre is TitledGenre)) {
      genre.rectVisible = false;
    }
  }

  Genre _currentGenre;

  set currentGenre(Genre clickedGenre) {
    Genre selectedGenre = getSelectedActiveGenre(clickedGenre);

    _currentGenre = selectedGenre;

    final int levelOfGenresToActivate = selectedGenre.level + 2;

    activateSubgenres(levelOfGenresToActivate);

    DivElement navigationDiv = ApplicationDomElements.instance.upperCorner;
    List<ParagraphElement> navigationLinks = selectedGenre.navigationLinks;
    navigationDiv.children.clear();
    for (ParagraphElement naviElement in navigationLinks) {
      navigationDiv.append(naviElement);
    }
  }

  Genre getSelectedActiveGenre(Genre value) {
    Genre selectedGenre = value;
    bool genreIsNotActive = !selectedGenre.active;
    while (genreIsNotActive) {
      selectedGenre = selectedGenre.parentGenre;
      genreIsNotActive = !selectedGenre.active;
    }
    return selectedGenre;
  }

  Genre get currentGenre => _currentGenre;

  void activateSubgenres(int levelOfGenresToActivate) {
    for (Genre genre in genresList) {
      bool genreHasLevelToActivate = genre.level <= levelOfGenresToActivate;

      genre.active = genreHasLevelToActivate;
    }
  }

  bool _leftInfoBoxActiv = false;
  set leftInfoBoxActiv(bool value) {
    _leftInfoBoxActiv = value;

    final DivElement leftInfo = ApplicationDomElements.instance.leftInfo;

    if (_leftInfoBoxActiv) {
      leftInfo.classes.add("active");
    } else {
      leftInfo.classes.remove("active");
    }
  }

  bool get leftInfoBoxActiv => _leftInfoBoxActiv;

  DetailViewState _currentDetailViewState;
  set currentDetailViewState(DetailViewState value) {
    _currentDetailViewState = value;

    ElementList infoBoxes = ApplicationDomElements.instance.infoBoxes;
    infoBoxes.forEach((DivElement box) => box.classes.remove("active"));

    switch (_currentDetailViewState) {
      case DetailViewState.IMAGE_VIEW:
        ApplicationDomElements.instance.genreDetailImageWrapper.classes
            .add("active");

        ApplicationDomElements.instance.detailImgSvg.attributes = {
          "stroke": "white",
          "y": "-15",
          "viewBox": "0 0 79 61"
        };
        ApplicationDomElements.instance.detailInfoSvg.attributes = {
          "stroke": "#454543",
          "y": "15",
          "viewBox": "0 0 50 50"
        };

        break;
      case DetailViewState.INFO_VIEW:
        ApplicationDomElements.instance.genreDetailInfoWrapper.classes
            .add("active");

        ApplicationDomElements.instance.detailImgSvg.attributes = {
          "stroke": "#454543",
          "y": "-15",
          "viewBox": "0 0 79 61"
        };
        ApplicationDomElements.instance.detailInfoSvg.attributes = {
          "stroke": "white",
          "y": "15",
          "viewBox": "0 0 50 50"
        };
        break;
    }
  }

  DetailViewState get currentDetailViewState => _currentDetailViewState;
}

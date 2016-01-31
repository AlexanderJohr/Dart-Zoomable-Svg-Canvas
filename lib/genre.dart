part of topology_of_the_photography;

class Genre {

  final int level;
  final GenreRect genreRect;
  ParagraphElement navigationLink;
  final Genre parentGenre;
  final GenreOverviewViewBox parentViewbox;
  bool _active = true;
  final String title;

  bool get canHover => this.level >= ApplicationState.instance.currentGenre.level;

  set active(bool value) {
    _active = value;
  }
  bool get active => _active;

  List<Genre> get parents {
    List<Genre> parentsBottomUp = new List<Genre>();

    Genre currentGenre = parentGenre;
    while (currentGenre != null) {
      parentsBottomUp.add(currentGenre);
      currentGenre = currentGenre.parentGenre;
    }
    List parentsTopDown = new List.from(parentsBottomUp.reversed);

    return parentsTopDown;
  }

  List<ParagraphElement> get navigationLinks {
    List<ParagraphElement> navigationLinks = new List<ParagraphElement>();
    List<Genre> parentsAndSelf = new List.from(parents)..add(this);
    for (Genre genre in parentsAndSelf) {
      navigationLinks.add(genre.navigationLink);
    }
    return navigationLinks;
  }

  Genre(svg.RectElement rectElement, String title, GenreOverviewViewBox genreOverviewViewBox, [this.parentGenre = null, this.level = 0])
      : genreRect = new GenreRect(rectElement, genreOverviewViewBox),
        parentViewbox = genreOverviewViewBox,
        title = title {
    navigationLink = createNavigationLink(title);
    genreRect.rectElement.onClick.listen(onGenreClick);
    navigationLink.onClick.listen(onGenreClick);
  }

  ParagraphElement createNavigationLink(String title) {

    ParagraphElement navigationLink = new ParagraphElement();
    navigationLink
        ..text = "$title"
        ..classes.add("navigation_link");
    return navigationLink;
  }


  void onGenreClick(MouseEvent event) {
    ApplicationState.instance.currentGenre = this;
    parentViewbox.desiredViewBox = ApplicationState.instance.currentGenre.genreRect.pos;
  }

  void onGenreMouseOver(MouseEvent event) {
    if (active && canHover) {
      String aktuell = "${title}";

      DivElement oldGenreDetailImage = ApplicationDomElements.instance.newGenreDetailImage;
      if (oldGenreDetailImage != null) {
        oldGenreDetailImage.classes.remove("visible");
        oldGenreDetailImage.classes.remove("new");
      }

      DivElement genreDetailImagePrefab = ApplicationDomElements.instance.genreDetailImagePrefab;
      DivElement newGenreDetailImage = genreDetailImagePrefab.clone(true);

      newGenreDetailImage.classes.remove("prefab");

      newGenreDetailImage.querySelector('.titel_bilderreihe').text = aktuell;

      HttpRequest request = new HttpRequest();
      request.open('GET', 'bilder.xml');
      request.onLoad.listen((ProgressEvent event) {
        Document responseXml = request.responseXml;
        ElementList genreImages = responseXml.querySelectorAll('bild[genre="${aktuell}"]');
        List<Element> genreImagesList = new List.from(genreImages);
        if (genreImages != null) {

          for (int i = 0; i < genreImagesList.length; i++) {
            Element genreImage = genreImages[i];

            Element subtitle = genreImage.querySelector('untertitel');
            Element path = genreImage.querySelector('pfad');

            String id = (i + 1).toString();
            ImageElement imageElem = newGenreDetailImage.querySelector(".img" + id) as ImageElement;
            imageElem.style.opacity = "0";

            imageElem
                ..attributes["height"] = "100%"
                ..attributes["class"] = "image"
                ..attributes["src"] = path.text
                ..attributes["alt"] = subtitle.text;

            imageElem.onMouseOver.listen(imageMouseOver);
            imageElem.onMouseOut.listen(imageMouseOut);

            AnchorElement link = newGenreDetailImage.querySelector(".imgLink" + id);
            link
                ..attributes["href"] = path.text
                ..attributes["data-title"] = subtitle.text
                ..attributes["data-lightbox"] = "image-set";

            imageElem.style.opacity = "1";
          }
          for (int i = genreImagesList.length; i < 12; i++) {
            String id = (i + 1).toString();
            ImageElement imageElem = newGenreDetailImage.querySelector(".img" + id) as ImageElement;
            imageElem.style.opacity = "0";
          }
        }
      });
      request.send();


      ApplicationDomElements.instance.genreDetailImageWrapper.append(newGenreDetailImage);

      new Timer(new Duration(milliseconds: 50), () => newGenreDetailImage.classes.add("new"));
      if (oldGenreDetailImage != null) {
        new Timer(new Duration(milliseconds: 1000), () => oldGenreDetailImage.remove());
      }
    }
  }

  void imageMouseOver(MouseEvent event) {
    ImageElement imageElement = event.target;
    if (imageElement.style.opacity == "1") {
      imageElement.style.opacity = "0.7";

      imageElement.parent.style.background = "purple";
    }
  }

  void imageMouseOut(MouseEvent event) {
    ImageElement image = event.target as ImageElement;
    image.style.opacity = "1";
  }

  void clearAllImages(MouseEvent event) {

    ElementList<ImageElement> listeAktuelleBilder = querySelectorAll('.image');

    for (ImageElement bild in listeAktuelleBilder) {
      bild.style.opacity = "0";
    }

    clearer();
  }
  void clearer() {
    ElementList<ImageElement> currentImages = querySelectorAll('.image');
    for (ImageElement image in currentImages) {
      image
          ..attributes["height"] = "0"
          ..attributes["class"] = "image"
          ..attributes["src"] = ""
          ..attributes["alt"] = "";
    }

    ElementList<AnchorElement> currentLinks = querySelectorAll('.image-link');

    for (AnchorElement link in currentLinks) {

      link
          ..attributes["href"] = ""
          ..attributes["data-title"] = ""
          ..attributes["data-lightbox"] = "";

    }
    ElementList<Element> violetDivs = querySelectorAll('.lila');
    for (Element e in violetDivs) {
      e.style.background = 'white';
    }
  }

  void showDescription(MouseEvent event) {
    if (active && canHover) {
      String aktuell = "${title}";


      DivElement oldGenreDetailInfo = ApplicationDomElements.instance.newGenreDetailInfo;
      if (oldGenreDetailInfo != null) {
        oldGenreDetailInfo.classes.remove("new");
      }

      DivElement genreDetailInfoPrefab = ApplicationDomElements.instance.genreDetailInfoPrefab;
      DivElement newGenreDetailInfo = genreDetailInfoPrefab.clone(true);

      newGenreDetailInfo.classes.remove("prefab");

      newGenreDetailInfo.querySelector('.titel_info').text = aktuell;


      ApplicationDomElements.instance.genreDetailInfoWrapper.append(newGenreDetailInfo);
      new Timer(new Duration(milliseconds: 50), () => newGenreDetailInfo.classes.add("new"));
      if (oldGenreDetailInfo != null) {
        new Timer(new Duration(milliseconds: 1000), () => oldGenreDetailInfo.remove());
      }

      HttpRequest request = new HttpRequest();
      request.open('GET', 'genres.xml');
      request.onLoad.listen((ProgressEvent event) {
        Document responseXml = request.responseXml;
        Element genre = responseXml.querySelector('genre[stroemung="${aktuell}"]');
        if (genre != null) {
          newGenreDetailInfo.querySelector(".gattungsnamenH5").text = "Gattung: ";
          newGenreDetailInfo.querySelector(".zeitraumH5").text = "Zeitraum: ";
          newGenreDetailInfo.querySelector(".programmatikH5").text = "Programmatik: ";
          newGenreDetailInfo.querySelector(".merkmaleH5").text = "Merkmale: ";
          newGenreDetailInfo.querySelector(".protagonistenH5").text = "Protagonisten: ";
          newGenreDetailInfo.querySelector(".zitateH5").text = "Zitate: ";
          newGenreDetailInfo.querySelector(".einfluesseH5").text = "Einflüsse: ";
          newGenreDetailInfo.querySelector(".auswirkungenH5").text = "Auswirkungen: ";

          newGenreDetailInfo.querySelector(".gattungsnamen").text = genre.querySelector('weitereNamen').text;

          newGenreDetailInfo.querySelector(".zeitraum").text = genre.querySelector('zeitraum').text;
          newGenreDetailInfo.querySelector(".programmatik").text = genre.querySelector('programmatik').text;
          newGenreDetailInfo.querySelector(".merkmale").text = genre.querySelector('merkmale').text;
          newGenreDetailInfo.querySelector(".protagonisten").text = genre.querySelector('protagonisten').text;
          newGenreDetailInfo.querySelector(".zitate").text = genre.querySelector('zitate').text;
          newGenreDetailInfo.querySelector(".einfluesse").text = genre.querySelector('einfluesse').text;
          newGenreDetailInfo.querySelector(".auswirkungen").text = genre.querySelector('auswirkungen').text;

        }
      });
      request.send();

      List<Element> elementeP = querySelectorAll(".beschreibung");
      for (Element e in elementeP) e.style.color = "black";
    }
  }

  void clearDescription(MouseEvent event) {
    List<Element> elementeP = querySelectorAll(".beschreibung");
    for (Element e in elementeP) e.style.color = "white";
  }
}

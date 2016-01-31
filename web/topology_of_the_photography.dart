import 'dart:svg';
import 'dart:html';

import 'package:topology_of_the_photography/topology_of_the_photography.dart';

List<GenreRect> genreRects = new List<GenreRect>();
List<GenreText> genreTexts = new List<GenreText>();

List<Gridline> gridlines = new List<Gridline>();
GenreOverviewViewBox viewBox;
void main() {
  final ApplicationDomElements dom = ApplicationDomElements.instance;
  final ApplicationState applicationState = ApplicationState.instance;

    
  viewBox = new GenreOverviewViewBox(dom.genreOverviewSvg, 1500, new Rectangle(0, 0, 2200, 1000));
  List<Genre> genresList = createGenresFromSvg(viewBox);
  applicationState.genresList = genresList;
  generateGrid();
  
  dom.leftCornerPlus.onClick.listen((e)=>ApplicationState.instance.leftInfoBoxActiv = !ApplicationState.instance.leftInfoBoxActiv);
  dom.detailInfoSvg.onClick.listen((e)=>applicationState.currentDetailViewState = DetailViewState.INFO_VIEW);
  dom.detailImgSvg.onClick.listen((e)=>applicationState.currentDetailViewState = DetailViewState.IMAGE_VIEW);
  dom.projectDescriptionLink.onClick.listen(onProjectDescriptionLinkClick);
}

List<Genre> createGenresFromSvg(GenreOverviewViewBox viewBox) {

  List<Genre> createdGenres = new List<Genre>();
  
  void createGenresFromDom(Element elementToSearchIn, [Genre parentGenre = null, int level = 0]) {
    List<Element> children = elementToSearchIn.children;

    Genre newGenreToSearchIn = parentGenre;
    for (Element child in children) {
      bool childIsGenre = child.attributes['class'] == "genre";
      int nextLevel = level;
      if (childIsGenre) {  
        nextLevel += 1;
        Element genre = child;
        
        Element genreRectElement = genre.children.firstWhere((child) => child.attributes['class'].contains("genre_rect"));

        bool isOverviewGenre = !genre.children.any((child) => child.attributes['class'] == "genre_title");


        if (isOverviewGenre) {
          newGenreToSearchIn = new Genre(genreRectElement, "Übersicht", viewBox, parentGenre, level);
          
        } else {
          Element genreTitleElement = genre.children.firstWhere((child) => child.attributes['class'] == "genre_title");
          newGenreToSearchIn = new TitledGenre(genreRectElement, genreTitleElement, viewBox, parentGenre, level);
        }
        createdGenres.add(newGenreToSearchIn);
      }
      
      createGenresFromDom(child, newGenreToSearchIn, nextLevel);
    }
  }

  Element root = querySelector('#genre_overview_svg');//.childNodes.where((child) => child.className == "genre");
  createGenresFromDom(root);
  return createdGenres;
}

void generateGrid() {

  for (int i = 0,
      idate = 1840; idate <= 2000; i += (2000 ~/ 15)) {
    TextElement textElement = new TextElement();

    textElement
        ..attributes["x"] = "${i}"
        ..attributes["y"] = "${25}"
        ..text = "${idate}"
        ..classes.add("griddate");
    idate += 10;

    ApplicationDomElements.instance.timelineSvg.append(textElement);
  }
}

void onProjectDescriptionLinkClick(MouseEvent event) {
  final ApplicationDomElements domElements = ApplicationDomElements.instance;
  
  bool isActive = domElements.rightInfo.classes.contains("active");
    if(isActive){
      domElements.rightInfo.classes.remove("active");
    } else{
      domElements.rightInfo.classes.add("active");
    }
}





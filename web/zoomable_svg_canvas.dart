import 'dart:html';

import 'dart:svg';

import '../lib/zoomable_svg_canvas.dart';

GenreOverviewViewBox genreOverviewViewBox;
List<GenreRect> genreRects = new List<GenreRect>();
List<Gridline> gridlines = new List<Gridline>();

void main() {
  genreOverviewViewBox = createViewBox();

  addAllRectsToGenreList();

  generateGrid();

}

void generateGrid() {

  for (int i = 0; i < 2000; i += 25) {
    LineElement lineElement = new LineElement();

    lineElement
        ..attributes["x1"] = "${0}"
        ..attributes["y1"] = "${i}"
        ..attributes["x2"] = "${2000}"
        ..attributes["y2"] = "${i}"
        ..classes.add("gridline");

    Gridline gridline = new Gridline(lineElement, genreOverviewViewBox);
    gridlines.add(gridline);

    genreOverviewViewBox.svgElement.append(lineElement);
  }
  for (int i = 0; i < 2000; i += 50) {
    LineElement lineElement = new LineElement();

    lineElement
        ..attributes["x1"] = "${i}"
        ..attributes["y1"] = "${0}"
        ..attributes["x2"] = "${i}"
        ..attributes["y2"] = "${2000}"
        ..classes.add("gridline");

    Gridline gridline = new Gridline(lineElement, genreOverviewViewBox);
    gridlines.add(gridline);

    genreOverviewViewBox.svgElement.append(lineElement);
  }
}

void addAllRectsToGenreList() {

  void addGenreRectToList(RectElement rect) {
    GenreRect rectToAdd = new GenreRect(rect, genreOverviewViewBox);
    genreRects.add(rectToAdd);
  }

  ElementList foundRectsInDom = querySelectorAll(".genre_rect");
  foundRectsInDom.forEach(addGenreRectToList);
}

GenreOverviewViewBox createViewBox() {

  SvgElement genreOverviewSvg = querySelector("#genre_overview_svg") as SvgElement;
  DivElement genreOverviewDiv = querySelector("#genre_overview") as DivElement;

  return new GenreOverviewViewBox(genreOverviewSvg, genreOverviewDiv, 1500);
}


part of topology_of_the_photography;

class ApplicationDomElements {

  static ApplicationDomElements _singleton = new ApplicationDomElements._internal();
  ApplicationDomElements._internal(){
  }
  static ApplicationDomElements get instance => _singleton;

  final svg.SvgElement viewboxSvg = querySelector("#viewbox_svg") as svg.SvgElement;
  final svg.SvgElement genreOverviewSvg = querySelector("#genre_overview_svg") as svg.SvgElement;
  final DivElement genreOverviewViewBoxDiv = querySelector("#genre_overview_viewbox") as DivElement;
  final svg.SvgElement timelineSvg = querySelector("#timeline_svg") as svg.SvgElement;
  final svg.RectElement backgroundRect = querySelector(".background_rect") as svg.RectElement;
  final DivElement upperCorner = querySelector("#upper_corner") as DivElement;
  final DivElement leftCorner = querySelector("#left_corner") as DivElement;
  final DivElement leftCornerPlus = querySelector("#left_corner_plus") as DivElement;
  final DivElement leftInfo = querySelector("#left_info") as DivElement;
  final svg.TextElement projectDescriptionLink = querySelector("#project_description_link") as svg.TextElement;
  final DivElement rightInfo = querySelector("#right_info") as DivElement;


  final svg.SvgElement detailImgSvg = querySelector("#detail_img_svg") as svg.SvgElement;
  final svg.SvgElement detailInfoSvg = querySelector("#detail_info_svg") as svg.SvgElement;
    

  final DivElement genreDetail = querySelector("#genre_detail") as DivElement;
  
  final DivElement genreDetailInfoWrapper = querySelector("#genre_detail_info_wrapper") as DivElement;
  final DivElement genreDetailImageWrapper = querySelector("#genre_detail_image_wrapper") as DivElement;

  ElementList get infoBoxes => querySelectorAll("#genre_detail_info_wrapper, #genre_detail_image_wrapper");
  DivElement get genreDetailInfo => querySelector(".genre_detail_info") as DivElement;
  DivElement get genreDetailImage => querySelector(".genre_detail_image") as DivElement;
  
  DivElement get newGenreDetailInfo => querySelector(".genre_detail_info.new") as DivElement;
  DivElement get newGenreDetailImage => querySelector(".genre_detail_image.new") as DivElement;

  DivElement get genreDetailInfoPrefab => querySelector(".genre_detail_info.prefab") as DivElement;
    DivElement get genreDetailImagePrefab => querySelector(".genre_detail_image.prefab") as DivElement;
}

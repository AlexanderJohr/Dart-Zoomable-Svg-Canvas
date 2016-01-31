part of topology_of_the_photography;

class DetailViewState {
  static const IMAGE_VIEW = const DetailViewState._(0);
  static const INFO_VIEW = const DetailViewState._(1);

  static get values => [IMAGE_VIEW, INFO_VIEW];

  final int value;

  const DetailViewState._(this.value);
}

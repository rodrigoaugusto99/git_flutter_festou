enum SpaceCardVmStateStatus { loaded, error }

class SpaceCardState {
  final SpaceCardVmStateStatus status;
  final List<String> imageUrls;

  SpaceCardState({
    required this.status,
    required this.imageUrls,
  });

  SpaceCardState copyWith({
    SpaceCardVmStateStatus? status,
    List<String>? imageUrls,
  }) {
    return SpaceCardState(
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

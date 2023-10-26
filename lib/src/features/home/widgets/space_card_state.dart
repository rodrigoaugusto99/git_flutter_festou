// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

enum SpaceCardVmStateStatus { loaded, error }

class SpaceCardState {
  final SpaceCardVmStateStatus status;
  final List<File> imageUrls;

  SpaceCardState({
    required this.status,
    required this.imageUrls,
  });

  SpaceCardState copyWith({
    SpaceCardVmStateStatus? status,
    List<File>? imageUrls,
  }) {
    return SpaceCardState(
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

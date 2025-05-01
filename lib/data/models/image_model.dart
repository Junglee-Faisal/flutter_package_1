import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({required super.id, required super.url, required super.width, required super.height, required super.boxCount});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      boxCount: json['box_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'width': width, 'height': height, 'box_count': boxCount};
  }
}

import '../entities/image_entity.dart';

abstract class ImageRepository {
  Future<List<ImageEntity>> getImageUrls();
  Future<dynamic> getImageContent();
}

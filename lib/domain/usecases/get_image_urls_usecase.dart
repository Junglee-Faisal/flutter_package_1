import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImageUrlsUseCase {
  final ImageRepository repository;

  GetImageUrlsUseCase(this.repository);

  Future<List<ImageEntity>> execute() {
    return repository.getImageUrls();
  }
}

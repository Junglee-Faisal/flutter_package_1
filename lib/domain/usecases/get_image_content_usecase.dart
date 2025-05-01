import '../repositories/image_repository.dart';

class GetImageContentUseCase {
  final ImageRepository repository;

  GetImageContentUseCase(this.repository);

  Future<dynamic> execute() {
    return repository.getImageContent();
  }
}

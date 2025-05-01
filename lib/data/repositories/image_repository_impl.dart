import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_data_source.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource dataSource;

  ImageRepositoryImpl({required this.dataSource});

  @override
  Future<List<ImageEntity>> getImageUrls() async {
    try {
      final result = await dataSource.getImageUrls();
      return result;
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }

  @override
  Future<dynamic> getImageContent() async {
    try {
      final result = await dataSource.getImageContent();
      return result;
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }
}

library flutter_package_1;

import 'core/service_locator.dart';

// Domain
export 'domain/entities/image_entity.dart';
export 'domain/repositories/image_repository.dart';
export 'domain/usecases/get_image_urls_usecase.dart';
export 'domain/usecases/get_image_content_usecase.dart';

// Data
export 'data/models/image_model.dart';
export 'data/datasources/image_data_source.dart';
export 'data/repositories/image_repository_impl.dart';

// Core
export 'core/service_locator.dart';

// Presentation
export 'presentation/screens/images_screen.dart';

/// A service class to access the image APIs
class ImageService {
  final _serviceLocator = ServiceLocator();
  
  /// Get image URLs from the API
  Future<List<dynamic>> getImageUrls() async {
    final useCase = _serviceLocator.getImageUrlsUseCase;
    return await useCase.execute();
  }
  
  /// Get image content from the API
  Future<dynamic> getImageContent() async {
    final useCase = _serviceLocator.getImageContentUseCase;
    return await useCase.execute();
  }
}
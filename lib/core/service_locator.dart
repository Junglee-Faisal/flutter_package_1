import 'package:http/http.dart' as http;

import '../data/datasources/image_data_source.dart';
import '../data/repositories/image_repository_impl.dart';
import '../domain/repositories/image_repository.dart';
import '../domain/usecases/get_image_content_usecase.dart';
import '../domain/usecases/get_image_urls_usecase.dart';

class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  // External dependencies
  http.Client get httpClient => http.Client();

  // Data sources
  ImageDataSource get imageDataSource => ImageRemoteDataSource(client: httpClient);

  // Repositories
  ImageRepository get imageRepository => ImageRepositoryImpl(dataSource: imageDataSource);

  // Use cases
  GetImageUrlsUseCase get getImageUrlsUseCase => GetImageUrlsUseCase(imageRepository);

  GetImageContentUseCase get getImageContentUseCase => GetImageContentUseCase(imageRepository);
}

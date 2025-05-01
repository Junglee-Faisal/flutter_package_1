import 'package:flutter/material.dart';
import 'package:flutter_package_1/core/service_locator.dart';
import 'package:flutter_package_1/domain/entities/image_entity.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final _serviceLocator = ServiceLocator();

  List<ImageEntity>? _images;
  dynamic _content;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images API Demo')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                children: [
                  ElevatedButton(onPressed: _loadImageUrls, child: const Text('Load Image URLs')),
                  ElevatedButton(onPressed: _loadImageContent, child: const Text('Load Image Content')),
                  Expanded(
                    child:
                        _images != null
                            ? ListView.builder(
                              itemCount: _images!.length,
                              itemBuilder: (context, index) {
                                final image = _images![index];
                                return ListTile(
                                  title: Text(image.url),
                                  subtitle: Text('ID: ${image.id}'),
                                  leading: Image.network(
                                    image.url,
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                  ),
                                );
                              },
                            )
                            : _content != null
                            ? Center(child: Text(_content.toString()))
                            : const Center(child: Text('No data loaded')),
                  ),
                ],
              ),
    );
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final getImagesUseCase = _serviceLocator.getImageUrlsUseCase;
      final images = await getImagesUseCase.execute();

      setState(() {
        _images = images;
        _content = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadImageContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final getContentUseCase = _serviceLocator.getImageContentUseCase;
      final content = await getContentUseCase.execute();

      setState(() {
        _content = content;
        _images = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}

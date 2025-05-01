import 'package:flutter/material.dart';
import 'package:flutter_package_1/flutter_package_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image API Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CustomImagesScreen(), // Using our custom screen
    );
  }
}

// Alternatively, you can create your own screen and use the service like this:
class CustomImagesScreen extends StatefulWidget {
  const CustomImagesScreen({super.key});

  @override
  _CustomImagesScreenState createState() => _CustomImagesScreenState();
}

class _CustomImagesScreenState extends State<CustomImagesScreen> {
  final ImageService _imageService = ImageService();
  List<ImageEntity>? _images;
  dynamic _content;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final images = await _imageService.getImageUrls();
      setState(() {
        _images = images.cast<ImageEntity>();
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
      final content = await _imageService.getImageContent();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nature Gallery'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadImageUrls)]),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _loadImageUrls,
                          icon: const Icon(Icons.image),
                          label: const Text('Images'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _images != null ? Colors.blue : Colors.grey.shade300,
                            foregroundColor: _images != null ? Colors.white : Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _loadImageContent,
                          icon: const Icon(Icons.content_copy),
                          label: const Text('Content'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _content != null ? Colors.blue : Colors.grey.shade300,
                            foregroundColor: _content != null ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(child: _buildContent()),
                ],
              ),
    );
  }

  Widget _buildContent() {
    if (_images != null && _images!.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _images!.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final image = _images![index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      image.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported, size: 50)),
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Image ${image.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Size: ${image.width} × ${image.height}', style: TextStyle(color: Colors.grey.shade700)),
                        if (image.boxCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Box count: ${image.boxCount}', style: TextStyle(color: Colors.grey.shade700)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (_content != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('API Response Content', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(_content.toString()),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: Text('No data available. Please load images or content.'));
    }
  }
}

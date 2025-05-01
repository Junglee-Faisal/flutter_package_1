import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/image_model.dart';

abstract class ImageDataSource {
  Future<List<ImageModel>> getImageUrls();
  Future<dynamic> getImageContent();
}

class ImageRemoteDataSource implements ImageDataSource {
  final http.Client client;

  ImageRemoteDataSource({required this.client});

  @override
  Future<List<ImageModel>> getImageUrls() async {
    final response = await client.get(Uri.parse('https://6813247a129f6313e2106069.mockapi.io/images/urls'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load image urls');
    }
  }

  @override
  Future<dynamic> getImageContent() async {
    final response = await client.get(Uri.parse('https://6813247a129f6313e2106069.mockapi.io/images/content'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load image content');
    }
  }
}

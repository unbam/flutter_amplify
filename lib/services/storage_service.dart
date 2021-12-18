import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

class StorageService {
  final imageUrlsController = StreamController<List<String>>();

  Future<void> getImages() async {
    try {
      final listOptions =
          S3ListOptions(accessLevel: StorageAccessLevel.private);

      final result = await Amplify.Storage.list(options: listOptions);

      final getUrlOptions =
          GetUrlOptions(accessLevel: StorageAccessLevel.private);

      final List<String> imageUrls =
          await Future.wait(result.items.map((item) async {
        final urlResult =
            await Amplify.Storage.getUrl(key: item.key, options: getUrlOptions);
        return urlResult.url;
      }));

      imageUrlsController.add(imageUrls);
    } catch (e) {
      debugPrint('Storage List error - $e');
    }
  }

  Future<void> uploadImageAtPath(String imagePath) async {
    final imageFile = File(imagePath);
    final imageKey = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.private);

      await Amplify.Storage.uploadFile(
          local: imageFile, key: imageKey, options: options);

      getImages();
    } catch (e) {
      debugPrint('upload error - $e');
    }
  }
}

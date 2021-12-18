import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/analytics_events.dart';
import '../services/analytics_service.dart';

///
/// ギャラリーページ
///
class GalleryPage extends StatelessWidget {
  GalleryPage(
      {Key? key,
      required this.shouldLogOut,
      required this.shouldShowCamera,
      required this.imageUrlsController})
      : super(key: key) {
    AnalyticsService.log(ViewGalleryEvent());
  }

  final StreamController<List<String>> imageUrlsController;
  final VoidCallback shouldLogOut;
  final VoidCallback shouldShowCamera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: shouldLogOut,
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      // 5
      floatingActionButton: FloatingActionButton(
        onPressed: shouldShowCamera,
        child: const Icon(Icons.camera_alt),
      ),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    return StreamBuilder<List<String>>(
      stream: imageUrlsController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data![index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No images to display.'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

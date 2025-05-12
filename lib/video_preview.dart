import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final AssetEntity asset;

  const VideoPreviewScreen({super.key, required this.asset});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final file = await widget.asset.file;
    if (file != null) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _controller?.play(); // Auto play if needed
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value.isInitialized ?? false) {
      print(_controller!.value.size.width);
      print(_controller!.value.size.height);
      return AspectRatio(
        aspectRatio: _controller!.value.size.height / _controller!.value.size.width,
        child: VideoPlayer(_controller!),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

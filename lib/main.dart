import 'package:flutter/material.dart';
import 'package:gallery_search/chewie_player.dart';
import 'package:gallery_search/video_preview.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  AssetEntity? searchedFileName;

  @override
  void initState() {
    super.initState();
    findSavedVideoByName('camera_poc');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: searchedFileName != null ? VideoPreviewScreen(asset: searchedFileName!) : const Text('Hello world'),
        ),
      ),
    );
  }

  Future<void> findSavedVideoByName(String fileName) async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      print('permission issue');
      return;
    }
    print('gggggggggggg');
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      filterOption: FilterOptionGroup(orders: [OrderOption(type: OrderOptionType.createDate, asc: false)]),
    );
    print('aaaaaaaaaaaaa');
    for (final album in albums) {
      final assets = await album.getAssetListPaged(page: 0, size: 100);
      for (final asset in assets) {
        final file = await asset.file;
        print(file?.path);
        if (file != null && file.path.contains(fileName)) {
          setState(() {
            searchedFileName = asset;
          });
        }
      }
    }

    print('object');
  }
}

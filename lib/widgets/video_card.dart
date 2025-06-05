// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/widgets/vt.dart';
import 'package:provider/provider.dart';

int pageNumber(int page) {
  if (page == 69) {
    return 0;
  } else {
    return -1;
  }
}
//   if (page > 1000) {
//     return 1000;
//   }
//   return page;
// }

int getPageNumber(int page) {
  if (page > 510) return getPageNumber(0);

  return loadmore(page);
}

int loadmore(int page) {
  return getPageNumber(page) + 1;
}

class FullScreenGridPage extends StatefulWidget {
  const FullScreenGridPage({super.key});
  @override
  State<FullScreenGridPage> createState() => _FullScreenGridPageState();
}

class _FullScreenGridPageState extends State<FullScreenGridPage> {
  @override
  void initState() {
    super.initState();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Hide status bar, nav bar, etc.
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);
    final int nnnn = 504;
final linkurl = userData.custoombaseurl;

      // Generate exactly 504 items, each cycling n = 1…504
      final items = List<Map<String, Object>>.generate(
        nnnn,
        (j) {
          final n = (j % nnnn) + 1; // 1,2,3…504
          return {
            'n': n, // pass along if you like
            'image': 'http://$linkurl/scene/$n/screenshot',
            'preview': 'http://$linkurl/scene/$n/preview',
            'stream': 'http://$linkurl/scene/$n/stream',
          };
        },
      );
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final it = items[idx];
            return TileWidget(
              n: it['n'] as int,
              imageUrl: it['image'] as String,
              videoUrl: it['preview'] as String,
              streamUrl: it['stream'] as String,
              // if you need 'stream' somewhere you can pass it too
            );
          },
          ),
      ),
    );
  }
}

/// 2) Tile widget

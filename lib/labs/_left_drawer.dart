

part of 'home_screen.dart';
class ComponentLibraryDrawer extends StatelessWidget {
  const ComponentLibraryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'COMPONENT LIBRARY',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.list, color: Colors.grey[400]),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.grid_view, color: Colors.grey[400]),
                    onPressed: () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('COMMON',
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              children: [
                _buildLibraryItem(Icons.home_rounded,'Home', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) =>  HomeScreenLab()),
    );
  }),
              _buildLibraryItem(
  Icons.show_chart,
  'Axes',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) =>  AxesInputPage()),
    );
  },
),


                _buildLibraryItem(Icons.smart_button, 'Button',onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CrawlerHomePage1()),
    );
  },
),
                _buildLibraryItem(Icons.check_box_outlined, 'Check Box', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CodeEditorIDE()),
    );
  },
),
                _buildLibraryItem(Icons.date_range_outlined, 'Date Picker', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LocalScreen()),
    );
  },
),
                _buildLibraryItem(
                    Icons.arrow_drop_down_circle_outlined, 'Drop Down',onTap:() => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimeGridScreen()))),
  
                _buildLibraryItem(
                    Icons.edit_note_outlined, 'Edit Field (Numeric)', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppKeeper()),
    );
  },
),
                _buildLibraryItem(
                    Icons.text_fields_outlined, 'Edit Field (Text)', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FavoritesScreen()),
    );
  },
),
                _buildLibraryItem(Icons.html_outlined, 'HTML', onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AIChatClient()),
    );
  },
),
                _buildLibraryItem(Icons.image_outlined, 'Image'),
                _buildLibraryItem(Icons.label_important_outline, 'Label'),
                _buildLibraryItem(Icons.list_alt_outlined, 'List Box'),
                _buildLibraryItem(
                    Icons.radio_button_checked_outlined, 'Radio Button Group'),
                _buildLibraryItem(Icons.linear_scale_outlined, 'Slider'),
                _buildLibraryItem(
                    Icons.onetwothree_outlined, 'Spinner'), // numbers_outlined
                _buildLibraryItem(Icons.toggle_on_outlined, 'State Button'),
                _buildLibraryItem(Icons.table_chart_outlined, 'Table'),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ...existing code...
  Widget _buildLibraryItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[400], size: 20),
      title:
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
      dense: true,
      onTap: onTap,
    );
  }
// ...existing code...
}
// In the ListView children:

// ...other items unchanged...
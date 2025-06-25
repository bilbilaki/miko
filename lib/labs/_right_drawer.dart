
part of 'home_screen.dart';
class ComponentBrowserDrawer extends StatelessWidget {
  const ComponentBrowserDrawer({super.key});

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
              'COMPONENT BROWSER',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                 contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              children: [
                _buildBrowserItem('app.figure1', icon: Icons.insights, isExpanded: true, children: [
                  _buildBrowserItem('app.Tcontour', indent: 1),
                  _buildBrowserItem('app.Tplot', indent: 1),
                ]),
                _buildBrowserItem('app.uipanel1', icon: Icons.crop_square, isExpanded: true, children: [
                  _buildBrowserItem('app.start', indent: 1),
                  _buildBrowserItem('app.stop', indent: 1),
                ]),
                 _buildBrowserItem('app.uipanel2', icon: Icons.crop_square, isExpanded: true, children: [
                  _buildBrowserItem('app.T_int', indent: 1),
                  _buildBrowserItem('app.T0', indent: 1),
                  _buildBrowserItem('app.T_top', indent: 1),
                  _buildBrowserItem('app.T1', indent: 1),
                  _buildBrowserItem('app.T_btm', indent: 1),
                  _buildBrowserItem('app.T2', indent: 1),
                  _buildBrowserItem('app.T_lft', indent: 1),
                  _buildBrowserItem('app.T3', indent: 1),
                  _buildBrowserItem('app.T_rht', indent: 1),
                  _buildBrowserItem('app.T4', indent: 1),
                ]),
                 _buildBrowserItem('app.uipanel3', icon: Icons.crop_square, isExpanded: true, children: [
                  _buildBrowserItem('app.L', indent: 1),
                  _buildBrowserItem('app.text6', indent: 1),
                  _buildBrowserItem('app.H', indent: 1),
                  _buildBrowserItem('app.text7', indent: 1),
                  _buildBrowserItem('app.dx', indent: 1),
                  _buildBrowserItem('app.text8', indent: 1),
                  _buildBrowserItem('app.dy', indent: 1),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowserItem(String label, {IconData? icon, int indent = 0, bool isExpanded = false, List<Widget> children = const []}) {
    if (children.isNotEmpty) {
      return ExpansionTile(
        leading: icon != null ? Icon(icon, size: 18, color: Colors.grey[400]) : SizedBox(width: 24.0 * (indent +1)), // Adjust for icon or indent
        title: Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 13)),
        tilePadding: EdgeInsets.only(left: 8.0 + (indent * 16.0), right: 8.0),
        childrenPadding: EdgeInsets.zero,
        iconColor: Colors.grey[400],
        collapsedIconColor: Colors.grey[400],
        initiallyExpanded: isExpanded,
        controlAffinity: ListTileControlAffinity.leading,
        children: children,
      );
    }
    return ListTile(
      leading: SizedBox(width: 24.0 * (indent +1)), // Indent for non-expandable items
      title: Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 13)),
      dense: true,
      contentPadding: EdgeInsets.only(left: 8.0 + (indent * 16.0), right: 8.0),
      onTap: () {},
    );
  }
}
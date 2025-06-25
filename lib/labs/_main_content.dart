// _main_content.dart
part of 'home_screen.dart';

// This helper function is no longer strictly needed by the AppBar
// as the TabController is passed directly.
// You can remove it if it's not used elsewhere.
/*
TabController _getMainContentAreaTabController(BuildContext context) {
  final _HomeScreenState? state = context.findAncestorStateOfType<_HomeScreenState>();
  assert(state != null, "HomeScreenState not found in context");
  return state!._tabController;
}
*/

Widget _buildMainContentArea(BuildContext context, TabController tabController) {
  return Column(
    children: [
      Expanded(
        child: TabBarView(
          controller: tabController, // This was already correct
          children: [
            _buildDesignView(context),
            Center(child: Text('Code View (Not Implemented)', style: TextStyle(color: Colors.grey[400]))),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDesignView(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isWideScreen = screenWidth > 800;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          margin: const EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Center(
            child: Text(
              'Transient Heat Conduction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildInitialAndBoundaryConditionsPanel(context),
                    const SizedBox(height: 20),
                    _buildThermalDiffusivityPanel(context),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildGeometryPanel(context),
                    const SizedBox(height: 10),
                    const PlotPlaceholder(aspectRatio: 16/7, label: 'Plot 1 (Contour)'),
                    const SizedBox(height: 20),
                    _buildTimeAndConvergencePanel(context),
                    const SizedBox(height: 10),
                    const PlotPlaceholder(aspectRatio: 16/7, label: 'Plot 2 (Convergence)'),
                  ],
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildInitialAndBoundaryConditionsPanel(context),
              const SizedBox(height: 20),
              _buildGeometryPanel(context),
              const SizedBox(height: 10),
              const PlotPlaceholder(aspectRatio: 16/7, label: 'Plot 1 (Contour)'),
              const SizedBox(height: 20),
              _buildThermalDiffusivityPanel(context),
              const SizedBox(height: 20),
              _buildTimeAndConvergencePanel(context),
              const SizedBox(height: 10),
              const PlotPlaceholder(aspectRatio: 16/7, label: 'Plot 2 (Convergence)'),
            ],
          ),

        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: const Text('Stop'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
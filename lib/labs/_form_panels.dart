part of 'home_screen.dart';

Widget _buildSectionCard({required BuildContext context, required String title, required List<Widget> children}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 1.0), // Minimal margin to stack cleanly
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
      side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[200])),
          Column(
          children: [
          const SizedBox(height: 12),

          ...children,],
      )],
      ),
    ),
  );
}

Widget _buildInitialAndBoundaryConditionsPanel(BuildContext context) {
  return _buildSectionCard(
    context: context,
    title: 'Initial and Boundary Conditions',
    children: [
      const LabeledNumericInput(label: 'Initial T (C):', initialValue: '10', fieldWidth: 80),
      const LabeledNumericInput(label: 'Top T (C):', initialValue: '0', fieldWidth: 80),
      const LabeledNumericInput(label: 'Bottom T (C):', initialValue: '50', fieldWidth: 80),
      const LabeledNumericInput(label: 'Left T (C):', initialValue: '25', fieldWidth: 80),
      const LabeledNumericInput(label: 'Right T (C):', initialValue: '25', fieldWidth: 80),
    ],
  );
}

Widget _buildGeometryPanel(BuildContext context) {
  return _buildSectionCard(
    context: context,
    title: 'Geometry',
    children: [
      const LabeledNumericInput(label: 'x (m):', initialValue: '0.05', fieldWidth: 80),
      const LabeledNumericInput(label: 'y (m):', initialValue: '0.05', fieldWidth: 80),
      const LabeledNumericInput(label: 'dx (m):', initialValue: '0.0025', fieldWidth: 80),
      const LabeledNumericInput(label: 'dy (m):', initialValue: '0.0025', fieldWidth: 80),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 100, // Match typical input width
          height: 36, // Match typical input height
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).dividerColor),
              padding: const EdgeInsets.symmetric(horizontal: 10)
            ),
            child: Text('f_x', style: TextStyle(color: Colors.grey[300])),
          ),
        ),
      )
    ],
  );
}

Widget _buildThermalDiffusivityPanel(BuildContext context) {
  String? selectedMaterial = 'Air'; // Default value
  return _buildSectionCard(
    context: context,
    title: 'Thermal Diffusivity',
    children: [
      const LabeledNumericInput(label: 'Alpha (m^2/s):', initialValue: '1e-4', fieldWidth: 100),
      const SizedBox(height: 10),
      // Custom Dropdown styled like ListBox
      Container(
        height: 150, // Fixed height for the list box
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).inputDecorationTheme.fillColor,
        ),
        child: ListView(
           controller: _HomeScreenLabState().thermalScrollController,
                    shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
                   

          children: ['Air', 'Copper', 'Water'].map((material) {
            return ListTile(
              
              title: Text(material, style: TextStyle(fontSize: 13, color: Colors.grey[300])),
              dense: true,
              selected: selectedMaterial == material,
              selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.3),
              onTap: () {
             //    setState(() { selectedMaterial = material; }); // Would need StatefulWidget
                print("$material selected");
              },
            );
          }).toList(),
        ),
      )
    ],
  );
}

Widget _buildTimeAndConvergencePanel(BuildContext context) {
  return _buildSectionCard(
    context: context,
    title: 'Time and Convergance', // Typo from image: "Convergance"
    children: [
      const LabeledNumericInput(label: 'dt (s):', initialValue: '0.01', fieldWidth: 100),
      const LabeledNumericInput(label: 'Total Time (s):', initialValue: '50', fieldWidth: 100),
      const LabeledNumericInput(label: 'Convergence Criterion:', initialValue: '1e-4', fieldWidth: 100),
    ],
  );
}
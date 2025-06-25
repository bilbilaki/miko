part of 'home_screen.dart';

class PlotPlaceholder extends StatelessWidget {
  final double aspectRatio;
  final String label;
  final Widget? child;

  const PlotPlaceholder({
    super.key,
    this.aspectRatio = 16 / 9,
    required this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: child ?? Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ),
      ),
    );
  }
}
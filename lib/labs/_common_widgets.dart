part of 'home_screen.dart';

class LabeledNumericInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final double? fieldWidth;
  final ValueChanged<String>? onChanged;

  const LabeledNumericInput({
    super.key,
    required this.label,
    required this.initialValue,
    this.fieldWidth,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible( // Allow label to take space but not overflow
            flex: 3, // Adjust flex factor as needed
            child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[300])),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: fieldWidth ?? 100,
            height: 36, // Consistent height for inputs
            child: TextFormField(
              initialValue: initialValue,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 13, color: Colors.grey[200]),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                isDense: true,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
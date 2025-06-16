import 'package:flutter/material.dart';

class HeaderSelector extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<String> selectedHeaders;
  final Function(List<String>) onHeadersChanged;
  final bool singleSelect;

  const HeaderSelector({
    super.key,
    required this.title,
    required this.headers,
    required this.selectedHeaders,
    required this.onHeadersChanged,
    this.singleSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFF262F3D),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: [
              ...selectedHeaders.map((header) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(header),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          final newHeaders = List<String>.from(selectedHeaders);
                          newHeaders.remove(header);
                          onHeadersChanged(newHeaders);
                        },
                        child: Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: headers.length,
              itemBuilder: (context, index) {
                final header = headers[index];
                final isSelected = selectedHeaders.contains(header);
                
                return CheckboxListTile(
                  title: Text(header),
                  value: isSelected,
                  onChanged: (_) {
                    List<String> newHeaders;
                    if (isSelected) {
                      newHeaders = selectedHeaders.where((h) => h != header).toList();
                    } else {
                      if (singleSelect) {
                        newHeaders = [header];
                      } else {
                        newHeaders = List<String>.from(selectedHeaders)..add(header);
                      }
                    }
                    onHeadersChanged(newHeaders);
                  },
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
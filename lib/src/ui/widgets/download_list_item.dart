// // lib/ui/download_list_item.dart
// // (Expanded controls: pause/resume/cancel/retry/delete and display percent/bytes when available)

// import 'package:flutter/material.dart';
// import 'package:miko/providers/downlooad.dart';

// class DownloadListItem extends StatelessWidget {
//   final  record;
//   final VoidCallback? onDelete;
//   final VoidCallback? onCancel;
//   final VoidCallback? onPause;
//   final VoidCallback? onResume;
//   final VoidCallback? onRetry;

//   const DownloadListItem({
//     super.key,
//     required this.record,
//     this.onDelete,
//     this.onCancel,
//     this.onPause,
//     this.onResume,
//     this.onRetry,
//   });

//   String _formatBytes(int bytes) {
//     if (bytes <= 0) return '0 B';
//     const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
//     var i = 0;
//     double size = bytes.toDouble();
//     while (size >= 1024 && i < suffixes.length - 1) {
//       size /= 1024;
//       i++;
//     }
//     return '${size.toStringAsFixed(size >= 100 ? 0 : (size >= 10 ? 1 : 2))} ${suffixes[i]}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = record.task?.filename.isNotEmpty == true
//         ? record.task!.filename
//         : record.taskId;
//     final subtitle = _subtitleFor(record);

//     return Material(
//       color: const Color(0xFF16161A),
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               _thumb(),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       subtitle,
//                       style: TextStyle(color: Colors.grey[400], fontSize: 13),
//                     ),
//                     const SizedBox(height: 8),
//                     _progressBar(context),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _actionButtons(),
//                   const SizedBox(height: 6),
//                   _sizeLabel(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _thumb() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: 72,
//         height: 72,
//         color: Colors.black,
//         child: record.task?.metaData != null
//             ? Image.network(
//                 record.task!.metaData!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => _icon(),
//               )
//             : _icon(),
//       ),
//     );
//   }

//   Widget _icon() {
//     return const Center(
//       child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 36),
//     );
//   }

//   Widget _progressBar(BuildContext context) {
//     final p = (record.progress).clamp(0.0, 1.0);
//     if (record.status == TaskStatus.running ||
//         record.status == TaskStatus.queued ||
//         record.status == TaskStatus.paused) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LinearProgressIndicator(
//             value: (record.status == TaskStatus.queued) ? null : p,
//             backgroundColor: Colors.white12,
//             valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00C853)),
//             minHeight: 6,
//           ),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 _progressLabel(),
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               if (record.status == TaskStatus.running && onCancel != null)
//                 TextButton(
//                   onPressed: onCancel,
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     backgroundColor: Colors.white12,
//                     minimumSize: Size.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       );
//     } else {
//       // completed/failed/canceled
//       final label = record.status == TaskStatus.complete
//           ? 'Completed'
//           : record.status.name;
//       return Text(
//         label,
//         style: const TextStyle(fontSize: 12, color: Colors.grey),
//       );
//     }
//   }

//   String _progressLabel() {
//     final pPercent = (record.progress * 100).toStringAsFixed(0);
//     if (record.expectedFileSize != null && record.expectedFileSize! > 0) {
//       final downloaded = (record.expectedFileSize! * record.progress).toInt();
//       return '${_formatBytes(downloaded)} / ${_formatBytes(record.expectedFileSize!)} • $pPercent%';
//     }
//     return '$pPercent%';
//   }

//   Widget _actionButtons() {
//     switch (record.status) {
//       case TaskStatus.running:
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.pause_circle, color: Colors.white70),
//               onPressed: onPause,
//             ),
//             IconButton(
//               icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
//               onPressed: onCancel,
//             ),
//           ],
//         );
//       case TaskStatus.paused:
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.play_circle_fill, color: Colors.white70),
//               onPressed: onResume,
//             ),
//             IconButton(
//               icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
//               onPressed: onCancel,
//             ),
//           ],
//         );
//       case TaskStatus.queued:
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
//               onPressed: onCancel,
//             ),
//           ],
//         );
//       case TaskStatus.failed:
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.white70),
//               onPressed: onRetry,
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//               onPressed: onDelete,
//             ),
//           ],
//         );
//       case TaskStatus.complete:
//         return IconButton(
//           icon: const Icon(Icons.delete_outline, color: Colors.greenAccent),
//           onPressed: onDelete,
//         );
//       case TaskStatus.canceled:
//         return IconButton(
//           icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//           onPressed: onDelete,
//         );
//     }
//   }

//   Widget _sizeLabel() {
//     if (record.expectedFileSize != null && record.expectedFileSize! > 0) {
//       return Text(
//         _formatBytes(record.expectedFileSize!),
//         style: const TextStyle(color: Color(0xFF00C853)),
//       );
//     } else {
//       return Text(
//         '${(record.progress * 100).toStringAsFixed(0)}%',
//         style: const TextStyle(color: Color(0xFF00C853)),
//       );
//     }
//   }

//   String _subtitleFor(DownloadRecord r) {
//     switch (r.status) {
//       case TaskStatus.running:
//         return 'Downloading...';
//       case TaskStatus.queued:
//         return 'Queued';
//       case TaskStatus.paused:
//         return 'Paused';
//       case TaskStatus.complete:
//         return 'Completed';
//       case TaskStatus.canceled:
//         return 'Canceled';
//       case TaskStatus.failed:
//         return 'Failed';
//     }
//   }
// }

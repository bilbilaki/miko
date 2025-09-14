// // lib/src/ui/collections_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:miko/providers/collection_provider.dart';
// import 'package:miko/src/ui/widgets/collection_details.dart';

// class CollectionsPage extends ConsumerWidget {
//   const CollectionsPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final collections = ref.watch(collectionsNotifierProvider);

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Collections')),
// //       body: ListView.builder(
// //         itemCount: collections.length,
// //         itemBuilder: (context, index) {
// //           final c = collections[index];
// //           return ListTile(
// //             leading: c.coverPath != null
// //                 ? Image.network(c.coverPath!, width: 56, fit: BoxFit.cover)
// //                 : const Icon(Icons.list),
// //             title: Text(c.name),
// //             subtitle: Text(
// //               '${c.items.length} items • updated ${_timeAgo(c.updatedAt)}',
// //             ),
// //             onTap: () {
// //               Navigator.of(context).push(
// //                 MaterialPageRoute(
// //                   builder: (_) => CollectionDetailPage(collectionId: c.id),
// //                 ),
// //               );
// //             },
// //             trailing: IconButton(
// //               icon: const Icon(Icons.delete),
// //               onPressed: () async {
// //                 await ref
// //                     .read(collectionsNotifierProvider.notifier)
// //                     .deleteCollection(c.id);
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: const Icon(Icons.add),
// //         onPressed: () async {
// //           final nameController = TextEditingController();
// //           final res = await showDialog<String?>(
// //             context: context,
// //             builder: (ctx) => AlertDialog(
// //               title: const Text('New Collection'),
// //               content: TextField(
// //                 controller: nameController,
// //                 decoration: const InputDecoration(labelText: 'Name'),
// //               ),
// //               actions: [
// //                 TextButton(
// //                   onPressed: () => Navigator.pop(ctx),
// //                   child: const Text('Cancel'),
// //                 ),
// //                 TextButton(
// //                   onPressed: () =>
// //                       Navigator.pop(ctx, nameController.text.trim()),
// //                   child: const Text('Create'),
// //                 ),
// //               ],
// //             ),
// //           );
// //           if (res != null && res.isNotEmpty) {
// //             await ref
// //                 .read(collectionsNotifierProvider.notifier)
// //                 .createCollection(name: res);
// //           }
// //         },
// //       ),
// //     );
// //   }

// //   String _timeAgo(int epochMs) {
// //     final dt = DateTime.fromMillisecondsSinceEpoch(
// //       epochMs,
// //       isUtc: true,
// //     ).toLocal();
// //     final diff = DateTime.now().difference(dt);
// //     if (diff.inDays >= 1) return '${diff.inDays}d ago';
// //     if (diff.inHours >= 1) return '${diff.inHours}h ago';
// //     if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
// //     return 'just now';
// //   }


// //     Widget _buildEmptyState(BuildContext context) {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Lottie.asset(
// //           'assets/Lottie/no_schedule.json', // Placeholder, replace with your Lottie animation
// //           repeat: true,
// //           height: 150,
// //           width: 150,
// //         ),
// //         const SizedBox(height: 24),
// //         const Text(
// //           'No Release Schedule',
// //           style: TextStyle(
// //             color: Color(0xFF1ED760),
// //             fontSize: 22,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         const Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 32.0),
// //           child: Text(
// //             'Sorry, there is no anime release schedule on this date',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(color: Colors.white70, fontSize: 14),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

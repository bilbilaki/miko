import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/utils/colors.dart';

class CastPage extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const CastPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<CastPage> createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  final MovieService _movieService = MovieService();
  late Future<MovieCredits> _creditsFuture;

  @override
  void initState() {
    super.initState();
    _fetchCredits();
  }

  void _fetchCredits() {
    _creditsFuture = _movieService.getMovieCredits(movieId: widget.movieId);
  }

  @override
  void dispose() {
    _movieService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cast of ${widget.movieTitle}'),
        centerTitle: true,
      ),
      body: FutureBuilder<MovieCredits>(
        future: _creditsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load cast.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _fetchCredits();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.cast.isNotEmpty) {
            final cast = snapshot.data!.cast;
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: cast.length,
              itemBuilder: (context, index) {
                return _CastCard(castMember: cast[index]);
              },
            );
          } else {
            return const Center(child: Text('No cast information available.'));
          }
        },
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast castMember;

  const _CastCard({required this.castMember});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(
              personId: castMember.id,
              initialName: castMember.name,
              initialProfilePath: castMember.profilePath,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'person-${castMember.id}',
                child: castMember.profilePath != null
                    ? CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        imageUrl: castMember.fullProfilePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.person,
                              size: 40, color: AppColors.secondaryText),
                        ),
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.person,
                            size: 40, color: AppColors.secondaryText),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    castMember.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    castMember.character,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/screens/genre_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/providers/anime_provider.dart';
import 'package:miko/widgets/anime_series_card.dart'; // Assuming you have AnimeCard
import 'package:provider/provider.dart';
//import 'package:miko/models/movie.dart' as movie;
import 'package:miko/models/tv_series_anime.dart';

import 'package:miko/utils/colors.dart';


class GenreDetailScreen extends StatelessWidget {
  final String genre;

  const GenreDetailScreen({required this.genre, super.key});

  @override
  Widget build(BuildContext context) {
    // Get items matching the genre
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
    final animeProvider = Provider.of<AnimeProvider>(context, listen: false); // If you have anime

    final List<Movie> moviesInGenre = movieProvider.animeseriesForDisplay
        .where((m) => m.genres.any((g) => g.toLowerCase() == genre.toLowerCase()))
        .toList();

    final List<TvSeriesAnime> tvSeriesInGenre = tvProvider.animeseriesForDisplay // Use seriesForDisplay to respect potential sorting/filtering
        .where((s) => s.genres.any((g) => g.toLowerCase() == genre.toLowerCase()))
        .toList();

    final List<TvSeriesAnime> animeInGenre = animeProvider.animeseriesForDisplay // Adjust for your Anime model/provider
        .where((a) => a.genres.any((g) => g.toLowerCase() == genre.toLowerCase()))
        .toList();

    // Combine all items
    final List<dynamic> allItemsInGenre = [...moviesInGenre, ...tvSeriesInGenre, ...animeInGenre];
    allItemsInGenre.shuffle(); // Optional: Mix movies and TV shows


    return Scaffold(
       backgroundColor: AppColors.primaryBackground,
       appBar: AppBar(
         title: Text(genre, style: TextStyle(color: AppColors.primaryText)),
         backgroundColor: const Color.fromARGB(255, 62, 27, 90),
       ),
       body: allItemsInGenre.isEmpty
           ? Center(
               child: Text(
                 'No items found for the genre "$genre".',
                 style: const TextStyle(color: Color.fromARGB(255, 230, 225, 225)),
               ),
             )
            : MasonryGridView.count( // Use MasonryGrid for mixed content might look odd, consider separate lists or tabs
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: allItemsInGenre.length,
                itemBuilder: (context, index) {
                  final item = allItemsInGenre[index];
                   if (item is Movie) {
                     return MovieCard(movie: item, typec: "movie",);
                   } else if (item is TvSeriesAnime) {
                     return AnimeSeriesCard(series: item, typec: "anime",);
                   } 
                   
                   else if (item is TvSeriesAnime) { // Assuming AnimeCard exists
                     return AnimeSeriesCard(series: item,typec: "tvseries"); // Adapt as needed
                   }
                   return const SizedBox.shrink(); // Should not happen
                },
              ),
    );
  }
}

class GenreListScreen extends StatelessWidget {
  const GenreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access providers to get genres
    // Use watch to rebuild if providers load/change (though unlikely after initial load)
    final movieProvider = Provider.of<MovieProvider>(context);
    final tvProvider = Provider.of<TvSeriesProvider>(context);
    final animeProvider =
        Provider.of<AnimeProvider>(context); // Assuming you have AnimeProvider

    // Combine genres from all sources and make unique
    final Set<String> allGenres = {};
    allGenres.addAll(movieProvider.animeseriesForDisplay
        .expand((m) => m.genres)
        .where((g) => g.isNotEmpty));
    allGenres.addAll(tvProvider.animeseriesForDisplay
        .expand((s) => s.genres)
        .where((g) => g.isNotEmpty));
    allGenres.addAll(animeProvider.animeseriesForDisplay
        .expand((a) => a.genres)
        .where((g) => g.isNotEmpty)); // Adapt for Anime model

    // Convert set to sorted list
    final sortedGenres = allGenres.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final Map<String, String> genreImageMap = {
      'Action': 'assets/action.jpg',
      'Action & Adventure': 'assets/action&adventure.jpg',
      'Adventure': 'assets/adventure.jpg',
      'Animation': 'assets/animation.jpg',
      'Comedy': 'assets/comedy.jpg',
      'Crime': 'assets/crime.jpg',
      'Documentary': 'assets/dcumentary.jpg',
      'Drama': 'assets/drama.jpg',
      'Family': 'assets/family.jpg',
      'Fantasy': 'assets/fantasy.jpg',
      'History': 'assets/history.jpg',
      'Horror': 'assets/horror.jpg',
      'Kids': 'assets/kids.jpg',
      'Music': 'assets/music.jpg',
      'Mystery': 'assets/mystery.jpg',
      'News': 'assets/news.jpg',
      'Reality': 'assets/reality.jpg',
      'Romance': 'assets/romance.jpg',
      'Sci-Fi & Fantasy': 'assets/scifantasy.jpg',
      'Western': 'assets/western.jpg',
      'Science Fiction': 'assets/sciencefiction.jpg',
      'War & Politics': 'assets/war&p.jgp',
      'War': 'assets/war.jpg',
      'Thriller': 'assets/thriller.jpg',
      'TV Movie': 'assets/tvm.jpg',
      'Soap': 'assets/soup.jpg',
      'Talk': 'assets/talk.jpg'

      // ... etc.
    };

// In BoxDecoration:

    // ... colorFilter if needed

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      // No AppBar needed if it's part of AppShell's IndexedStack
      body: sortedGenres.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 4, 75, 255)))
          : sortedGenres.isEmpty
              ? const Center(
                  child: Text('No genres found.',
                      style:
                          TextStyle(color: Color.fromARGB(255, 241, 241, 241))))
              : GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Or 3
                    childAspectRatio:
                        3 / 1, // Adjust aspect ratio for genre chips/cards
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: sortedGenres.length,
                  itemBuilder: (context, index) {
                    final genre = sortedGenres[index];
                    debugPrint(genre);
                    final imagePath = genreImageMap[genre] ??
                        'assets/default.jpg'; // fallback if not found

                    return InkWell(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GenreDetailScreen(genre: genre)));
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              const Color.fromARGB(40, 78, 54, 81)
                                  .withOpacity(0.3),
                              BlendMode.srcATop,
                            ),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              const Color.fromARGB(179, 255, 255, 255)
                                  .withOpacity(0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            genre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(color: Colors.black38, blurRadius: 2)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
                  },
                ),
    );
  }
}

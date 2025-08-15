import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/widgets/anime_series_card.dart';
import 'package:provider/provider.dart';


import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

 @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
    final animeProvider = Provider.of<AnimeProvider>(context, listen: false);
    final watchlistMovies = userData.watchlistMovieIds
        .map((id) => movieProvider.getMovieById(id))
        .whereType<Movie>()
        .toList();

     final watchlistTvSeries = userData.watchlistTvSeriesIds
        .map((id) => tvProvider.getAnimeByTmdbId(id))
          .whereType<TvSeriesAnime>()
          .toList();

       final watchlistAnime = userData.watchlistAnimeIds
        .map((id) => animeProvider.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>() // Filter out nulls if movie not found
        .toList();

    final allWatchlist = [...watchlistMovies, ...watchlistTvSeries, ...watchlistAnime];
     allWatchlist.sort((a, b) { // Optional sort
    String nameA;
    if (a is Movie) {
      nameA = a.title;
    } 
    else if (a is TvSeriesAnime) {
      nameA = a.name;
    } else {
      nameA = (a as TvSeriesAnime).name; // Assuming Anime model has a 'title' or 'name' field
    }

    String nameB;
    if (b is Movie) {
      nameB = b.title;
    } 
     else if (b is TvSeriesAnime) {
       nameB = b.name;
   }
     else {
      nameB = (b as TvSeriesAnime).name; // Assuming Anime model has a 'title' or 'name' field
    }
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Watchlist', style: TextStyle(color: AppColors.primaryText)),
         backgroundColor: const Color.fromARGB(255, 62, 27, 90),
      ),
      body: allWatchlist.isEmpty
          ? const Center(
              child: Text(
                'Your watchlist is empty.',
                style: TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
              ),
            )
          : MasonryGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 3, // Adjust columns as needed
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemCount: allWatchlist.length,
              itemBuilder: (context, index) {
                final item = allWatchlist[index];
                if (item is Movie) {
return MovieCard(movie: item, typec: "movie",);
                }
                else if (item is TvSeriesAnime) {
                  return AnimeSeriesCard(series: item, typec: "anime",);
                } 
                else if (item is TvSeriesAnime) {
return AnimeSeriesCard(series: item, typec:"tvseries");
               }
                return const SizedBox.shrink(); // Should not happen
              },
            ),
    );
  }
}
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);
    final movieProvider = Provider.of<MovieProvider>(context,
        listen: false); // don't listen if list is static
    final tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
    final animeProvider = Provider.of<AnimeProvider>(context, listen: false);

    // Get favorite items
    final favoriteMovies = userData.favoriteMovieIds
        .map((id) => movieProvider.getMovieById(id))
        .whereType<Movie>() // Filter out nulls if movie not found
        .toList();
    final favoriteAnime = userData.favoriteAnimeIds
        .map((id) => animeProvider.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>() // Filter out nulls if movie not found
        .toList();

     final favoriteTvSeries = userData.favoriteAnimeIds
        .map((id) => tvProvider.getAnimeByTmdbId(id))
         .whereType<TvSeriesAnime>() // Filter out nulls
        .toList();

    // Combine and sort (optional, e.g., alphabetically)
    final allFavorites = [
      ...favoriteMovies,
      ...favoriteTvSeries,
      ...favoriteAnime
    ];
    allFavorites.sort((a, b) {
      String nameA;
      if (a is Movie) {
        nameA = a.title;
           } else if (a is TvSeriesAnime) {
          nameA = a.name;
      } else {
        nameA = (a as TvSeriesAnime)
            .name; // Assuming Anime model has a 'title' or 'name' field
      }

      String nameB;
      if (b is Movie) {
        nameB = b.title;
         } else if (b is TvSeriesAnime) {
           nameB = b.name;
      } else {
        nameB = (b as TvSeriesAnime)
            .name; // Assuming Anime model has a 'title' or 'name' field
      }

      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Favorites',
            style: TextStyle(color: AppColors.primaryText)),
        backgroundColor: const Color.fromARGB(255, 62, 27, 90),
      ),
      body: allFavorites.isEmpty
          ? const Center(
              child: Text(
                'No items added to favorites yet.',
                style: TextStyle(color: Color.fromARGB(255, 230, 225, 225)),
              ),
            )
          : MasonryGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 3, // Adjust columns as needed
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemCount: allFavorites.length,
              itemBuilder: (context, index) {
                final item = allFavorites[index];
                if (item is Movie) {
                  return MovieCard(movie: item, typec: "movie");
                } else if (item is TvSeriesAnime) {
                  return AnimeSeriesCard(series: item, typec: "anime",);
                }

                else if (item is TvSeriesAnime) {
                  return AnimeSeriesCard(series: item,typec: "tvseries",);
                }
                return const SizedBox.shrink(); // Should not happen
              },
            ),
    );
  }
}
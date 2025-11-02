# Widget Refactoring Guide

## Overview

This document describes the widget extraction performed on `movie_detail_page_copy.dart` and `tv_detail_page_anime.dart`. Large detail pages have been refactored into smaller, reusable components while maintaining all functionality and styling.

## Summary of Changes

### Shared Utilities Created

#### 1. TranslationMixin (`lib/showcases/mixins/translation_mixin.dart`)
A mixin providing translation functionality for titles and overviews.

**Properties:**
- `translatedTitle` - The translated title (null if not translated)
- `isTranslating` - Boolean indicating translation in progress
- `overviewText` - The current overview text

**Methods:**
- `initializeOverview(String text)` - Initialize overview
- `translateTitle(String original)` - Translate a title
- `clearTranslatedTitle()` - Clear translation
- `toggleTitleTranslation(String originalTitle)` - Toggle translation on/off
- `translateOverview(String original)` - Translate overview text

**Usage:**
```dart
class _MovieDetailPageState extends State<MovieDetailPage> with TranslationMixin {
  // Access mixin properties
  Text(translatedTitle ?? movie.title)
  
  // Use mixin methods
  await toggleTitleTranslation(movie.title);
}
```

#### 2. HapticHelper (`lib/showcases/utils/haptic_helper.dart`)
Helper class for haptic feedback operations.

**Methods:**
- `performHapticFeedback()` - Light haptic feedback
- `performSelectionClick()` - Selection click feedback
- `performMediumImpact()` - Medium impact feedback
- `performHeavyImpact()` - Heavy impact feedback

**Usage:**
```dart
HapticHelper.performHapticFeedback();
```

#### 3. DetailPageNavigation (`lib/showcases/utils/detail_page_navigation.dart`)
Helper class for navigation in detail pages.

**Methods:**
- `navigateToPersonDetail(context, personId, name, profilePath)` - Navigate to person detail
- `navigateToEpisodeDetail(context, ...)` - Navigate to episode detail

**Usage:**
```dart
DetailPageNavigation.navigateToPersonDetail(
  context,
  castMember.id,
  castMember.name,
  castMember.profilePath,
);
```

---

## Movie Detail Widgets (`lib/widgets/movie_detail/`)

### 1. FadeInWidget
Simple fade-in animation wrapper.

**File:** `fade_in_widget.dart`

**Usage:**
```dart
FadeInWidget(
  duration: Duration(milliseconds: 300),
  child: YourWidget(),
)
```

### 2. MovieDetailLoadingView
Shimmer loading skeleton for movie detail page.

**File:** `movie_detail_loading_view.dart`

**Usage:**
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const MovieDetailLoadingView();
}
```

### 3. MovieTagline
Displays movie tagline with styled text.

**File:** `movie_tagline.dart`

**Usage:**
```dart
if (movie.tagline != null && movie.tagline!.isNotEmpty)
  MovieTagline(tagline: movie.tagline!),
```

### 4. MovieBasicInfo
Displays poster, title, rating, runtime, and genres.

**File:** `movie_basic_info.dart`

**Usage:**
```dart
MovieBasicInfo(
  movie: movie,
  translatedTitle: translatedTitle,
  isTranslating: isTranslating,
  onTranslate: () async {
    await toggleTitleTranslation(movie.title);
  },
  showDetailedInfo: true,
)
```

### 5. MovieActionButtons
Play and Download buttons.

**File:** `movie_action_buttons.dart`

**Usage:**
```dart
MovieActionButtons(
  downloadLinks: downloadLinks,
  isWatched: isWatched,
  onPlayPressed: () {
    // Handle play
  },
  onDownloadPressed: () {
    // Handle download
  },
)
```

### 6. MovieOverviewSection
Overview text with translation button.

**File:** `movie_overview_section.dart`

**Usage:**
```dart
MovieOverviewSection(
  overview: oveview,
  onTranslate: () async {
    await translateOverview(movie.overview);
  },
  onLongPress: () {
    showTextInputDialog(context, userDataService);
  },
)
```

### 7. MovieKeywordsSection
Keywords displayed as clickable chips.

**File:** `movie_keywords_section.dart`

**Usage:**
```dart
if (_movieKeywords.isNotEmpty)
  MovieKeywordsSection(
    keywords: _movieKeywords,
    movieService: _movieService,
  ),
```

### 8. MovieCastSection
Horizontal scrolling cast list.

**File:** `movie_cast_section.dart`

**Usage:**
```dart
if (credits != null && credits.cast.isNotEmpty)
  MovieCastSection(
    cast: credits.cast,
    movieId: movie.id,
    movieTitle: movie.title,
  ),
```

### 9. MovieDirectorsSection
Horizontal scrolling directors list.

**File:** `movie_directors_section.dart`

**Usage:**
```dart
if (credits != null && credits.directors.isNotEmpty)
  MovieDirectorsSection(
    directors: credits.directors,
  ),
```

### 10. MovieCrewChipSection
Writers, producers, or other crew as chips.

**File:** `movie_crew_chip_section.dart`

**Usage:**
```dart
if (credits.writers.isNotEmpty)
  MovieCrewChipSection(
    title: 'Writing',
    crewMembers: credits.writers,
  ),

if (credits.producers.isNotEmpty)
  MovieCrewChipSection(
    title: 'Production',
    crewMembers: credits.producers,
    maxDisplay: 5,
    onSeeAll: () {
      // Handle see all
    },
  ),
```

### 11. ProductionCompaniesSection
Horizontal scrolling production companies.

**File:** `production_companies_section.dart`

**Usage:**
```dart
if (movie.productionCompanies != null && movie.productionCompanies!.isNotEmpty)
  ProductionCompaniesSection(
    companies: movie.productionCompanies!,
  ),
```

### 12. ProductionCountriesSection
Production countries as chips.

**File:** `production_countries_section.dart`

**Usage:**
```dart
if (movie.productionCountries != null && movie.productionCountries!.isNotEmpty)
  ProductionCountriesSection(
    countries: movie.productionCountries!,
  ),
```

### 13. SpokenLanguagesSection
Spoken languages as chips.

**File:** `spoken_languages_section.dart`

**Usage:**
```dart
if (movie.spokenLanguages != null && movie.spokenLanguages!.isNotEmpty)
  SpokenLanguagesSection(
    languages: movie.spokenLanguages!,
  ),
```

### 14. MovieInfoCard
Card for budget, revenue, or other stats.

**File:** `movie_info_card.dart`

**Usage:**
```dart
Row(
  children: [
    Expanded(
      child: MovieInfoCard(
        title: 'Budget',
        value: movie.formattedBudget,
        icon: Icons.attach_money,
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: MovieInfoCard(
        title: 'Revenue',
        value: movie.formattedRevenue,
        icon: Icons.trending_up,
      ),
    ),
  ],
)
```

### 15. ExternalLinksSection
External links (website, IMDb).

**File:** `external_links_section.dart`

**Usage:**
```dart
ExternalLinksSection(
  homepage: movie.homepage,
  imdbId: movie.imdbId,
),
```

---

## TV Show Detail Widgets (`lib/widgets/tv_detail/`)

### 1. TvShowStatCard
Card for statistics (seasons, episodes).

**File:** `tv_show_stat_card.dart`

**Usage:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Expanded(
      child: TvShowStatCard(
        title: 'Seasons',
        value: tvShow.numberOfSeasons.toString(),
        icon: Icons.movie_filter_outlined,
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: TvShowStatCard(
        title: 'Episodes',
        value: tvShow.numberOfEpisodes.toString(),
        icon: Icons.list_alt_outlined,
      ),
    ),
  ],
)
```

### 2. TvShowGenresSection
Genres displayed as chips.

**File:** `tv_show_genres_section.dart`

**Usage:**
```dart
if (tvShow.genres != null && tvShow.genres!.isNotEmpty)
  TvShowGenresSection(genres: tvShow.genres!),
```

### 3. TvShowCreatorsSection
Horizontal scrolling creators list.

**File:** `tv_show_creators_section.dart`

**Usage:**
```dart
if (tvShow.createdBy != null && tvShow.createdBy!.isNotEmpty)
  TvShowCreatorsSection(
    creators: tvShow.createdBy!,
    onCreatorTap: (id, name, profilePath) {
      DetailPageNavigation.navigateToPersonDetail(
        context, id, name, profilePath,
      );
    },
  ),
```

---

## Migration Checklist

### For movie_detail_page_copy.dart

- [x] Import all extracted widgets
- [x] Use TranslationMixin
- [x] Replace FadeIn with FadeInWidget
- [x] Replace _buildLoadingView with MovieDetailLoadingView
- [x] Replace tagline section with MovieTagline
- [ ] Replace basic info section with MovieBasicInfo
- [ ] Replace action buttons with MovieActionButtons
- [ ] Replace overview section with MovieOverviewSection
- [ ] Replace keywords section with MovieKeywordsSection
- [ ] Replace cast section with MovieCastSection
- [ ] Replace directors section with MovieDirectorsSection
- [ ] Replace crew sections with MovieCrewChipSection
- [ ] Replace production sections with respective widgets
- [ ] Replace info cards with MovieInfoCard
- [ ] Replace external links with ExternalLinksSection

### For tv_detail_page_anime.dart

- [ ] Import all extracted widgets
- [ ] Use TranslationMixin
- [ ] Replace stat cards with TvShowStatCard
- [ ] Replace genres section with TvShowGenresSection
- [ ] Replace creators section with TvShowCreatorsSection
- [ ] Extract and replace remaining sections

---

## Benefits of Refactoring

1. **Reusability:** Widgets can be used across multiple screens
2. **Maintainability:** Changes to a widget affect all usages
3. **Testability:** Individual widgets can be tested in isolation
4. **Readability:** Main files are shorter and easier to understand
5. **Consistency:** Same widgets ensure consistent UI across the app

---

## Additional Widgets To Be Created

The following components could still be extracted from the main files:

### Movie Detail Page
- MovieDetailAppBar (the full app bar with backdrop and actions)
- MovieDetailErrorView (error state view)

### TV Show Detail Page
- TvShowLoadingView (shimmer loading state)
- TvShowErrorView (error state)
- TvShowNetworksSection
- TvShowSeasonCard
- TvShowCastGrid
- TvShowVideoCard
- TvShowVideosTab

These can be created following the same patterns as the existing widgets.

---

## Notes

- All extracted widgets maintain the original functionality and styling
- Widgets use the same imports and dependencies as the original code
- Navigation and haptic feedback are handled by helper classes
- Translation functionality is provided by the TranslationMixin
- All widgets are documented with clear usage examples

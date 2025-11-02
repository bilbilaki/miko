# Refactoring TODO Checklist

This checklist tracks the progress of refactoring `movie_detail_page_copy.dart` and `tv_detail_page_anime.dart` into smaller, reusable widgets.

## ✅ Completed Items

### Shared Utilities
- [x] Create `lib/showcases/mixins/translation_mixin.dart`
- [x] Create `lib/showcases/utils/haptic_helper.dart`
- [x] Create `lib/showcases/utils/detail_page_navigation.dart`

### Movie Detail Widgets (lib/widgets/movie_detail/)
- [x] `fade_in_widget.dart` - Animation wrapper
- [x] `movie_detail_loading_view.dart` - Loading skeleton
- [x] `movie_tagline.dart` - Tagline display
- [x] `movie_basic_info.dart` - Poster, title, rating, runtime
- [x] `movie_action_buttons.dart` - Play/Download buttons
- [x] `movie_overview_section.dart` - Overview with translation
- [x] `movie_keywords_section.dart` - Keyword chips
- [x] `movie_cast_section.dart` - Cast horizontal list
- [x] `movie_directors_section.dart` - Directors horizontal list
- [x] `movie_crew_chip_section.dart` - Writers/Producers chips
- [x] `production_companies_section.dart` - Production companies
- [x] `production_countries_section.dart` - Production countries
- [x] `spoken_languages_section.dart` - Spoken languages
- [x] `movie_info_card.dart` - Budget/Revenue cards
- [x] `external_links_section.dart` - External links

### TV Show Detail Widgets (lib/widgets/tv_detail/)
- [x] `tv_show_stat_card.dart` - Statistics card
- [x] `tv_show_genres_section.dart` - Genres chips
- [x] `tv_show_creators_section.dart` - Creators list

### Documentation
- [x] Create `REFACTORING_GUIDE.md` - Complete documentation
- [x] Create `REFACTORING_EXAMPLE.md` - Before/after examples

### Main File Updates
- [x] Update `movie_detail_page_copy.dart` imports
- [x] Add TranslationMixin to MovieDetailPageState
- [x] Replace FadeIn with FadeInWidget
- [x] Replace loading view with MovieDetailLoadingView
- [x] Replace tagline section with MovieTagline
- [x] Update translation property references

---

## 🔄 In Progress / Remaining Work

### movie_detail_page_copy.dart - Additional Widget Replacements

The following sections in `_buildMovieDetails` can still be replaced:

- [ ] Replace basic info section (lines 546-680) with `MovieBasicInfo`
  - Currently partially done, full replacement pending
  
- [ ] Replace action buttons section (lines 832-872) with `MovieActionButtons`
  - Structure is ready, just needs to be integrated
  
- [ ] Replace overview section (lines 882-902) with `MovieOverviewSection`
  - Widget created, integration pending
  
- [ ] Replace keywords section (lines 903-904) with `MovieKeywordsSection`
  - Can be done with simple replacement
  
- [ ] Replace cast section (lines 907-1057) with `MovieCastSection`
  - Widget ready, ~150 lines to replace
  
- [ ] Replace directors section (lines 1060-1180) with `MovieDirectorsSection`
  - Widget ready, ~120 lines to replace
  
- [ ] Replace writers section (lines 1182-1236) with `MovieCrewChipSection`
  - Widget ready, ~80 lines to replace
  
- [ ] Replace producers section (lines 1238-1308) with `MovieCrewChipSection`
  - Widget ready, ~100 lines to replace
  
- [ ] Replace production companies section (lines 1311-1399) with `ProductionCompaniesSection`
  - Widget ready, ~100 lines to replace
  
- [ ] Replace production countries section (lines 1401-1418) with `ProductionCountriesSection`
  - Widget ready, ~35 lines to replace
  
- [ ] Replace budget/revenue section (lines 1420-1447) with `MovieInfoCard`
  - Widget ready, ~60 lines to replace
  
- [ ] Replace spoken languages section (lines 1448-1465) with `SpokenLanguagesSection`
  - Widget ready, ~35 lines to replace
  
- [ ] Replace external links section (lines 1467-1502) with `ExternalLinksSection`
  - Widget ready, ~50 lines to replace

### Additional Movie Detail Widgets to Create

- [ ] Create `movie_detail_app_bar.dart`
  - Extract lines 391-634 (full app bar with backdrop/poster)
  - Includes favorite, rating, watchlist, share buttons
  - ~250 lines to extract
  
- [ ] Create `movie_detail_error_view.dart`
  - Extract lines 172-365 (error view with retry)
  - ~190 lines to extract

### tv_detail_page_anime.dart - Widget Replacements

- [ ] Update imports to include extracted widgets
- [ ] Add TranslationMixin to TvShowDetailPageAnimeState
- [ ] Replace genres section (lines 420-435) with `TvShowGenresSection`
- [ ] Replace creators section (lines 438-515) with `TvShowCreatorsSection`
- [ ] Replace statistics section (lines 623-657) with `TvShowStatCard`

### Additional TV Show Widgets to Create

- [ ] Create `tv_show_loading_view.dart`
  - Extract loading skeleton from lines 191-203
  - Similar to MovieDetailLoadingView
  
- [ ] Create `tv_show_error_view.dart`
  - Extract error view from lines 205-262
  - ~60 lines to extract
  
- [ ] Create `tv_show_networks_section.dart`
  - Extract lines 572-620 (networks display)
  - ~50 lines to extract
  
- [ ] Create `tv_show_season_card.dart`
  - Extract season card from lines 707-808
  - ~100 lines to extract
  
- [ ] Create `tv_show_cast_grid.dart`
  - Extract cast grid from lines 812-931
  - ~120 lines to extract
  
- [ ] Create `tv_show_video_card.dart`
  - Extract individual video card
  - Used in videos tab
  
- [ ] Create `tv_show_videos_tab.dart`
  - Extract complete videos tab (lines 934-1076)
  - ~140 lines to extract
  
- [ ] Create `tv_show_episodes_list.dart`
  - Extract episodes list (lines 1078-1153)
  - ~75 lines to extract
  
- [ ] Create `tv_show_overview_section.dart`
  - Similar to MovieOverviewSection
  - Extract from overview tab

---

## 📊 Progress Summary

### Widgets Created
- **Total:** 21 widgets
- **Movie Detail:** 15 widgets
- **TV Show Detail:** 3 widgets
- **Shared Utilities:** 3 files

### Code Reduction Achieved
- **movie_detail_page_copy.dart:** ~200 lines removed so far
- **Potential total reduction:** ~1,100+ lines per file
- **Current progress:** ~18% of potential reduction

### Integration Status
- **movie_detail_page_copy.dart:** Partial integration (imports, mixin, 3 widgets)
- **tv_detail_page_anime.dart:** No integration yet (widgets ready)

---

## 🎯 Recommended Next Steps

1. **Complete movie_detail_page_copy.dart integration** (Priority: High)
   - Replace cast, directors, crew sections (highest impact)
   - Replace production sections
   - Replace info cards and external links
   - Expected reduction: ~800 lines

2. **Create and integrate MovieDetailAppBar** (Priority: Medium)
   - Large widget (~250 lines)
   - High reusability potential
   - Clean separation of concerns

3. **Start tv_detail_page_anime.dart integration** (Priority: Medium)
   - Use existing widgets (genres, creators, stats)
   - Expected reduction: ~100 lines with existing widgets

4. **Create remaining TV show widgets** (Priority: Low)
   - Can be done progressively
   - Follow same patterns as movie widgets
   - Expected additional widgets: 7-8

5. **Testing and Verification** (Priority: High)
   - Test all integrated widgets
   - Verify no functionality loss
   - Check styling consistency
   - Test navigation flows
   - Test translation features

---

## 📝 Notes

- All created widgets maintain original functionality and styling
- Documentation is comprehensive with usage examples
- Widgets are designed for reusability across the app
- Integration can be done progressively without breaking existing functionality
- Each widget can be tested independently

---

## 🔗 References

- See `REFACTORING_GUIDE.md` for widget documentation
- See `REFACTORING_EXAMPLE.md` for before/after comparison
- Original files:
  - `lib/showcases/movie_detail_page_copy.dart` (1622 lines)
  - `lib/showcases/tv_detail_page_anime.dart` (1204 lines)

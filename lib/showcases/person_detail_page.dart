import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/ai_translator.dart';
import 'package:miko/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart'; // Assume this contains Person model
import 'movie_service.dart'; // Assume this contains MovieService

class PersonDetailPage extends StatefulWidget {
  final int personId;
  final String? initialName;
  final String? initialProfilePath;

  const PersonDetailPage({
    super.key,
    required this.personId,
    this.initialName,
    this.initialProfilePath,
  });

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  final MovieService _movieService = MovieService();
  late Future<Person> _personDetailsFuture;
  bool _hasError = false;
  String _errorMessage = '';
  String oveview = '';
  bool tr = false;
  @override
  void initState() {
    super.initState();
    _loadPersonDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadPersonDetails() {
    setState(() {
      _hasError = false; // Reset error state on new load attempt
    });
    _personDetailsFuture = _movieService.getPersonDetails(
      personId: widget.personId,
    );
    _personDetailsFuture
        .then((_) {
          if (mounted) {
            setState(() {
              // FutureBuilder handles success state, no specific action needed here
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = error.toString();
            });
          }
        });
  }

  Future<void> _launchUrl(String uri) async {
    final Uri url = Uri.parse(uri);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching $url: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Person>(
        future: _personDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingAndInitialView(context);
          } else if (_hasError || snapshot.hasError) {
            return _buildErrorOverlay(context);
          } else if (snapshot.hasData) {
            final person = snapshot.data!;
            dllink(person);
            return _buildPersonDetailView(context, person);
          } else {
            // Fallback to basic view if no data and not waiting/error (should ideally not happen)
            return _buildLoadingAndInitialView(context);
          }
        },
      ),
    );
  }

  Widget _buildLoadingAndInitialView(BuildContext context) {
    return Stack(
      children: [
        _buildInitialPlaceholderView(context),
        Positioned.fill(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialPlaceholderView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              widget.initialName ?? 'Loading Person...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            background: _buildProfileImage(
              context,
              'https://db.inosuke.sbsv500${widget.initialProfilePath}', // Ensure correct base URL
              heroTag: 'person-${widget.personId}',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading details for ${widget.initialName ?? "this person"}...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorOverlay(BuildContext context) {
    return Stack(
      children: [
        _buildInitialPlaceholderView(context),
        Positioned.fill(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Oops! Something went wrong.',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage.contains('SocketException')
                          ? 'No internet connection. Please check your network and try again.'
                          : 'Failed to load details. ${_errorMessage.split(':').last.trim()}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _loadPersonDetails(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void dllink(Person person) async {
    if (tr == false) {
      oveview = person.biography.toString();
    }
  }

  Widget _buildPersonDetailView(BuildContext context, Person person) {
    final userDataService = Provider.of<UserDataService>(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 380,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            title: Text(
              person.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            background: _buildProfileImage(
              context,
              person.fullProfilePath,
              heroTag: 'person-${person.id}',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share functionality coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonalInfoSection(context, person),
                const SizedBox(height: 24),
                Text(
                  'Biography',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                IconButton(
                  iconSize: 20.0,
                  icon: const Icon(Icons.assistant),
                  tooltip: 'translate overview',
                  onPressed: () async {
                    tVClick();
                    gentranslate();
                  },
                  onLongPress: () {
                    showTextInputDialog(context, userDataService);
                  },
                ),
                Text(
                  oveview.isNotEmpty == true
                      ? oveview
                      : 'No biography available for ${person.name}.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (person.alsoKnownAs != null &&
                    person.alsoKnownAs!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Also Known As',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: person.alsoKnownAs!.map((name) {
                      return Chip(
                        label: Text(name),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        labelStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (person.imdbId != null || person.homepage != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'External Links',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      if (person.imdbId != null)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.movie, size: 20),
                          label: const Text('IMDb'),
                          onPressed: () {
                            _launchUrl(
                              'https://www.imdb.com/name/${person.imdbId}/',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      if (person.homepage != null &&
                          person.homepage!.isNotEmpty)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.language, size: 20),
                          label: const Text('Official Website'),
                          onPressed: () {
                            _launchUrl(person.homepage!);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void gentranslate() async {
    final translator = MovieTvTranslator();
    debugPrint(oveview);
    final translatedOverView = await translator.translateTextForMoviesAndTV(
      oveview,
    );
    debugPrint(translatedOverView);
    debugPrint(oveview);
    setState(() {
      tr = true;
      oveview = translatedOverView;

      debugPrint(oveview);
    });
  }

  Future<String?> showTextInputDialog(
    BuildContext context,
    userDataService, {
    String title = 'Enter Your Prefred Language',
    String? initialText,
    String hintText = 'Like Arabic , Ar ...',
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final TextEditingController textEditingController = TextEditingController(
      text: initialText,
    );

    return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textEditingController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
            textCapitalization: textCapitalization,
            keyboardType: keyboardType,
            onSubmitted: (value) {
              // Allow submitting by pressing Enter/Done on keyboard
              Navigator.of(dialogContext).pop(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null); // Return null on cancel
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userDataService.setCustoombaseurl(
                  textEditingController.text,
                );

                Navigator.of(
                  dialogContext,
                ).pop(textEditingController.text); // Return entered text
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(
    BuildContext context,
    String? imageUrl, {
    required String heroTag,
  }) {
    // Check for null, empty, or placeholder string values (like "null")
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl == "null" ||
        !imageUrl.startsWith('http')) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Center(
          child: Icon(
            Icons.person_outline,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorListener: (value) =>
            debugPrint('Image load error: $value'), // For debugging
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, Person person) {
    final List<Widget> bodyRows = [];

    bodyRows.add(
      _buildInfoRow(
        context,
        'Known For',
        person.knownForDepartment,
        Icons.work_outline,
      ),
    );
    bodyRows.add(
      _buildInfoRow(context, 'Gender', person.genderText, Icons.transgender),
    );
    if (person.birthday != null) {
      bodyRows.add(
        _buildInfoRow(
          context,
          'Birthday',
          '${person.formattedBirthday} (${person.age})',
          Icons.cake_outlined,
        ),
      );
    }
    if (person.placeOfBirth != null && person.placeOfBirth!.isNotEmpty) {
      bodyRows.add(
        _buildInfoRow(
          context,
          'Place of Birth',
          person.placeOfBirth!,
          Icons.location_on_outlined,
        ),
      );
    }
    bodyRows.add(
      _buildInfoRow(
        context,
        'Popularity',
        person.popularity.toStringAsFixed(1),
        Icons.trending_up,
      ),
    );

    // Filter out SizedBox.shrink() and interleave with Dividers
    final List<Widget> visibleInfoRows = bodyRows
        .where((element) => element is! SizedBox)
        .toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Info',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(height: 32, thickness: 1), // Initial divider
            ...List.generate(visibleInfoRows.length, (index) {
              final row = visibleInfoRows[index];
              return Column(
                children: [
                  row,
                  if (index < visibleInfoRows.length - 1)
                    const Divider(
                      height: 32,
                      thickness: 0.5,
                    ), // Divider between items
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String title,
    String? value,
    IconData icon,
  ) {
    if (value == null || value.isEmpty || value == "null") {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

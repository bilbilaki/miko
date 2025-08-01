part of '../services/ai_chat_service.dart';
final webSearchTool = Tool(
  functionDeclarations: [
    FunctionDeclaration(
      'performWebSearch',
      'Performs a web search to find current information or answer questions requiring up-to-date data. Provide the exact search query.',
      Schema(
        SchemaType.object,
        properties: {
          'query': Schema(SchemaType.string,
              description:
                  'The search query for which to retrieve instant answers.'),
        },
        nullable: false,
        requiredProperties: ['query'],
      ),
    ),
  ],
);

// Tool for getting movie/series recommendations
final movieRecommendTool = Tool(
  functionDeclarations: [
    FunctionDeclaration(
      'getMovieRecommendations',
      'Fetches a list of recommended movies, series, or anime that are similar to a specific title. You must provide the exact name of the title to get recommendations for.',
      Schema(
        SchemaType.object,
        properties: {
          'name': Schema(SchemaType.string,
              description:
                  "The name of the movie, series, or anime for which to find recommendations. Do not include the year."),
          'isMovie': Schema(SchemaType.boolean,
              description:
                  "Set to true if the user is asking for a movie. Set to false if it is a TV series or anime series."),
          'page': Schema(SchemaType.integer,
              description:
                  'The page number of results to retrieve. Defaults to 1.'),
          'language': Schema(SchemaType.string,
              description:
                  "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
        },
        requiredProperties: ['name', 'isMovie'],
      ),
    ),
  ],
);

final getPopularTool = Tool(
  functionDeclarations: [
    FunctionDeclaration(
      'getPopular',
      'Retrieves a list of popular movies, series, or anime. Specify whether you want movies or series using the isMovie parameter. To get results in a specific language, provide the language code in ISO 639-1 format (e.g., "en-US"). You can also request additional pages of results by specifying the page number.',
      Schema(
        SchemaType.object,
        properties: {
          'isMovie': Schema(SchemaType.boolean,
              description:
                  "Set to true if the user is asking for a movie. Set to false if it is a TV series or anime series."),
          'page': Schema(SchemaType.integer,
              description:
                  'The page number of results to retrieve. Defaults to 1.'),
          'language': Schema(SchemaType.string,
              description:
                  "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
        },
        requiredProperties: ['isMovie'],
      ),
    ),
  ],
);

final movieCreditsTool = Tool(
 functionDeclarations: [
 FunctionDeclaration(
 'getMovieCredits',
 'Fetches the cast and crew details for a specific movie. You must provide the exact name of the movie.',
 Schema(
 SchemaType.object,
 properties: {
 'movieName': Schema(SchemaType.string,
 description:
 "The exact name of the movie for which to retrieve credits. Do not include the year."),
 'language': Schema(SchemaType.string,
 description:
 "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
 },
 requiredProperties: ['movieName'],
 ),
 ),
 ],
);

final personDetailsTool = Tool(
 functionDeclarations: [
 FunctionDeclaration(
 'getPersonDetails',
 'Retrieves detailed information about a specific person (actor, director, etc.). You must provide the exact name of the person.',
 Schema(
 SchemaType.object,
 properties: {
 'personName': Schema(SchemaType.string,
 description: "The exact name of the person to look up."),
 'language': Schema(SchemaType.string,
 description:
 "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
 },
 requiredProperties: ['personName'],
 ),
 ),
 ],
);

final tvShowEpisodeDetailsTool = Tool(
 functionDeclarations: [
 FunctionDeclaration(
 'getTvShowEpisodeDetails',
 'Fetches details for a specific episode of a TV series, including its overview, runtime, and the cast and crew involved in that episode. You must provide the exact name of the TV show, its season number, and the episode number.',
 Schema(
 SchemaType.object,
 properties: {
 'tvShowName': Schema(SchemaType.string,
 description: "The exact name of the TV series."),
 'seasonNumber': Schema(SchemaType.integer,
 description: "The season number of the episode."),
 'episodeNumber': Schema(SchemaType.integer,
 description: "The episode number."),
 'language': Schema(SchemaType.string,
 description:
 "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
 },
 requiredProperties: ['tvShowName', 'seasonNumber', 'episodeNumber'],
 ),
 ),
 ],
);

final tvCreditsTool = Tool(
 functionDeclarations: [
 FunctionDeclaration(
 'getTVCredits',
 'Fetches the cast and crew details for a specific TV show. You must provide the exact name of the TV show.',
 Schema(
 SchemaType.object,
 properties: {
 'tvShowName': Schema(SchemaType.string,
 description:
 "The exact name of the TV show for which to retrieve credits."),
 'language': Schema(SchemaType.string,
 description:
 "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
 },
 requiredProperties: ['tvShowName'],
 ),
 ),
 ],
);
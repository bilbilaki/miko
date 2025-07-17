import 'package:openai_dart/openai_dart.dart';

final FunctionObject weatherFunction = const FunctionObject(
  name: 'performWebSearch',
  description:
      'Perform a web search to find current information or answer questions requiring up-to-date data. Provide the exact search query.',
  parameters: {
    'type': 'object',
    'properties': {
      'query': {
        'type': 'string',
        'description':
            'The search query for which to retrieve instant answers.',
      },
    },
    'required': ['query'],
  },
);

ChatCompletionTool get weatherTool => ChatCompletionTool(
      type: ChatCompletionToolType.function,
      function: weatherFunction,
    );


final FunctionObject movieRecommendFunction = const FunctionObject(
  name: 'getMovieRecommendations',
  description:
      'Fetches a list of recommended movies that are similar to a specific movie or Series and anime. You must provide the exact movie ID of the movie to get recommendations for.',
  parameters: {
    'type': 'object',
    'properties': {
      'name': {
        'type': 'string',
        'description':
            'name of the movie or series or anime for which to find recommendations. just without year ',
      },
      'page': {
        'type': 'integer',
        'description': 'The page number of results to retrieve. Defaults to 1.',
      },
      'language': {
        'type': 'string',
        'description': "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'.",
      },
      'isMovie': {
        'type': 'boolean',
        'description':
            'If Item is A Movie set true , but If Its Series or Anime Series Set false',
      },
    },
    'required': ['name','isMovie'], 
  },
);

ChatCompletionTool get movieRecommendTool => ChatCompletionTool(
      type: ChatCompletionToolType.function,
      function: movieRecommendFunction,
    );

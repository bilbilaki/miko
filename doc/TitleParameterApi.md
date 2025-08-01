# openapi.api.TitleParameterApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://omdbapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getTitle**](TitleParameterApi.md#gettitle) | **GET** /?t | Returns the most popular match for a given title


# **getTitle**
> getTitle(t, y, type, plot, r, callback)

Returns the most popular match for a given title

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: APIKeyQueryParam
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKeyPrefix = 'Bearer';

final api_instance = TitleParameterApi();
final t = t_example; // String | Title of movie or series
final y = 56; // int | Year of release
final type = type_example; // String | Return movie or series
final plot = plot_example; // String | Return short or full plot
final r = r_example; // String | The response type to return
final callback = callback_example; // String | JSONP callback name

try {
    api_instance.getTitle(t, y, type, plot, r, callback);
} catch (e) {
    print('Exception when calling TitleParameterApi->getTitle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **t** | **String**| Title of movie or series | 
 **y** | **int**| Year of release | [optional] 
 **type** | **String**| Return movie or series | [optional] 
 **plot** | **String**| Return short or full plot | [optional] 
 **r** | **String**| The response type to return | [optional] 
 **callback** | **String**| JSONP callback name | [optional] 

### Return type

void (empty response body)

### Authorization

[APIKeyQueryParam](../README.md#APIKeyQueryParam)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


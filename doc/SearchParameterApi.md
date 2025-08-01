# openapi.api.SearchParameterApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://omdbapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**titleSearch**](SearchParameterApi.md#titlesearch) | **GET** /?s | Returns an array of results for a given title


# **titleSearch**
> titleSearch(s, y, type, r, page, callback)

Returns an array of results for a given title

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: APIKeyQueryParam
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKeyPrefix = 'Bearer';

final api_instance = SearchParameterApi();
final s = s_example; // String | Title of movie or series
final y = 56; // int | Year of release
final type = type_example; // String | Return movie or series
final r = r_example; // String | The response type to return
final page = 56; // int | Page number to return
final callback = callback_example; // String | JSONP callback name

try {
    api_instance.titleSearch(s, y, type, r, page, callback);
} catch (e) {
    print('Exception when calling SearchParameterApi->titleSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **s** | **String**| Title of movie or series | 
 **y** | **int**| Year of release | [optional] 
 **type** | **String**| Return movie or series | [optional] 
 **r** | **String**| The response type to return | [optional] 
 **page** | **int**| Page number to return | [optional] 
 **callback** | **String**| JSONP callback name | [optional] 

### Return type

void (empty response body)

### Authorization

[APIKeyQueryParam](../README.md#APIKeyQueryParam)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


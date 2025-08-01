# openapi.api.IDParameterApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://omdbapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getId**](IDParameterApi.md#getid) | **GET** /?i | Returns a single result based on the ID provided


# **getId**
> getId(i, plot, r, callback)

Returns a single result based on the ID provided

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: APIKeyQueryParam
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('APIKeyQueryParam').apiKeyPrefix = 'Bearer';

final api_instance = IDParameterApi();
final i = i_example; // String | A valid IMDb ID (e.g. tt0000001)
final plot = plot_example; // String | Return short or full plot
final r = r_example; // String | The response type to return
final callback = callback_example; // String | JSONP callback name

try {
    api_instance.getId(i, plot, r, callback);
} catch (e) {
    print('Exception when calling IDParameterApi->getId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **i** | **String**| A valid IMDb ID (e.g. tt0000001) | 
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


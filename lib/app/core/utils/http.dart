import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firebase_controller.dart';

// A Dio Function that generate and re generate token for the  APIs for security
Future<Dio> http() async {
  final dioInstance = Dio();
  const String url = 'https://kdec-church-testing-app.onrender.com';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user = _auth.currentUser;

  final data = {
    'uid': user?.uid,
  };

  String? token;
  // gets the token saved in the prefs
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');

  dioInstance.interceptors.add(InterceptorsWrapper(
      onError: (DioError error, ErrorInterceptorHandler handler) async {
    if (error.response != null) {
      final response = error.response!;
      final statusCode = response.statusCode;
      print('Error Status Code: $statusCode');
      if (statusCode == 302) {
        final location = response.headers.map[
            'https://kdec-church-testing-app.onrender.com/api/en/auth/token']; // Fetch the 'Location' header
        print('Redirection URL: $location');
      }
      // if the status code 401 its automatic remove the saved token and regenerate new token , because token set to 1 day
      if (statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        final requestOptions = error.requestOptions;
        final res = await Dio().post(
          url + "/api/en/auth/token",
          data: data,
        );
        final newToken = res.data['results']
            ['token']; // Assuming the structure of the response JSON
        prefs.setString('token', newToken); // Store the new token

        // Update the token in the current instance for subsequent requests
        token = newToken;
        requestOptions.headers['Cookie'] = 'S_UT=$newToken';

        try {
          // Resend the original request with the new token
          final response = await dioInstance.request<dynamic>(
            requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              responseType: requestOptions.responseType,
              headers:
                  requestOptions.headers, // Updated headers with the new token
            ),
          );
          return handler.resolve(Response(
            requestOptions: requestOptions,
            statusCode: response.statusCode,
            data: response.data,
            headers: response.headers,
            statusMessage: response.statusMessage,
          ));
        } catch (e) {
          print('Failed to resend request after token refresh: $e');
          return handler.next(error);
        }
      }
    }
    return handler.next(error);
  }));

  dioInstance.interceptors
      .add(InterceptorsWrapper(onRequest: (options, handler) {
    if (token != null) {
      options.headers['Cookie'] = 'S_UT=$token';
    }
    return handler.next(options);
  }));

  return dioInstance;
}

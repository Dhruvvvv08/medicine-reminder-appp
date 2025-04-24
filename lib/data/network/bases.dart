import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

//In this file all the API requests are created, we will call these requests for all the APIs

//const String baseUrl = 'https://inspectionapi.austere.biz/inspection/api';
const String baseUrl = 'http://192.168.29.249:3002/api';
http.Client client = http.Client();
// final LocalStorageService _storageService = LocalStorageService();

Map<String, String> appendAccessTokenWith(
  Map<String, String> headers,
  String accessToken,
) {
  final Map<String, String> requestHeaders = {
    'Authorization': accessToken,
    // 'Content-Type': "application/json",
    // 'cookie':
    //     "userId=s%3Aix4c7OINKAeyLCNR6sbcQP6SAbb6RLPp.md4VFFVZmDN2vl53Eivr6Ai7cOfT%2BeZuI9nLNEhPKy4; userId=s%3A9F6ACNKpmKUQhK004CIBCyL-_TTy8h2V.HxisbshJy0VpHPCYBcIjbGp%2Be9QqH%2FC1Ov%2Br3M3plH4"
  }..addAll(headers);
  return requestHeaders;
}

Future<http.Response> fetchData({
  required String url,
  String queryParams = "",
  bool isCustomUrl = false,
}) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  String sessionToken = SharedPref.pref!.getString(Preferences.token) ?? "";

  // if (addToken) {
  //   requestHeaders = appendAccessTokenWith({}, sessionToken);
  // }

  // else {
  requestHeaders.addAll({'Authorization': 'Bearer ${sessionToken ?? ""}'});
  // }

  if (queryParams.isNotEmpty) {
    url += "?$queryParams";
  }

  final response = await client.get(
    isCustomUrl ? Uri.parse(url) : Uri.parse(baseUrl + url),
    headers: requestHeaders,
  );

  return response;
}

// Future<http.Response> getDataWithCookie({
//   required String url,
//   String queryParams = "",
//   bool isCustomUrl = false,
//   bool addToken = true,
//   String? token,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = {
//       "Authorization": _storageService.getUserTokenFromDisk ?? '',
//     };
//   } else {
//     requestHeaders = {};
//   }

//   if (queryParams.isNotEmpty) {
//     url += "$queryParams";
//   }

//   final response = await client.get(
//     isCustomUrl ? Uri.parse(url) : Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//   );

//   return response;
// }

// Future<http.Response> postData<T>({
//   required String url,
//   required T body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({
//       'Content-Type': 'application/json',
//     }, _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {
//       'Content-Type': 'application/json',
//     };
//   }

//   final response = await client.post(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: jsonEncode(body),
//   );

//   return response;
// }

Future<http.Response> postDataa<T>({
  required String url,
  required T body,
}) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  String sessionToken = SharedPref.pref!.getString(Preferences.token) ?? "";

  // if (addToken) {
  //   requestHeaders = appendAccessTokenWith({}, sessionToken);
  // }

  // else {
  requestHeaders.addAll({'Authorization': 'Bearer ${sessionToken ?? ""}'});

  final response = await client.post(
    Uri.parse(baseUrl + url),
    headers: requestHeaders,
    body: jsonEncode(body),
  );

  return response;
}

Future<http.Response> postDataawithouttoken<T>({
  required String url,
  required T body,
}) async {
  Map<String, String> requestHeaders;

  requestHeaders = {'Content-Type': 'application/json'};
  // requestHeaders.addAll({
  //   'Authorization':
  //       'Bearer ${SharedPref.pref!.getString(Preferences.login_token) ?? ""}'
  // });

  final response = await client.post(
    Uri.parse(baseUrl + url),
    headers: requestHeaders,
    body: jsonEncode(body),
  );

  return response;
}

Future<http.Response> postDataawithtoken<T>({
  required String url,
  required T body,
  String? token, // Add the token as an optional parameter
}) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  // If a token is provided, add it to the Authorization header
  // requestHeaders.addAll({
  //   'Authorization':
  //       'Bearer ${SharedPref.pref!.getString(Preferences.tokenn) ?? ""}'
  // });

  final response = await client.post(
    Uri.parse(baseUrl + url),
    headers: requestHeaders,
    body: jsonEncode(body),
  );

  return response;
}

// Future<http.Response> postDataWithCookie<T>({
//   required String url,
//   required T body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({
//       'Content-Type': 'application/json',
//     }, _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {
//       'Content-Type': 'application/json',
//     };
//   }

//   final response = await client.post(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: jsonEncode(body),
//   );

//   return response;
// }

// void updateCookie(http.Response response) {
//   String rawCookie = response.headers['set-cookie'] ?? "";

//   print(rawCookie);
// }

// Future<http.Response> putData({
//   required String url,
//   required List body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({
//       'Content-Type': 'application/json',
//     }, _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {
//       'Content-Type': 'application/json',
//     };
//   }

//   final response = await client.put(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: jsonEncode(body),
//   );

//   return response;
// }

// Future<http.Response> putSingleData({
//   required String url,
//   dynamic body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({
//       'Content-Type': 'application/json',
//     }, _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {
//       'Content-Type': 'application/json',
//     };
//   }

//   final response = await client.put(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: jsonEncode(body),
//   );

//   return response;
// }

// Future<http.Response> getRequest(String url) {
//   return http.get(Uri.parse(baseUrl + url), headers: {});
// }

// Future<http.Response> postRequest({
//   required String url,
//   required Map body,
//   bool addToken = false,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders =
//         appendAccessTokenWith({}, _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {};
//   }

//   return client.post(Uri.parse(baseUrl + url),
//       headers: requestHeaders, body: jsonEncode(body));
// }

// Future<http.Response> patchData({
//   required String url,
//   required Map body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({"Content-Type": "application/json"},
//         _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {"Content-Type": "application/json"};
//   }

//   final response = await client.patch(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: body.isNotEmpty ? jsonEncode(body) : null,
//   );

//   return response;
// }

// Future<http.Response> patchAnyData<T>({
//   required String url,
//   required T body,
//   bool addToken = true,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({"Content-Type": "application/json"},
//         _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {"Content-Type": "application/json"};
//   }

//   final response = await client.patch(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: jsonEncode(body),
//   );

//   return response;
// }

// Future<http.Response> patchDataWithQuery({
//   required String url,
//   required Map body,
//   bool addToken = true,
//   String? queryParams,
// }) async {
//   Map<String, String> requestHeaders;

//   if (addToken) {
//     requestHeaders = appendAccessTokenWith({"Content-Type": "application/json"},
//         _storageService.getUserTokenFromDisk ?? "");
//   } else {
//     requestHeaders = {"Content-Type": "application/json"};
//   }

//   if (queryParams?.isNotEmpty ?? false) {
//     url += "?$queryParams";
//   }

//   final response = await client.patch(
//     Uri.parse(baseUrl + url),
//     headers: requestHeaders,
//     body: body.isNotEmpty ? jsonEncode(body) : null,
//   );

//   return response;
// }

// Future<http.Response> deleteData({
//   required String url,
//   String queryParams = "",
//   required Map body,
// }) async {
//   Map<String, String> requestHeaders;

//   requestHeaders = appendAccessTokenWith({"Content-Type": "application/json"},
//       _storageService.getUserTokenFromDisk ?? "");

//   if (queryParams.isNotEmpty) {
//     url + queryParams;
//   }

//   final response = await client.delete(Uri.parse(baseUrl + url),
//       headers: requestHeaders, body: jsonEncode(body));

//   return response;
// }

Future<http.Response> uploadImageDataAndData({
  required Uint8List imageData,
  required String filename,
  required String url,
  required String district,
  required String block,
  required String school,
  required String programName,
}) async {
  final request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));

  // request.headers.addAll(
  //     {'Authorization': SharedPref.pref!.getString(Preferences.token) ?? ""});

  request.files.add(
    http.MultipartFile.fromBytes(
      "file",
      imageData,
      filename: filename, // Use the provided filename for the image
    ),
  );

  request.fields["district"] = district;
  request.fields["block"] = block;
  request.fields["school"] = school;
  request.fields["program_name"] = programName;

  //-------Send request

  var resp = await request.send();

  http.Response response = await http.Response.fromStream(resp);
  return response;
}

Future<http.Response> uploadImageData({
  required Uint8List imageData,
  required String filename,
  required String url,
}) async {
  final request = http.MultipartRequest("POST", Uri.parse(url));

  request.files.add(
    http.MultipartFile.fromBytes(
      "file",
      imageData,
      filename: filename,
      contentType: MediaType(
        'image',
        'jpeg',
      ), // Use the provided filename for the image
    ),
  );

  //-------Send request

  var resp = await request.send();

  http.Response response = await http.Response.fromStream(resp);
  return response;
}

Future<http.Response> getdataaa({
  required String url,
  bool isCustomUrl = false,
  bool addToken = true,
}) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  String sessionToken = SharedPref.pref!.getString(Preferences.token) ?? "";

  // if (addToken) {
  //   requestHeaders = appendAccessTokenWith({}, sessionToken);
  // }

  // else {
  requestHeaders.addAll({'Authorization': 'Bearer ${sessionToken ?? ""}'});
  // }

  final response = await client.get(
    isCustomUrl ? Uri.parse(url) : Uri.parse(baseUrl + url),
    headers: requestHeaders,
  );

  return response;
}

// Future<http.Response> uploadDataWithImage({
//   required String url,
//   required Map<dynamic, dynamic> body, // JSON data
//   Uint8List? imageData, // Optional image data
//   String? filename,
//   // Optional filename for the image
// }) async {
//   // Create a MultipartRequest to send both fields and a file
//   final request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));

//   // Add the JSON data as fields in the request
//   body.forEach((key, value) {
//     request.fields[key] = value.toString(); // Convert each field to a string
//   });

//   // If image data is provided, add it to the request
//   if (imageData != null && filename != null) {
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         "file", // Field name for the file
//         imageData,
//         filename: filename,
//         contentType: MediaType('image', 'jpeg'), // Adjust based on image type
//       ),
//     );
//   }
//   request.headers.addAll({
//     'Authorization':
//         'Bearer ${SharedPref.pref!.getString(Preferences.login_token) ?? ""}'
//   });

//   // Send the multipart request and get the response
//   final streamedResponse = await request.send();
//   return await http.Response.fromStream(streamedResponse);
// }
// Future<void> downloadpdf({
//   required String url,
//   required String filename,
//   required Map<dynamic, dynamic> body,
// }) async {
//   try {
//     final response = await http.post(
//       Uri.parse(baseUrl + url),
//       body: jsonEncode(body),
//       headers: {"Content-Type": "application/json"},
//     );

//     print("Response Status Code: ${response.statusCode}");
//     print("Response Content-Type: ${response.headers['content-type']}");

//     if (response.statusCode == 200) {
//       if (response.headers['content-type'] == 'application/pdf') {
//         Uint8List pdfData = response.bodyBytes;
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = "${directory.path}/$filename.pdf";
//         final file = File(filePath);
//         await file.writeAsBytes(pdfData);
//         print("PDF saved at: $filePath");
//       } else {
//         print("Invalid content type: ${response.headers['content-type']}");
//       }
//     } else {
//       print("Failed to download PDF. Status Code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error downloading PDF: $e");
//   }
// }
// Future<void> downloadPdfToStorage({
//   required String url,
//   required String filename,
//   required Map<dynamic, dynamic> body,
//   required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
// }) async {
//   try {
//     // Make the API request
//     final response = await http.post(
//       Uri.parse(baseUrl + url),
//       body: jsonEncode(body),
//       headers: {
//         'Authorization':
//             'Bearer ${SharedPref.pref!.getString(Preferences.login_token) ?? ""}',
//         "Content-Type": "application/json",
//       },
//     );

//     if (response.statusCode == 200) {
//       // Check if the response is a PDF
//       if (response.headers['content-type'] == 'application/pdf') {
//         String? filePath;

//         if (Platform.isAndroid) {
//           // Use MediaStore API (Scoped Storage) for Android 10+
//           if (await _saveToDownloads(response.bodyBytes, filename)) {
//             scaffoldMessengerKey.currentState?.showSnackBar(
//               SnackBar(content: Text("PDF Downloaded Successfully!")),
//             );
//           } else {
//             scaffoldMessengerKey.currentState?.showSnackBar(
//               SnackBar(content: Text("Failed to save PDF.")),
//             );
//           }
//         } else {
//           // For iOS and older Android versions, save to app-specific storage
//           Directory directory = await getApplicationDocumentsDirectory();
//           filePath = "${directory.path}/$filename.pdf";
//           File file = File(filePath);
//           await file.writeAsBytes(response.bodyBytes);
//           scaffoldMessengerKey.currentState?.showSnackBar(
//             SnackBar(content: Text("PDF Downloaded Successfully!")),
//           );
//           OpenFile.open(filePath);
//         }
//       } else {
//         scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(content: Text("Invalid file format.")),
//         );
//       }
//     } else {
//       scaffoldMessengerKey.currentState?.showSnackBar(
//         SnackBar(content: Text("Failed to download PDF")),
//       );
//     }
//   } catch (e) {
//     print("Error downloading PDF: $e");
//     scaffoldMessengerKey.currentState?.showSnackBar(
//       SnackBar(content: Text("Error downloading PDF: $e")),
//     );
//   }
// }

// /// Function to save file to Downloads folder on Android 10+
// Future<bool> _saveToDownloads(Uint8List data, String filename) async {
//   try {
//     if (Platform.isAndroid) {
//       int androidVersion = await getAndroidVersion();

//       if (androidVersion >= 29) {
//         return await _saveWithMediaStore(data, filename);
//       } else {
//         return await _saveWithWritePermission(data, filename);
//       }
//     }
//   } catch (e) {
//     print("Error saving file: $e");
//   }
//   return false;
// }

// Future<bool> _saveWithMediaStore(Uint8List data, String filename) async {
//   try {
//     Directory? downloadsDir = await getExternalStorageDirectory();
//     if (downloadsDir != null) {
//       String filePath = "${downloadsDir.path}/$filename.pdf";
//       File file = File(filePath);
//       await file.writeAsBytes(data);
//       print("File saved at: $filePath");
//       OpenFile.open(filePath);
//       return true;
//     }
//   } catch (e) {
//     print("Error saving file with MediaStore: $e");
//   }
//   return false;
// }

// Future<bool> _saveWithWritePermission(Uint8List data, String filename) async {
//   try {
//     var status = await Permission.storage.request();
//     if (!status.isGranted) return false;

//     Directory? downloadsDir = Directory('/storage/emulated/0/Download');
//     if (!downloadsDir.existsSync()) {
//       downloadsDir.createSync(recursive: true);
//     }
//     String filePath = "${downloadsDir.path}/$filename.pdf";
//     File file = File(filePath);
//     await file.writeAsBytes(data);
//     print("File saved at: $filePath");
//     OpenFile.open(filePath);
//     return true;
//   } catch (e) {
//     print("Error saving file with write permission: $e");
//   }
//   return false;
// }

// Future<int> getAndroidVersion() async {
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
//     return androidInfo.version.sdkInt;
//   }
//   return 0;
// }

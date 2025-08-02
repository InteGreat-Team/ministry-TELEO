import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileUploadService {
  static Future<String?> uploadProfilePicture(File imageFile) async {
    final uri = Uri.parse('https://asia-southeast1-teleo-church-application.cloudfunctions.net/uploadProfileApi');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'profilePicture',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // Adjust to PNG if needed
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final decoded = jsonDecode(respStr);
      return decoded['url'];
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }
}

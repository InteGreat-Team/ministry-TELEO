import 'dart:typed_data';
import 'package:aws_client/s3_2006_03_01.dart';

class S3UploadService {
  late final S3 s3;
  late String _bucketName;
  late String _region;

  Future<void> init() async {
    try {
      print('🔄 Initializing S3 service...');
      _region = 'ap-southeast-2';
      final accessKeyId = 'AKIAYSOHTLV44LEHH74S';
      final secretAccessKey = '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';
      _bucketName = 'ministrys3storage';

      s3 = S3(
        region: _region,
        credentials: AwsClientCredentials(
          accessKey: accessKeyId,
          secretKey: secretAccessKey,
        ),
      );
      print('✅ S3 service initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize S3 service: $e');
      throw Exception('Failed to initialize S3 service: $e');
    }
  }

  Future<String> uploadFile(
    String key,
    Uint8List fileBytes,
    String contentType,
  ) async {
    try {
      print('📤 Attempting to upload file: $key');
      print('📦 File size: ${fileBytes.length} bytes');

      await s3.putObject(
        bucket: _bucketName,
        key: key,
        body: fileBytes,
        contentType: contentType,
      );

      final url = 'https://$_bucketName.s3.$_region.amazonaws.com/$key';
      print('✅ File uploaded successfully. URL: $url');
      return url;
    } catch (e) {
      print('❌ S3 Upload Error: $e');
      throw Exception('Failed to upload file to S3: $e');
    }
  }
}

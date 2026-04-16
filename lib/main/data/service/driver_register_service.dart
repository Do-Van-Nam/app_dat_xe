import 'dart:io';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api/api_end_point.dart';

class DriverRegisterService {
  final String apiUrl =
      ApiEndPoint.DOMAIN_DRIVER_REGISTER_SUBMIT; // thay bằng API thật

  Future<bool> registerDriver({
    required String fullName,
    required String phone,
    required String citizenId,
    required int vehicleType,
    required String vehicleName,
    required int vehicleColor,
    required String vehicleNumber,
    required int vehicleYear,
    // Các file ảnh
    required XFile cccdFront,
    required XFile cccdBack,
    required XFile driverLicense,
    required XFile vehicleReg,
    required XFile criminalRecord,
    required XFile healthCert,
    required XFile portrait,
    required XFile insurance,
  }) async {
    final token = await SharePreferenceUtil.getLoginToken();

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      // ==================== TEXT FIELDS ====================
      request.fields['full_name'] = fullName;
      request.fields['phone'] = phone;
      request.fields['citizen_id'] = citizenId;
      request.fields['vehicle_type'] = vehicleType.toString();
      request.fields['vehicle_name'] = vehicleName;
      request.fields['vehicle_color'] = vehicleColor.toString();
      request.fields['vehicle_number'] = vehicleNumber;
      request.fields['vehicle_year'] = vehicleYear.toString();

      // ==================== FILE FIELDS ====================
      // Tên field phải KHỚP chính xác với backend
      request.files
          .add(await http.MultipartFile.fromPath('cccd_front', cccdFront.path));
      request.files
          .add(await http.MultipartFile.fromPath('cccd_back', cccdBack.path));
      request.files.add(await http.MultipartFile.fromPath(
          'driver_license', driverLicense.path));
      request.files.add(
          await http.MultipartFile.fromPath('vehicle_reg', vehicleReg.path));
      request.files.add(await http.MultipartFile.fromPath(
          'criminal_record', criminalRecord.path));
      request.files.add(
          await http.MultipartFile.fromPath('health_cert', healthCert.path));
      request.files
          .add(await http.MultipartFile.fromPath('portrait', portrait.path));
      request.files
          .add(await http.MultipartFile.fromPath('insurance', insurance.path));

      // Gửi request
      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Đăng ký thành công!");
        return true;
      } else if (response.statusCode == 409) {
        print("Lỗi: ${response.statusCode}");
        print("Body: $responseBody");
        print("loi 409 ho so dang duyet ");
        return true;
      } else {
        print("Lỗi: ${response.statusCode}");
        print("Body: $responseBody");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// String uri = "http://192.168.100.10/mowing-and-plowing/public";
String uri = "https://staging.mowingandplowing.com";
// String uri = "https://mowing-plowing.mangoitsol.com";
// String uri = "https://staging.mowingandplowing.com";

// ++++++++++++++++++++++++++++++++++++ Base URL ++++++++++++++++++++++++++++++++++++
//****
String baseUrl = "$uri/api";
//****
// String baseUrl = "http://masterbranch-env.us-east-1.elasticbeanstalk.com/api";
//****
// String baseUrl = "https://mowingandplowing.com/api";
//****
// ++++++++++++++++++++++++++++++++++++ End of Base URL ++++++++++++++++++++++++++++++++++++

// ++++++++++++++++++++++++++++++++++++ Base URL Provider ++++++++++++++++++++++++++++++++++++
//****
String baseUrlProvider = "$uri/api/provider";
//****
// String baseUrlProvider = "https://mowingandplowing.com/api/provider";
//****
// String baseUrlProvider =
//     "http://masterbranch-env.us-east-1.elasticbeanstalk.com/api/provider";
//****
// ++++++++++++++++++++++++++++++++++++ End of Base URL Provider ++++++++++++++++++++++++++++++++++++

// ++++++++++++++++++++++++++++++++++++ Image URL ++++++++++++++++++++++++++++++++++++
//****
String imageUrl = uri;
//****
// String imageUrl = "http://masterbranch-env.us-east-1.elasticbeanstalk.com";
//****
// String imageUrl = "https://mowingandplowing.com";
//****
// ++++++++++++++++++++++++++++++++++++ End of Image URL ++++++++++++++++++++++++++++++++++++

class BaseClient {
  var client = http.Client();
  var headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var token;

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
  }

// Email and Phone Number
//
  Future<dynamic> emailPhoneNumber(
    String api,
    String email,
    String phoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "email": email,
      "phone_number": phoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  Future<dynamic> otp(
    String api,
    String phoneNumber,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Add Profile Detail
//
  Future<dynamic> addProfileDetail(
    String api,
    String phoneNumber,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
    String? referralLink,
    File? image,
    String address,
    String latitude,
    String longitude,
    String zip_code,
  ) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(headers);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['phone_number'] = phoneNumber;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = confirmPassword;
    // request.fields['country_code'] = countryCode;
    request.fields['country_code'] = "pk";
    request.fields['address'] = address;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;
    request.fields['zip_code'] = zip_code;
    request.fields['referral_link'] = referralLink!;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }

  Future<dynamic> editProfileDetail(
    String api,
    String firstName,
    String lastName,
    File? image,
    String address,
    String latitude,
    String longitude,
    String zip_code,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['zip_code'] = zip_code;
    request.fields['address'] = address;
    request.fields['lat'] = latitude;
    request.fields['lng'] = longitude;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    await EasyLoading.dismiss();
    return jsonDecode(responseDecode.body);
  }

  //

// Login
//
  Future<dynamic> login(
    String api,
    String phoneNumber,
    String password,
    String userType,
  ) async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "password": password,
      "user_type": userType,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    return json.decode(response.body);
  }

  //

// Log Out
//
  Future<dynamic> logOut(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Forget Password Otp
//
  Future<dynamic> forgetPassword(
    String api,
    String phoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// New Password
//
  Future<dynamic> newPassword(
    String api,
    String phoneNumber,
    String password,
    String confirmPassword,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "phone_number": phoneNumber,
      "password": password,
      "password_confirmation": confirmPassword,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Change Password
//
  Future<dynamic> changePassword(
    String api,
    String currentPassword,
    String password,
    String confirmPassword,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_password": currentPassword,
      "password": password,
      "password_confirmation": confirmPassword,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// New Phone Number
//
  Future<dynamic> newPhoneNumber(
    String api,
    String currentPhoneNumber,
    String newPhoneNumber,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_phone_number": currentPhoneNumber,
      "new_phone_number": newPhoneNumber,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Change Phone Number Otp
//
  Future<dynamic> newPhoneNumberOtp(
    String api,
    String otp,
    // String countryCode,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "otp": otp,
      "country_code": "pk",
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Verify Email
//
  Future<dynamic> verifyEmail(
    String api,
    String email,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "email": email,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Verify Email Otp
//
  Future<dynamic> verifyEmailOtp(
    String api,
    String email,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "email": email,
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Edit Email
//
  Future<dynamic> editEmail(
    String api,
    String currentEmail,
    String newEmail,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "current_email": currentEmail,
      "new_email": newEmail,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// edit Email Otp
//
  Future<dynamic> editEmailOtp(
    String api,
    String otp,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "otp": otp,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Get Properties
//
  Future<http.Response> getProperties(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Add Properties
//
  Future<dynamic> addProperties(
    String api,
    String category_id,
    String address,
    String lat,
    String lng,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "category_id": category_id,
      "address": address,
      "lat": lat,
      "lng": lng,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Delete Properties
//
  Future<dynamic> deleteProperties(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.delete(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Get FAQ
//
  Future<http.Response> getFaqs(
    String api,
    // String type,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "type": "customer",
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return response;
  }

  //

// Get Cards Wallet
//
  Future<http.Response> getCardWallet(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

  Future<http.Response> getWalletAmountOfMP(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Set Default Card
//
  Future<dynamic> setDefaultCard(
    String api,
    // String token,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Delete Card
//
  Future<dynamic> deleteCard(
    String api,
    // String token,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Add Properties
//
  Future<dynamic> updateWalletSetting(
    String api,
    String auto_refill,
    String auto_refill_amount,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "auto_refill": auto_refill,
      "auto_refill_amount": auto_refill_amount,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Add Card
//
  Future<dynamic> addCard(
    String api,
    String card_number,
    String exp_month,
    String exp_year,
    String cvv,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "card_number": card_number,
      "exp_month": exp_month,
      "exp_year": exp_year,
      "cvv": cvv,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Purchase
//
  Future<dynamic> purchase(
    String api,
    String card_id,
    String auto_refill_amount,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "card_id": card_id,
      "auto_refill_amount": auto_refill_amount,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Get Lawn Mowing Sizes Heights Fence
//
  Future<http.Response> sizesHeightsPrices(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Lawn Size Cleanup Price
//
  Future<dynamic> lawnSizeCleanupPrice(
    String api,
    String lawn_size_id,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "lawn_size_id": lawn_size_id,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Service Estimations
//
  Future<dynamic> serviceEstimations(
    String api,
    String lawn_size_id,
    String lawn_height_id,
    String corner_lot,
    String fence,
    String fence_id,
    String cleanup,
    String cleanup_id,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "lawn_size_id": lawn_size_id,
      "lawn_height_id": lawn_height_id,
      "corner_lot": corner_lot,
      "fence": fence,
      "fence_id": fence_id,
      "cleanup": cleanup,
      "cleanup_id": cleanup_id,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Order Summary
//
  Future<dynamic> orderSummary(
    String api,
    String category_id,
    String address,
    String lat,
    String lng,
    String lawn_size_id,
    String lawn_height_id,
    bool? fence,
    String? fence_id,
    String service_delivery,
    String? service_period_id,
    bool? cleanup,
    String? cleanup_id,
    bool? corner_lot,
    String? service_day,
    String? date,
    String? gate_code,
    String? instructions,
    List? images,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    // print(images);
    List? img = images?.where((e) => e != null).toList();
    bool imgIsEmpty = img?.isEmpty ?? true;
    if (!imgIsEmpty) {
      for (String item in img!) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item),
        );
      }
    }
    request.fields['category_id'] = category_id;
    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    request.fields['lawn_size_id'] = lawn_size_id;
    request.fields['lawn_height_id'] = lawn_height_id;
    fence != null ? request.fields['fence'] = fence.toString() : null;
    fence_id != null ? request.fields['fence_id'] = fence_id : null;
    request.fields['service_delivery'] = service_delivery;
    service_period_id != null
        ? request.fields['service_period_id'] = service_period_id
        : null;
    cleanup != null ? request.fields['cleanup'] = cleanup.toString() : null;
    cleanup_id != null ? request.fields['cleanup_id'] = cleanup_id : null;
    corner_lot != null
        ? request.fields['corner_lot'] = corner_lot.toString()
        : null;
    service_day != null ? request.fields['service_day'] = service_day : null;
    date != null ? request.fields['date'] = date : null;
    gate_code != null ? request.fields['gate_code'] = gate_code : null;
    instructions != null ? request.fields['instructions'] = instructions : null;

    var response = await request.send();

    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }

  //

// Update Tip
//
  Future<dynamic> updateTip(
    String api,
    String order_id,
    String tip,
    String tip_perc,
    String? tip_type,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "tip": tip,
      "tip_perc": tip_perc,
      "tip_type": tip_type,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Coupon Code
//
  Future<dynamic> couponCode(
    String api,
    String order_id,
    String? code,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "code": code,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    // if (response.statusCode == 500) {
    //   return [json.decode(response.body), 500];
    // } else {
    //   return [json.decode(response.body), 200];
    // }
    return [json.decode(response.body), response.statusCode];
  }

  //

// Coupon Code Remove
//
  Future<dynamic> couponCodeRemove(
    String api,
    String order_id,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();
    // if (response.statusCode == 500) {
    //   return [json.decode(response.body), 500];
    // } else {
    //   return [json.decode(response.body), 200];
    // }
    return json.decode(response.body);
  }

  //

// Pay Order
//
  Future<dynamic> payOrder(
    String api,
    String order_id,
    String grandTotal,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "grandTotal": grandTotal,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Get Snow-Plowing related category prices and schedule timing
//
  Future<dynamic> snowPlowingCatPrSch(
    String api,
    String type,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "type": type,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Order Summary For Snow Home & Business
//
  Future<dynamic> orderSummaryHome(
    String api,
    String address,
    String lat,
    String lng,
    String category_id,
    String service_for,
    String schedule_id,
    String driveway_width,
    String driveway_length,
    String snow_depth,
    String? instructions,
    String? sidewalk,
    String? sidewalks,
    String? walkway,
    String? walkways,
    List? images,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    // print(images);
    List? img = images?.where((e) => e != null).toList();
    bool imgIsEmpty = img?.isEmpty ?? true;
    if (!imgIsEmpty) {
      for (String item in img!) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item),
        );
      }
    }

    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    request.fields['category_id'] = category_id;
    request.fields['service_for'] = service_for;
    request.fields['schedule_id'] = schedule_id;
    request.fields['driveway_width'] = driveway_width;
    request.fields['driveway_length'] = driveway_length;
    request.fields['snow_depth'] = snow_depth;
    instructions != null ? request.fields['instructions'] = instructions : null;
    sidewalk != null ? request.fields['sidewalk'] = sidewalk : null;
    sidewalks != null ? request.fields['sidewalks'] = sidewalks : null;
    walkway != null ? request.fields['walkway'] = walkway : null;
    walkways != null ? request.fields['walkways'] = walkways : null;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }

  //

// Order Summary For Car
//
  Future<dynamic> orderSummaryCar(
    String api,
    String address,
    String lat,
    String lng,
    String category_id,
    String service_for,
    String car_id,
    String color_id,
    String car_number,
    String? instructions,
    String schedule_id,
    List? images,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
      'POST',
      url,
    )..headers.addAll(tokenHeaders);
    // print(images);
    List? img = images?.where((e) => e != null).toList();
    bool imgIsEmpty = img?.isEmpty ?? true;
    if (!imgIsEmpty) {
      for (String item in img!) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', item),
        );
      }
    }

    request.fields['address'] = address;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    request.fields['category_id'] = category_id;
    request.fields['service_for'] = service_for;
    request.fields['car_id'] = car_id;
    request.fields['color_id'] = color_id;
    request.fields['car_number'] = car_number;
    instructions != null ? request.fields['instructions'] = instructions : null;
    request.fields['schedule_id'] = schedule_id;

    var response = await request.send();
    var responseDecode = await http.Response.fromStream(response);
    // await EasyLoading.dismiss();
    return json.decode(responseDecode.body);
  }

  //

// Get Jobs
//
  Future<http.Response> getJobs(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Delete Job
//
  Future<dynamic> deleteJob(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Get Job Details
//
  Future<dynamic> getJobDetail(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();
    return json.decode(response.body);
  }

  //

// Help
//
  Future<dynamic> help(
    String api,
    String detail,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "detail": detail,
    };
    var body = json.encode(requestData);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return json.decode(response.body);
  }

  //

// Proposals
//
  Future<http.Response> proposal(
    String api,
    String order_id,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var requestData = {
      "order_id": order_id,
    };
    var body = json.encode(requestData);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    return response;
  }

  //

// favorite toggle
//
  Future<dynamic> favProvTogg(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

// accept proposals
//
  Future<dynamic> acceptProposal(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

// decline proposals
//
  Future<dynamic> declineProposals(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

// Get termConditions
//
  Future<http.Response> termCond(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Get Privacy Policy
//
  Future<http.Response> privPolic(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// Get Notifications
//
  Future<http.Response> getNotification(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// read Notifications
//
  Future<http.Response> readNotification(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// delete Notifications
//
  Future<dynamic> deleteNotification(
    String api,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrlProvider + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.delete(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

// Favorite Providers
//
  Future<http.Response> favProv(
    String api,
    // String token,
  ) async
  //
  {
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return response;
  }

  //

// get prov last loc
//
  Future<dynamic> getProvLastLoc(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

  // get ongoing job detail
//
  Future<dynamic> getOnGoingJobDetail(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    return json.decode(response.body);
  }

  //

// Send message
//
  Future<dynamic> sendMessagePress(
    String api,
    String order_id,
    String message,
    String user_id,
    String order_no,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "order_id": order_id,
      "message": message,
      "user_id": user_id,
      "order_no": order_no,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Provider location update
//
  Future<dynamic> getChat(
    String api,
  ) async
  //
  {
    // await EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Update Instructions
//
  Future<dynamic> updateInstructions(
    String api,
    String instructions,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "instructions": instructions,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Mark Job As Completed
//
  Future<dynamic> markJobCompleted(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Rate Job
//
  Future<dynamic> rateJob(
    String api,
    String response_time_rating,
    String quality_rating,
    String? comment,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var requestData = {
      "response_time_rating": response_time_rating,
      "quality_rating": quality_rating,
      "comment": comment,
    };
    var body = json.encode(requestData);
    var response = await client.post(
      url,
      headers: tokenHeaders,
      body: body,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

// Delete Account
//
  Future<dynamic> deleteAccount(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    Map<String, String> tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.post(
      url,
      headers: tokenHeaders,
    );
    // await EasyLoading.dismiss();

    return json.decode(response.body);
  }

  //

  // get service detail
  //
  Future<dynamic> getServiceDetail(
    String api,
  ) async
  //
  {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    await getToken();
    var url = Uri.parse(baseUrl + api);
    var tokenHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await client.get(
      url,
      headers: tokenHeaders,
    );
    await EasyLoading.dismiss();
    return json.decode(response.body);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';
import '../models/recipient_model.dart';

class ApiService {
  final String baseUrl = "https://xjwmobilemassage.com.au/app/api.php";

  /// Generic method to handle HTTP POST requests.
  Future<dynamic> _postRequest(
      String endpoint, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl?apicall=$endpoint'),
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded.containsKey('error') && decoded['error'] == true) {
        throw Exception(decoded['message'] ?? 'An unknown error occurred');
      }
      return decoded;
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  /// Fetches the list of addresses for a given user ID.
  Future<List<Address>> getAddressList(String uid) async {
    try {
      final data = await _postRequest('address_list', {'uid': uid});
      List<dynamic> addresses = data['apps'];
      return addresses.map((json) => Address.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load addresses: $e');
    }
  }

  /// Deletes an address by its ID.
  Future<void> deleteAddress(String id) async {
    try {
      await _postRequest('delete_address', {'id': id});
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  /// Fetches the list of recipients for a given user ID.
  Future<List<Recipient>> getRecipientList(String uid) async {
    try {
      final data = await _postRequest('recipient_list', {'uid': uid});
      List<dynamic> recipients = data['apps'];
      return recipients.map((json) => Recipient.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load recipients: $e');
    }
  }
}

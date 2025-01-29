import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turnkey_flutter_demo_app/config.dart';

class TurnkeyRPCError implements Exception {
  final String code;
  final String message;

  TurnkeyRPCError({required this.code, required this.message});

  @override
  String toString() => 'TurnkeyRPCError(code: $code, message: $message)';
}


//TODO: Type these properly
Future<T> jsonRpcRequest<M, T>(
    String method, Map<String, dynamic> params) async {
  final requestBody = {
    'method': method,
    'params': params,
  };

  final response = await http.post(
    Uri.parse('${EnvConfig.backendApiUrl}/turnkey'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode != 200) {
    final error = jsonDecode(response.body)['error'];
    throw TurnkeyRPCError(code: error['code'], message: error['message']);
  }

  return jsonDecode(response.body) as T;
}

Future<Map<String, dynamic>> initOTPAuth(Map<String, dynamic> params) async {
  return jsonRpcRequest('initOTPAuth', params);
}

Future<String> getSubOrgId(Map<String, dynamic> params) async {
  final response = await jsonRpcRequest('getSubOrgId', params);
  return response['organizationIds'][0];
}

Future<Map<String, dynamic>> createSubOrg(Map<String, dynamic> params) async {
  return jsonRpcRequest('createSubOrg', params);
}

Future<Map<String, dynamic>> getWhoami(Map<String, dynamic> params) async {
  return jsonRpcRequest('getWhoami', params);
}

Future<Map<String, dynamic>> otpAuth(Map<String, dynamic> params) async {
  return jsonRpcRequest('otpAuth', params);
}

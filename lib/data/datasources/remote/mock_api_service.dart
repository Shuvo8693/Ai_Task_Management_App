import 'package:ai_task_management_app/data/datasources/local/auth_local_data_source.dart';
import 'package:get/get.dart';


class MockApiService {
  final AuthLocalDataSource _authLocalDataSource = Get.find();

  Future<Map<String, dynamic>> _simulateApiCall(
      String endpoint, {
        dynamic data,
        String method = 'GET',
      }) async {
    // Get token from shared preferences
    final token = await _authLocalDataSource.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate different responses based on endpoint
    switch (endpoint) {
      case '/projects':
        return {
          'status': 'success',
          'data': [
            {
              'id': '1',
              'name': 'Work',
              'color': 0xFF4285F4,
              'taskCount': 5,
            },
            {
              'id': '2',
              'name': 'Personal',
              'color': 0xFF0F9D58,
              'taskCount': 3,
            },
          ],
        };
      case '/tasks':
        return {
          'status': 'success',
          'data': [
            {
              'id': '1',
              'title': 'Complete project proposal',
              'priority': 2,
              'dueDate': DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch,
              'isCompleted': false,
            },
          ],
        };
      default:
        return {'status': 'success', 'data': null};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    return _simulateApiCall(endpoint);
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    return _simulateApiCall(endpoint, data: data, method: 'POST');
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    return _simulateApiCall(endpoint, data: data, method: 'PUT');
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    return _simulateApiCall(endpoint, method: 'DELETE');
  }
}
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum DataPoint {date, String}

class GraphData {
  List<DataPoint> data = new List<DataPoint>();

  Future<List<DataPoint>> getGraphData(String graphType) async {
    /// Graph types:
    /// - total_last_week
    /// - avg_spend_last_week
    /// - total_last_month
    /// - avg_spend_last_month
    ///
    /// HTTP POST request sample:
    /// {"graph":"total_last_week","session_key":"blahblahblah"}

    final url = "https://dev.peartrade.org/api/v1/customer/graphs";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, String> body = {
      'graph': graphType,
      'session_key': preferences.get('LastToken'),
    };

    final response = await http.post(
      url,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final labels = responseJson['graph']['labels'];
      final data = responseJson['graph']['data'];
//      final bounds = responseJson['graph']['bounds']; // why is this even returned?
//      print(labels[5]);
//      print(data[5]);
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print("Error: " + errorMessage);
    }
  }


}


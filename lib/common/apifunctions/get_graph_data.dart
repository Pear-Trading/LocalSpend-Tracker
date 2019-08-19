import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphData {
  var chartType;
  List<charts.Series<dynamic, DateTime>> graph;

  GraphData(
    this.chartType,
  );

  List<TimeSeriesSpend> cachedData;
  bool loaded = false;

  Future<void> setGraphData() async {
    if (loaded == true) {
      this.graph = [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: cachedData,
        )
      ];
    }

    final url = "https://dev.peartrade.org/api/v1/customer/graphs";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, String> body = {
      'graph': this.chartType,
      'session_key': preferences.get('LastToken'),
    };

    final response = await http.post(
      url,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final List<dynamic> labels = responseJson['graph']['labels'];
      final List<dynamic> data = responseJson['graph']['data'];

      List<TimeSeriesSpend> timeSeriesSpendList = new List<TimeSeriesSpend>();

      for (int i = 0; i < labels.length; i++) {
        timeSeriesSpendList.add(new TimeSeriesSpend(data[i]*1.00, DateTime.parse(labels[i])));
//        print(timeSeriesSpendList[i].time.toString() + " : " + timeSeriesSpendList[i].spend.toString());
      }

      cachedData = timeSeriesSpendList;
      loaded = true;

      this.graph = [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: timeSeriesSpendList,
        )
      ];
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print("Error: " + errorMessage);

      this.graph = null;
    }
  }

  Future<List<charts.Series<dynamic, DateTime>>> getGraphData() async {
    if (loaded == true) {
      return [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: cachedData,
        )
      ];
    }

    // TODO: Show available graph types based on whether or not the user is an Organisation or User

    /// Customer graph types: https://dev.peartrade.org/api/v1/customer/graphs
    /// - total_last_week
    /// - avg_spend_last_week
    /// - total_last_month
    /// - avg_spend_last_month
    ///
    /// Organisations' graphs types: to fetch, POST to https://dev.peartrade.org/api/stats/[name] as {"session_key":"[boop beep]"}
    /// - organisations_all :     organisation
    /// - pies :                  organisation/pies
    /// - snippets :              organisation/snippets
    /// - graphs :                organisation/graphs
    ///   - {"graph":"customers_last_7_days","session_key":"[bleep]"}
    ///   - {"graph":"customers_last_30_days","session_key":"[blah]"}
    ///   - {"graph":"sales_last_7_days","session_key":"[bloop]"}
    ///   - {"graph":"sales_last_7_days","session_key":"[reee]"}
    ///   - {"graph":"purchases_last_7_days","session_key":"[yee]"}
    ///   - {"graph":"purchases_last_30_days","session_key":"[yah]"}
    ///   - {"graph":"purchases_all;","session_key":"[kappa]"}          // I don't think this one works
    ///
    /// HTTP POST request sample:
    /// {"graph":"total_last_week","session_key":"blahblahblah"}

    final url = "https://dev.peartrade.org/api/v1/customer/graphs";
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, String> body = {
      'graph': this.chartType,
      'session_key': preferences.get('LastToken'),
    };

    final response = await http.post(
      url,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final List<dynamic> labels = responseJson['graph']['labels'];
      final List<dynamic> data = responseJson['graph']['data'];

      List<TimeSeriesSpend> timeSeriesSpendList = new List<TimeSeriesSpend>();

      for (int i = 0; i < labels.length; i++) {
        timeSeriesSpendList.add(new TimeSeriesSpend(data[i]*1.00, DateTime.parse(labels[i])));
//        print(timeSeriesSpendList[i].time.toString() + " : " + timeSeriesSpendList[i].spend.toString());
      }

      cachedData = timeSeriesSpendList;
      loaded = true;

      return [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: timeSeriesSpendList,
        )
      ];
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print("Error: " + errorMessage);

      return null;
    }
  }


}

class TimeSeriesSpend {
  final DateTime time;
  final double spend;

  TimeSeriesSpend(this.spend, this.time);
}


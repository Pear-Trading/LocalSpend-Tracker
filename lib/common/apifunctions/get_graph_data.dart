import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Customer graph types: https://dev.localspend.co.uk/api/v1/customer/graphs
/// - total_last_week
/// - avg_spend_last_week
/// - total_last_month
/// - avg_spend_last_month

/// Organisations' graphs types: to fetch, POST to https://dev.localspend.co.uk/api/stats/[name] as {"session_key":"[boop beep]"}
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

class OrganisationGraph {
  OrganisationGraph(this.chartType, {this.graphsType = ""});

  String graphsType =
      ""; // type of graph, eg customers_last_7_days, sales_last_30_days, purchases_last_30_days etc
  String
      chartType; // type of chart, eg organisations_all, pies, snippets or graphs

  List<charts.Series<TimeSeriesCustomersOrSales, DateTime>> graph;

  List<TimeSeriesCustomersOrSales> cachedData;

  bool loaded = false;

  Future<void> getGraphData() async {
    if (loaded) {
      this.graph = [
        new charts.Series<TimeSeriesCustomersOrSales, DateTime>(
          id: 'Chart',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesCustomersOrSales spend, _) => spend.time,
          measureFn: (TimeSeriesCustomersOrSales spend, _) =>
              spend.numberOfStuff,
          data: cachedData,
        )
      ];
      return null;
    }

    String url = "https://dev.localspend.co.uk/api/v1/organisation/";

    if (!(this.chartType == "organisations_all")) {
      url += this.chartType;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> body;

    if (this.chartType == "graphs") {
      body = {
        'graph': this.graphsType,
        'session_key': preferences.get('LastToken'),
      };
    } else {
      body = {
        'session_key': preferences.get('LastToken'),
      };
    }

    print(url);
    print(json.encode(body).toString());

    final response = await http.post(
      url,
      body: json.encode(body),
    );

    try {
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final List<dynamic> labels = responseJson['graph']['labels'];
        final List<dynamic> data = responseJson['graph']['data'];

        List<TimeSeriesCustomersOrSales> graphDataList =
            new List<TimeSeriesCustomersOrSales>();

        for (int i = 0; i < labels.length; i++) {
          graphDataList.add(new TimeSeriesCustomersOrSales(
              data[i] * 1.00, DateTime.parse(labels[i])));
        }

        this.cachedData = graphDataList;
        this.loaded = true;

        this.graph = [
          new charts.Series<TimeSeriesCustomersOrSales, DateTime>(
            id: 'Chart',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesCustomersOrSales spend, _) => spend.time,
            measureFn: (TimeSeriesCustomersOrSales spend, _) =>
                spend.numberOfStuff,
            data: graphDataList,
          )
        ];
        return this.graph;
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print("Error: " + errorMessage);
        this.graph = null;
      }
    } catch (error) {
      print(error.toString());
    }
  }
}

class GraphData {
  GraphData(
    this.chartType,
  );

  var chartType;
  List<charts.Series<dynamic, DateTime>> graph;

  List<TimeSeriesSpend> cachedData;
  bool loaded = false;

  Future<List<charts.Series<dynamic, DateTime>>> setGraphData() async {
    if (loaded) {
      this.graph = [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: cachedData,
        )
      ];
      return null;
    }

    final url = "https://dev.localspend.co.uk/api/v1/customer/graphs";
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
        timeSeriesSpendList.add(
            new TimeSeriesSpend(data[i] * 1.00, DateTime.parse(labels[i])));
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
      return this.graph;
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print("Error: " + errorMessage);

      this.graph = null;
      return null;
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

    final url = "https://dev.localspend.co.uk/api/v1/customer/graphs";
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
        timeSeriesSpendList.add(
            new TimeSeriesSpend(data[i] * 1.00, DateTime.parse(labels[i])));
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
  TimeSeriesSpend(this.spend, this.time);

  final DateTime time;
  final double spend;
}

class TimeSeriesCustomersOrSales {
  TimeSeriesCustomersOrSales(this.numberOfStuff, this.time);

  final DateTime time;
  final double numberOfStuff;
}

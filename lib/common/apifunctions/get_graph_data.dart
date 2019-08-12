import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphData {
  List<charts.Series> data = new List<charts.Series>();

  Future<List<charts.Series<dynamic, DateTime>>> getGraphData(String graphType) async {
//    print("called");
    /// Graph types:
    /// - total_last_week
    /// - avg_spend_last_week
    /// - total_last_month
    /// - avg_spend_last_month
    ///
    /// HTTP POST request sample:
    /// {"graph":"total_last_week","session_key":"blahblahblah"}

    charts.Series<dynamic, DateTime> dataSeries = new charts.Series<dynamic, DateTime>();
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
      final List<dynamic> labels = responseJson['graph']['labels'];
      final List<dynamic> data = responseJson['graph']['data'];

      for (int i = 0; i < data.length; i++) {
//        print(labels[i].toString() + " : " + data[i].toString());
      }
//      final List<String> bounds = responseJson['graph']['bounds']; // why is this even returned?

      /*
      final data = [
        new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
        new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
        new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
        new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
      ];
       */

      List<TimeSeriesSpend> timeSeriesSpendList = new List<TimeSeriesSpend>();

      for (int i = 0; i < labels.length; i++) {
//        print(DateTime.parse(labels[i]));
        timeSeriesSpendList.add(new TimeSeriesSpend(i, DateTime(i)));
//        timeSeriesSpendList.add(new TimeSeriesSpend(data[i], DateTime.parse(labels[i])));
      }

//      print(timeSeriesSpendList);

      return [
        new charts.Series<TimeSeriesSpend, DateTime>(
          id: 'Spend',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSpend spend, _) => spend.time,
          measureFn: (TimeSeriesSpend spend, _) => spend.spend,
          data: timeSeriesSpendList,
        )
      ];

      /*
        new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )*/

//      print(labels[5]);
//      print(data[5]);
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print("Error: " + errorMessage);

      return null;
    }
  }


}

class TimeSeriesSpend {
  final DateTime time;
  final int spend;

  TimeSeriesSpend(this.spend, this.time);
}


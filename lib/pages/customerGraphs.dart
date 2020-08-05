import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CustomerGraphs extends StatefulWidget {
  CustomerGraphs({Key key}) : super(key: key);

  @override
  _CustomerGraphsState createState() {
    return _CustomerGraphsState();
  }
}

class _CustomerGraphsState extends State<CustomerGraphs> {
  GraphData totalLastWeekGraph = new GraphData("total_last_week");
  GraphData avgSpendLastWeekGraph = new GraphData("avg_spend_last_week");
  GraphData totalLastMonthGraph = new GraphData("total_last_month");
  GraphData avgSpendLastMonth = new GraphData("avg_spend_last_month");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initializing graphs:
    if (!totalLastWeekGraph.loaded) {
      totalLastWeekGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!avgSpendLastWeekGraph.loaded) {
      avgSpendLastWeekGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!totalLastMonthGraph.loaded) {
      totalLastMonthGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!avgSpendLastMonth.loaded) {
      avgSpendLastMonth.setGraphData().then((_) {
        setState(() {});
      });
    }

    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "Last Week's Total Spend",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Graph of total spend last week",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: totalLastWeekGraph.graph != null
                ? new charts.TimeSeriesChart(totalLastWeekGraph.graph)
                : Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.orange),
                  )), //List<Series<dynamic, DateTime>>es<dynamic, DateTime>>
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "Last Week's Average Spend",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Graph of average spend last week",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: avgSpendLastWeekGraph.graph != null
                ? new charts.TimeSeriesChart(avgSpendLastWeekGraph.graph)
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  )), //List<Series<dynamic, DateTime>>es<dynamic, DateTime>>
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "Last Month's Total Spend",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Graph of total spend last month",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: totalLastMonthGraph.graph != null
                ? new charts.TimeSeriesChart(totalLastMonthGraph.graph)
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  )), //List<Series<dynamic, DateTime>>es<dynamic, DateTime>>
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "Last Month's Average Spend",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Graph of average spend last month",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: avgSpendLastMonth.graph != null
                ? new charts.TimeSeriesChart(avgSpendLastMonth.graph)
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  )), //List<Series<dynamic, DateTime>>es<dynamic, DateTime>>
          ),
        ),
      ],
    );
  }
}

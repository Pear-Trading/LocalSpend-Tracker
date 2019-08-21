import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OrgGraphs extends StatefulWidget {
  OrgGraphs({Key key}) : super(key: key);

  @override
  _OrgGraphsState createState() {
    return _OrgGraphsState();
  }
}

class _OrgGraphsState extends State<OrgGraphs> {

  /// Organisations' graphs types: to fetch, POST to https://dev.localspend.co.uk/api/stats/[graph_type] as {"session_key":"[boop beep]"}
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

//  OrganisationGraph customersLastWeek = new OrganisationGraph("graphs", graphsType: "customers_last_7_days");
  OrganisationGraph customersLastMonth = new OrganisationGraph("graphs", graphsType: "customers_last_30_days");
  OrganisationGraph salesLastMonth = new OrganisationGraph("graphs", graphsType: "sales_last_30_days");
  OrganisationGraph purchasesLastMonth = new OrganisationGraph("graphs", graphsType: "purchases_last_30_days"); //purchases_last_30_days

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
//    if (!customersLastWeek.loaded) {
//      customersLastWeek.getGraphData().then((_) {
//        setState(() {});
//      });
//    }
    if (!customersLastMonth.loaded) {
      customersLastMonth.getGraphData().then((_) {
        setState(() {});
      });
    }
    if (!salesLastMonth.loaded) {
      salesLastMonth.getGraphData().then((_) {
        setState(() {});
      });
    }
    if (!purchasesLastMonth.loaded) {
      purchasesLastMonth.getGraphData().then((_) {
        setState(() {});
      });
    }

    return ListView(
      children: <Widget>[
//        Container(
//          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
//          child: Text(
//            "Last Week's Customers",
//            textAlign: TextAlign.center,
//            style: TextStyle(
//              fontSize: 22.0,
//              color: Colors.black,
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//        ),
//        Tooltip(
//          message: "Graph of customers last week",
//          child: Container(
//            padding: EdgeInsets.symmetric(horizontal: 10),
//            height: 200,
//            child: customersLastWeek.graph != null
//                ? new charts.TimeSeriesChart(customersLastWeek.graph)
//                : Center(
//                child: Text(
//                    "Loading graph...")), //List<Series<dynamic, DateTime>>
//          ),
//        ),

        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "This Month's Customers",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Customers this month", // this needs to be better
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: customersLastMonth.graph != null
                ? new charts.TimeSeriesChart(customersLastMonth.graph)
                : Center(
                child: Text(
                    "Loading graph...")), //List<Series<dynamic, DateTime>>
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "This Month's Revenue",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Revenue from sales this month",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: salesLastMonth.graph != null
                ? new charts.TimeSeriesChart(salesLastMonth.graph)
                : Center(
                child: Text(
                    "Loading graph...")), //List<Series<dynamic, DateTime>>
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(0.0, 17, 0.0, 0.0),
          child: Text(
            "This Month's Sales",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tooltip(
          message: "Number of sales this month",
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: purchasesLastMonth.graph != null
                ? new charts.TimeSeriesChart(purchasesLastMonth.graph)
                : Center(
                child: Text(
                    "Loading graph...")), //List<Series<dynamic, DateTime>>
          ),
        ),

      ],
    );
  }
}

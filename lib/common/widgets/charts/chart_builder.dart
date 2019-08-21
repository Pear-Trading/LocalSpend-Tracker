import 'package:flutter/material.dart';
import 'package:local_spend/common/widgets/charts/time_series_simple.dart';

class TimeSeries extends StatelessWidget {
  TimeSeries({
    this.chartDataName,
  });

  final String chartDataName;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
      child: SimpleTimeSeriesChart.withSampleData(),
    );
  }
}

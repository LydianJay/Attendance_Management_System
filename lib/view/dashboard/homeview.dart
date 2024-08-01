import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BarChartGroupData> _data() {
    return [
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 5)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 4)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 3)],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 2)],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: scrWidth * 0.12,
                height: scrHeight * 0.05,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('No of employee: 3'),
              ),
              Container(
                width: scrWidth * 0.12,
                height: scrHeight * 0.05,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('No of employee: 3'),
              ),
              Container(
                width: scrWidth * 0.12,
                height: scrHeight * 0.05,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('No of employee: 3'),
              ),
              Container(
                width: scrWidth * 0.12,
                height: scrHeight * 0.05,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('No of employee: 3'),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 125),
          width: scrWidth * 0.6,
          height: scrHeight * 0.5,
          child: BarChart(
            BarChartData(
              barGroups: _data(),
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
      ],
    );
    ;
  }
}

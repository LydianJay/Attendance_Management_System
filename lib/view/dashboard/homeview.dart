import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextStyle _tsh1 = const TextStyle(
    fontSize: 20,
    fontFamily: 'Helvetica',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black, blurRadius: 0.1)],
  );
  final TextStyle _tsb1 = const TextStyle(
    fontSize: 26,
    fontFamily: 'Helvetica',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black, blurRadius: 0.1)],
  );
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: scrWidth * 0.15,
                height: scrHeight * 0.15,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 37, 151, 33),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Employees',
                      style: _tsh1,
                    ),
                    Text(
                      '3',
                      style: _tsb1,
                    ),
                  ],
                ),
              ),
              Container(
                width: scrWidth * 0.15,
                height: scrHeight * 0.15,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'On Leave',
                      style: _tsh1,
                    ),
                    Text(
                      '0',
                      style: _tsb1,
                    ),
                  ],
                ),
              ),
              Container(
                width: scrWidth * 0.15,
                height: scrHeight * 0.15,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 33, 33),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Absents',
                      style: _tsh1,
                    ),
                    Text(
                      '31',
                      style: _tsb1,
                    ),
                  ],
                ),
              ),
              Container(
                width: scrWidth * 0.15,
                height: scrHeight * 0.15,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 134, 134, 134),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Late',
                      style: _tsh1,
                    ),
                    Text(
                      '3',
                      style: _tsb1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 100),
          width: scrWidth * 0.6,
          height: scrHeight * 0.5,
          child: BarChart(
            BarChartData(
              barGroups: _data(),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                    axisNameWidget: Text(
                      'General Analytics',
                      style: _tsh1.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    axisNameSize: 32),
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
      ],
    );
  }
}

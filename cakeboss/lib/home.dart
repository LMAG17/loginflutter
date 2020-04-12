import 'dart:math';

import 'package:cakeboss/charts/pie_chart.dart';
import 'package:cakeboss/points_line_chart.dart';
import 'package:flutter/material.dart';

import 'charts/bar_chart.dart';
import 'charts/combo_chart.dart';
import 'charts/grouped_stacked_bar_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data = [
    Categorias('a', 1, Colors.blue),
    Categorias('b', 1, Colors.orange),
    Categorias('c', 1, Colors.green),
    Categorias('d', 1, Colors.yellow),
    Categorias('e', 1, Colors.purple),
    Categorias('f', 4, Colors.blue),
    Categorias('g', 4, Colors.orange),
    Categorias('h', 4, Colors.green),
    Categorias('i', 4, Colors.yellow),
    Categorias('j', 4, Colors.purple),
    Categorias('k', 1, Colors.blue),
    Categorias('l', 1, Colors.orange),
    Categorias('m', 1, Colors.green),
    Categorias('n', 1, Colors.yellow),
    Categorias('o', 1, Colors.purple),
    Categorias('p', 3, Colors.blue),
    Categorias('q', 3, Colors.orange),
    Categorias('r', 3, Colors.green),
    Categorias('s', 3, Colors.yellow),
    Categorias('t', 3, Colors.purple),
    Categorias('u', 1, Colors.blue),
    Categorias('v', 1, Colors.orange),
    Categorias('w', 1, Colors.green),
    Categorias('x', 1, Colors.yellow),
    Categorias('y', 1, Colors.purple),
    Categorias('z', 2, Colors.blue),
    Categorias('a1', 2, Colors.orange),
    Categorias('b1', 2, Colors.green),
    Categorias('c1', 2, Colors.yellow),
    Categorias('d1', 2, Colors.purple),
  ];
  List<charts.Series<Categorias, String>> _generateData() {
    return [
      charts.Series(
        data: data,
        id: 'Categorias',
        colorFn: (Categorias category, __) =>
            charts.ColorUtil.fromDartColor(category.color),
        domainFn: (Categorias category, _) => category.name,
        measureFn: (Categorias category, _) => category.value,
        labelAccessorFn: (Categorias category, _) => '${category.value}',
      )
    ];
  }

  List<charts.Series<Ventas, int>> _createLinearSampleData() {
    final desktopSalesData = [
      Ventas(1, 25),
      Ventas(2, 100),
      Ventas(3, 75),
      Ventas(4, 5),
      Ventas(5, 25),
      Ventas(6, 100),
      Ventas(7, 75),
      Ventas(8, 5),
      Ventas(9, 25),
      Ventas(10, 100),
      Ventas(11, 75),
      Ventas(12, 5),
      Ventas(13, 25),
      Ventas(14, 100),
      Ventas(15, 75),
      Ventas(16, 5),
      Ventas(17, 25),
      Ventas(18, 100),
      Ventas(19, 75),
      Ventas(20, 5),
      Ventas(21, 25),
      Ventas(22, 5),
      Ventas(23, 25),
      Ventas(24, 100),
      Ventas(25, 75),
      Ventas(26, 5),
      Ventas(27, 25),
      Ventas(28, 100),
      Ventas(29, 75),
      Ventas(30, 5),
    ];

    final tableSalesData = [
      Ventas(1, 50),
      Ventas(2, 200),
      Ventas(3, 150),
      Ventas(4, 10),
      Ventas(5, 50),
      Ventas(6, 200),
      Ventas(7, 150),
      Ventas(8, 10),
      Ventas(9, 50),
      Ventas(10, 10),
      Ventas(11, 50),
      Ventas(12, 200),
      Ventas(13, 150),
      Ventas(14, 10),
      Ventas(15, 50),
      Ventas(16, 200),
      Ventas(17, 150),
      Ventas(18, 10),
      Ventas(19, 50),
      Ventas(20, 10),
      Ventas(21, 50),
      Ventas(22, 200),
      Ventas(23, 150),
      Ventas(24, 10),
      Ventas(25, 50),
      Ventas(26, 200),
      Ventas(27, 150),
      Ventas(28, 10),
      Ventas(29, 50),
      Ventas(30, 10),
    ];

    final mobileSalesData = [
      Ventas(1, 70),
      Ventas(2, 100),
      Ventas(3, 150),
      Ventas(4, 10),
      Ventas(5, 70),
      Ventas(6, 100),
      Ventas(7, 150),
      Ventas(8, 10),
      Ventas(9, 70),
      Ventas(10, 10),
      Ventas(11, 70),
      Ventas(12, 100),
      Ventas(13, 150),
      Ventas(14, 10),
      Ventas(15, 70),
      Ventas(16, 100),
      Ventas(17, 150),
      Ventas(18, 10),
      Ventas(19, 70),
      Ventas(20, 10),
      Ventas(21, 70),
      Ventas(22, 100),
      Ventas(23, 150),
      Ventas(24, 10),
      Ventas(25, 70),
      Ventas(26, 100),
      Ventas(27, 150),
      Ventas(28, 10),
      Ventas(29, 70),
      Ventas(30, 10),
    ];
    return [
      charts.Series<Ventas, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Ventas sales, _) => sales.day,
        measureFn: (Ventas sales, _) => sales.ventas,
        data: desktopSalesData,
      ),
      charts.Series<Ventas, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Ventas sales, _) => sales.day,
        measureFn: (Ventas sales, _) => sales.ventas,
        data: tableSalesData,
      ),
      charts.Series<Ventas, int>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (Ventas sales, _) => sales.day,
          measureFn: (Ventas sales, _) => sales.ventas,
          data: mobileSalesData)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba de concepto graficas con charts_flutter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: MediaQuery.of(context).size.height * 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 400,
                  child: SimpleBarChart(_generateData()),
                ),
                Container(
                  height: 200,
                  child: PieInsideLabelChart(_generateData()),
                ),
                Container(
                  height: 200,
                  child: NumericComboLineBarChart.withSampleData(),
                ),
                Container(
                  height: 200,
                  child: GroupedStackedBarChart.withSampleData(),
                ),
                Container(
                  height: 200,
                  child: NumericComboLinePointChart(
                    _createLinearSampleData(),
                  ),
                ),
                Container(
                  height: 200,
                  child: charts.PieChart(
                    _generateData(),
                    animate: true,
                    defaultRenderer: charts.ArcRendererConfig(
                        arcWidth: 30,
                        startAngle: 4 / 5 * pi,
                        arcLength: 7 / 5 * pi),
                  ),
                ),
                Container(
                  height: 200,
                  child: charts.BarChart(
                    _generateData(),
                    animate: true,
                    primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                            desiredTickCount: 3)),
                    secondaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                            desiredTickCount: 3)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Categorias {
  final String name;
  final int value;
  final Color color;

  Categorias(this.name, this.value, this.color);
}

class Ventas {
  final int day;
  final int ventas;

  Ventas(
    this.day,
    this.ventas,
  );
}

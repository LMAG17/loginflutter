import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ClientesPage extends StatelessWidget {
  const ClientesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataClientes = [
      Clientes('Bog. cedritos', 3000, Colors.blue),
      Clientes('Medellin', 2000, Colors.purple),
      Clientes('Cali', 1000, Colors.green),
      Clientes('Bog. Suba', 3000, Colors.orangeAccent[700]),
      Clientes('Bogota', 4000, Colors.red),
    ];
    List<charts.Series<Clientes, String>> _dataClientes() {
      return [
        charts.Series<Clientes, String>(
          id: 'Clientes',
          data: dataClientes,
          domainFn: (Clientes venta, __) => venta.ciudad,
          measureFn: (Clientes venta, __) => venta.cantidad,
          labelAccessorFn: (Clientes venta, _) {
            return '${venta.cantidad}';
          },
          colorFn: (Clientes venta, __) =>
              charts.ColorUtil.fromDartColor(venta.color),
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Card(
        elevation: 8,
        child: Column(
          children: <Widget>[
            Text(
              'Clientes por ciudad',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300,
              child: charts.PieChart(
                _dataClientes(),
                animate: true,
                behaviors: [
                  charts.DatumLegend(
                    desiredMaxColumns: 1,
                    outsideJustification: charts.OutsideJustification.start,
                    legendDefaultMeasure:
                        charts.LegendDefaultMeasure.firstValue,
                  )
                ],
                defaultRenderer: charts.ArcRendererConfig(
                    arcRendererDecorators: [
                      charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.auto)
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Clientes {
  final String ciudad;
  final int cantidad;
  final Color color;

  Clientes(this.ciudad, this.cantidad, this.color);
}

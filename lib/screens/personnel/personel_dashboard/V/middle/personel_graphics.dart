import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartScreen extends StatelessWidget {
  const BarChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Sütun Grafiği Örneği")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChartWidget(),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _getBarGroups(), // Grafik verisi
        borderData: FlBorderData(show: false), // Kenar çizgileri yok
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text("Ocak");
                  case 1:
                    return Text("Şubat");
                  case 2:
                    return Text("Mart");
                  case 3:
                    return Text("Nisan");
                  case 4:
                    return Text("Mayıs");
                  default:
                    return Text("");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 2 Renkli Örnek Sütun Grafiği
  List<BarChartGroupData> _getBarGroups() {
    return [
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: 8, color: Colors.blue, width: 16),
        BarChartRodData(toY: 6, color: Colors.red, width: 16),
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: 10, color: Colors.blue, width: 16),
        BarChartRodData(toY: 4, color: Colors.red, width: 16),
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(toY: 14, color: Colors.blue, width: 16),
        BarChartRodData(toY: 12, color: Colors.red, width: 16),
      ]),
      BarChartGroupData(x: 3, barRods: [
        BarChartRodData(toY: 16, color: Colors.blue, width: 16),
        BarChartRodData(toY: 10, color: Colors.red, width: 16),
      ]),
      BarChartGroupData(x: 4, barRods: [
        BarChartRodData(toY: 20, color: Colors.blue, width: 16),
        BarChartRodData(toY: 14, color: Colors.red, width: 16),
      ]),
    ];
  }
}

class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Icon(
              Icons.person_pin,
              size: widgetSize,
              color: Colors.amber,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'assets/icons/librarian-svgrepo-com.svg',
              size: widgetSize,
              borderColor: Colors.green,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.brown,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge('assets/icons/fitness-svgrepo-com.svg',
                size: widgetSize, borderColor: Colors.pink),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.amber,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'assets/icons/worker-svgrepo-com.svg',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Text('D')),
    );
  }
}

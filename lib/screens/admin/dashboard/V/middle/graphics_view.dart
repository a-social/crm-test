import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
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

class CustomPieChart extends StatelessWidget {
  final Map<String, int> data;
  //yüksekliğini ve genişliğini şimdilik uzaktan veriyoruz

  const CustomPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = _generateSections(data);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150, // Pie Chart sabit genişlik
          height: 150, // Pie Chart sabit yükseklik
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(width: 40), // Pie Chart ile legend arasında boşluk
        Expanded(child: _buildLegend()), // Legend düzgün hizalanır
      ],
    );
  }

  List<PieChartSectionData> _generateSections(Map<String, int> data) {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.brown,
    ];

    int index = 0;
    return data.entries
        .map((entry) {
          final value = entry.value.toDouble();
          if (value == 0) return null; // 0 değerleri gösterme

          return PieChartSectionData(
            value: value,
            color: colors[index++ % colors.length],
            radius: 50,
            showTitle: false,
          );
        })
        .whereType<PieChartSectionData>()
        .toList();
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: data.entries.where((entry) => entry.value > 0).map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getColorForKey(entry.key),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${entry.key} (${entry.value})", // Etiketlere sayı eklendi
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForKey(String key) {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.brown,
    ];
    return colors[data.keys.toList().indexOf(key) % colors.length];
  }
}

// Örnek Kullanım
class PieChartExample extends StatelessWidget {
  const PieChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> sampleData = {
      "Yeni Atanan": 0,
      "Yanlış Kişi / No": 2,
      "Takipte Kal": 18,
      "Cevapsız": 1494,
      "İlgili / Sıcak Takip": 2,
      "Yatırımcı": 0,
      "Kara Liste": 14,
      "İlgilenmiyor": 107,
      "Tekrar Ara": 44,
      "Ulaşılamıyor": 87,
    };

    return CustomPieChart(data: sampleData);
  }
}

class PieChartUserDetailScreen extends StatefulWidget {
  const PieChartUserDetailScreen({super.key});

  @override
  _PieChartUserDetailScreenState createState() =>
      _PieChartUserDetailScreenState();
}

class _PieChartUserDetailScreenState extends State<PieChartUserDetailScreen> {
  late Future<Map<String, int>> _phoneStatusCounts;
  final PersonnelManager _manager = PersonnelManager();

  @override
  void initState() {
    super.initState();
    _phoneStatusCounts = _manager.getPhoneStatusCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, int>>(
          future: _phoneStatusCounts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Veri yok"));
            }

            return CustomPieChart(data: snapshot.data!);
          },
        ),
      ),
    );
  }
}

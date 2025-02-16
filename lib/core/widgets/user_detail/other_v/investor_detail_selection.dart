import 'package:flutter/material.dart';

class InvestorSelectionRow extends StatefulWidget {
  const InvestorSelectionRow({super.key});

  @override
  _InvestorSelectionRowState createState() => _InvestorSelectionRowState();
}

class _InvestorSelectionRowState extends State<InvestorSelectionRow> {
  String? selectedDepartment;
  String? selectedRelationship;

  final List<String> departments = [
    "Yatırım Danışmanlığı",
    "Finansal Planlama",
    "Müşteri Hizmetleri",
    "Portföy Yönetimi"
  ];

  final List<String> relationshipStatuses = [
    "Potansiyel Yatırımcı",
    "Mevcut Yatırımcı",
    "Riskli Müşteri",
    "Uzun Vadeli Müşteri"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Departman Seçimi
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Departman Seçiniz",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: selectedDepartment,
              items: departments.map((dept) {
                return DropdownMenuItem<String>(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12), // Araya boşluk koyduk

          // İlişki Durumu Seçimi
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "İlişki Durumu Seçiniz",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: selectedRelationship,
              items: relationshipStatuses.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRelationship = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

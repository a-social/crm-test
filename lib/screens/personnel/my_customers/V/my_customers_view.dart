import 'package:crm_k/core/service/filter_service.dart';
import 'package:crm_k/screens/admin/dashboard/V/middle/graphics_view.dart';

import 'package:crm_k/screens/personnel/personel_dashboard/V/middle/V/list_user_for_personel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyCustomersView extends StatelessWidget {
  const MyCustomersView({super.key});
  //lazy loading eklenecek bir süre sonra şimdilik göstermelik böyle kalsın

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        //sonradan card ile sarmala burayı
        child: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: FilterScreen(),
                    )),
                SizedBox(width: 15),
                Expanded(
                    child: Container(
                  child: PieChartUserDetailScreen(),
                ))
              ],
            )),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: PersonelUserListScreenViewHardDetail(),
                    ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    DateTime initialDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      isStartDate
          ? filterProvider.setStartDate(picked)
          : filterProvider.setEndDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildFixedSizeField(
                      "CRM Numarası", constraints, filterProvider.setCRMNumber),
                  _buildFixedSizeField(
                      "Ad Soyad", constraints, filterProvider.setSearchQuery),
                  _buildFixedSizeDropdown("Hesap Türü Seçin", constraints,
                      filterProvider.setAccountType),
                  _buildFixedSizeDropdown(
                      "Durum Seçin", constraints, filterProvider.setStatus),
                  _buildFixedSizeField(
                      "Referans", constraints, filterProvider.setReference),
                  _buildFixedSizeField(
                      "Meta No", constraints, filterProvider.setMetaNo),
                  _buildCheckbox("KYC Onaylılar", filterProvider),
                  _buildFixedSizeDropdown(
                      "Tag Seçiniz", constraints, filterProvider.setTag),
                  _buildFixedSizeDropdown("Tarih Tip Seçin", constraints,
                      filterProvider.setDateType),
                  _buildDatePickerField("Başlangıç Tarihi", constraints,
                      () => _selectDate(context, true)),
                  _buildDatePickerField("Bitiş Tarihi", constraints,
                      () => _selectDate(context, false)),
                  _buildFilterButton(context),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFixedSizeField(
      String hint, BoxConstraints constraints, Function(String) onChanged) {
    return SizedBox(
      width: constraints.maxWidth / 4 - 12,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }

  Widget _buildFixedSizeDropdown(
      String hint, BoxConstraints constraints, Function(String?)? onChanged) {
    return SizedBox(
      width: constraints.maxWidth / 4 - 12,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        hint: Text(hint),
        items: [
          "Yeni Atanan",
          "Yanlış Kişi / No",
          "Takipte Kal",
          "Cevapsız",
          "İlgili / Sıcak Takip",
          "Yatırımcı",
          "Kara Liste",
          "İlgilenmiyor",
          "Tekrar Ara",
          "Ulaşılamıyor"
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDatePickerField(
      String hint, BoxConstraints constraints, VoidCallback onTap) {
    return SizedBox(
      width: constraints.maxWidth / 4 - 12,
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Consumer<FilterProvider>(
            builder: (context, provider, child) {
              DateTime? date = hint == "Başlangıç Tarihi"
                  ? provider.startDate
                  : provider.endDate;
              return Text(
                  date != null ? DateFormat('yyyy-MM-dd').format(date) : hint);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, FilterProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: provider.kycApproved,
            onChanged: (value) => provider.toggleKYCApproved()),
        Text(label),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    return SizedBox(
      width: 120,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          filterProvider.applyFilters(); // Filtreleri uygula
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text("Filtrele"),
      ),
    );
  }
}

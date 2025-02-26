import 'package:crm_k/screens/personnel/note_screen/VM/note_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class DateNoteView extends StatelessWidget {
  const DateNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DateNoteVM(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Tarih & Not Seçimi")),
        body: Consumer<DateNoteVM>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                /// **📆 Büyük Takvim**
                _buildDatePicker(viewModel),
                const SizedBox(height: 20),

                /// **📝 Not Alanı**
                _buildNoteSection(viewModel, context),
              ],
            );
          },
        ),
      ),
    );
  }

  /// **📆 `date_picker_plus` ile Büyük Takvim**
  Widget _buildDatePicker(DateNoteVM viewModel) {
    return SizedBox(
      height: 400,
      child: DatePicker(
        minDate: DateTime.now()
            .add(const Duration(days: 1)), // Sadece gelecekteki tarihler
        maxDate: DateTime.now()
            .add(const Duration(days: 365)), // 1 yıl sonrasına kadar
        selectedDate: viewModel.selectedDate,
        onDateSelected: viewModel.selectDate,
      ),
    );
  }

  /// **📝 Not Alanı**
  Widget _buildNoteSection(DateNoteVM viewModel, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **📝 Not Girişi**
            TextField(
              controller: viewModel.noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Bu tarih için not ekleyin...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// **🎨 Renk Seçici**
            _buildColorSelector(viewModel),

            const SizedBox(height: 10),

            /// **💾 Not Kaydetme Butonu**
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  viewModel.saveNote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Not başarıyla kaydedildi!")),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Notu Kaydet"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **🎨 Renk Seçme Butonları**
  Widget _buildColorSelector(DateNoteVM viewModel) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => viewModel.changeColor(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: viewModel.selectedColor == color
                    ? Colors.black
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

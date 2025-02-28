import 'dart:convert';

import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' as lib;

class AdminFunctionLoadDatButton extends StatefulWidget {
  const AdminFunctionLoadDatButton({super.key});

  @override
  State<AdminFunctionLoadDatButton> createState() =>
      _AdminFunctionLoadDatButtonState();
}

class _AdminFunctionLoadDatButtonState
    extends State<AdminFunctionLoadDatButton> {
  int stepNumber = 0;
  final PageController _controller =
      PageController(initialPage: 0, keepPage: true);
  final Duration pageChangedDuration = Duration(milliseconds: 300);
  final Curve curve = Curves.linear;
  //----
  String selectedCompany = "";
  List<PersonnelModel> selectedPersonels = [];
  List<User> selectedUsers = [];

  void nextPage() {
    _controller.nextPage(duration: pageChangedDuration, curve: curve);
    stepNumber += 1;
    setState(() {});
  }

  void previousPage() {
    _controller.previousPage(duration: pageChangedDuration, curve: curve);
    stepNumber -= 1;
    setState(() {});
  }

  void updateSelectedCompany(String company) {
    setState(() {
      selectedCompany = company;
    });
  }

  void updateSelectedPersonnel(List<PersonnelModel> personnelList) {
    setState(() {
      selectedPersonels = personnelList;
    });
  }

  void updateSelectedUsers(List<User> users) {
    setState(() {
      selectedUsers = users;
    });
  }

  void showCustomAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uyarı"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _RowDefaultElement(
                          subValue: selectedCompany,
                          value: '1.Adım ',
                          isCheck: stepNumber > 0),
                      _RowDefaultElement(
                          subValue: selectedPersonels.isEmpty
                              ? ''
                              : 'Seçilen Personel Sayısı \n${selectedPersonels.length.toString()}',
                          value: '2.Adım',
                          isCheck: stepNumber > 1),
                      _RowDefaultElement(
                          subValue: selectedCompany,
                          value: '3.Adım',
                          isCheck: stepNumber > 2),
                      _RowDefaultElement(
                          subValue: selectedCompany,
                          value: '4.Adım',
                          isCheck: stepNumber > 3)
                    ],
                  ),
                )),
            Expanded(
                flex: 6,
                child: PageView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DropdownPage(
                      onCompanySelected: updateSelectedCompany,
                      initialCompany: selectedCompany,
                    ),
                    _PersonnelSelectionScreen(
                        initialSelectedPersonnel: selectedPersonels,
                        onPersonnelSelected: updateSelectedPersonnel),
                    _FileUploadScreen(
                      onUsersConverted: updateSelectedUsers,
                    ),
                    Container(color: Colors.green),
                    Container(color: Colors.red),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    stepNumber != 0
                        ? ElevatedButton(
                            onPressed: () {
                              previousPage();
                            },
                            child: Text('Önceki Adım'))
                        : SizedBox.shrink(),
                    Expanded(child: Center(child: Text(stepNumber.toString()))),
                    stepNumber != 4
                        ? ElevatedButton(
                            onPressed: () {
                              if (stepNumber == 0 && selectedCompany == "") {
                                showCustomAlertDialog(
                                    context, 'Lütfen Firma Seçiniz');
                                return;
                              } else if (stepNumber == 1 &&
                                  selectedPersonels.isEmpty) {
                                showCustomAlertDialog(context,
                                    'Lütfen en az bir personel seçiniz.');
                                return;
                              } else if (stepNumber == 2 &&
                                  selectedUsers.isEmpty) {
                                showCustomAlertDialog(
                                    context, 'Lütfen Verilerinizi İşleyiniz');
                                return;
                              }
                              nextPage();
                            },
                            child: Text('Devam Et'))
                        : SizedBox.shrink()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class _RowDefaultElement extends StatelessWidget {
  const _RowDefaultElement(
      {required this.value, required this.isCheck, required this.subValue});
  final String value;
  final String subValue;
  final bool isCheck;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          isCheck ? Icons.check : Icons.circle_outlined,
          color: Colors.green,
        ),
        SizedBox.square(
          dimension: 5,
        ),
        Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: (isCheck ? TextDecoration.lineThrough : null),
                  fontSize: 20),
            ),
            Text(
              subValue,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: isCheck ? Colors.green : null, fontSize: 15),
            ),
          ],
        )
      ],
    );
  }
}

class DropdownPage extends StatefulWidget {
  final Function(String) onCompanySelected;
  final String? initialCompany; // 📌 Seçili firma

  const DropdownPage(
      {super.key, required this.onCompanySelected, this.initialCompany});

  @override
  _DropdownPageState createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  late String? _selectedCompany;
  final List<String> companyList = [
    "1. Firma",
    "2. Firma"
  ]; // 📌 Mevcut şirketler

  @override
  void initState() {
    super.initState();
    // 📌 Eğer initialCompany, items içinde yoksa `null` yap
    _selectedCompany = companyList.contains(widget.initialCompany)
        ? widget.initialCompany
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: DropdownButtonFormField<String>(
          value: _selectedCompany,
          hint: const Text("Firma Seçin"),
          items: companyList
              .map(
                  (firma) => DropdownMenuItem(value: firma, child: Text(firma)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCompany = value;
            });
            widget.onCompanySelected(value ?? '');
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    );
  }
}

class _PersonnelSelectionScreen extends StatefulWidget {
  //api bağlandıktan sonra companye ait personeller gelecekler yani komple modeller ve model fonksiyonları değişecek
  final Function(List<PersonnelModel>) onPersonnelSelected;
  final List<PersonnelModel>?
      initialSelectedPersonnel; // 📌 Önceden seçili olan personeller

  const _PersonnelSelectionScreen(
      {required this.onPersonnelSelected, this.initialSelectedPersonnel});

  @override
  _PersonnelSelectionScreenState createState() =>
      _PersonnelSelectionScreenState();
}

class _PersonnelSelectionScreenState extends State<_PersonnelSelectionScreen> {
  List<PersonnelModel> allPersonnel = [];
  List<PersonnelModel> selectedPersonnel = [];

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  // 📌 JSON'dan personel verisini yükle
  Future<void> _loadPersonnel() async {
    final String response =
        await rootBundle.loadString('assets/personnel.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      allPersonnel = data.map((json) => PersonnelModel.fromJson(json)).toList();

      // 📌 Eğer daha önce seçili personeller varsa onları ekleyelim
      if (widget.initialSelectedPersonnel != null) {
        selectedPersonnel = List.from(widget.initialSelectedPersonnel!);
      }
    });
  }

  // 📌 Personel seçme/toggle (Sol taraf güncellenmez)
  void _toggleSelection(PersonnelModel personnel) {
    setState(() {
      if (selectedPersonnel.any((p) => p.id == personnel.id)) {
        selectedPersonnel.removeWhere((p) => p.id == personnel.id);
      } else {
        selectedPersonnel.add(personnel);
      }
    });

    widget.onPersonnelSelected(selectedPersonnel); // 📌 Seçimi güncelle
  }

  // 📌 Tüm personelleri seç
  void _selectAllPersonnel() {
    setState(() {
      selectedPersonnel = List.from(allPersonnel);
    });

    widget.onPersonnelSelected(selectedPersonnel); // 📌 Seçimi güncelle
  }

  // 📌 Seçilen personelleri yazdır
  void _printSelectedPersonnel() {
    print("✅ Seçilen Personeller:");
    for (var person in selectedPersonnel) {
      print(person.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 📌 Tüm Personeller Listesi (Sol Tarafta)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _selectAllPersonnel,
                    child: const Text("Tüm Personelleri Seç"),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allPersonnel.length,
                      itemBuilder: (context, index) {
                        final personnel = allPersonnel[index];
                        bool isSelected =
                            selectedPersonnel.any((p) => p.id == personnel.id);

                        return Card(
                          color: isSelected
                              ? Colors.grey.shade300
                              : Colors.white, // 📌 Seçili olan gri olacak
                          child: ListTile(
                            title: Text(personnel.name),
                            subtitle: Text(personnel.email),
                            trailing: IconButton(
                              icon: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons
                                        .add_circle_outline, // 📌 Eğer seçildiyse "check", değilse "add"
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                              onPressed: isSelected
                                  ? null
                                  : () => _toggleSelection(
                                      personnel), // 📌 Eğer zaten seçiliyse buton çalışmayacak
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 📌 Seçilen Personeller Listesi (Sağ Tarafta)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Seçilen Personeller",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: selectedPersonnel.isNotEmpty
                        ? ListView.builder(
                            itemCount: selectedPersonnel.length,
                            itemBuilder: (context, index) {
                              final personnel = selectedPersonnel[index];
                              return Card(
                                color: Colors.green.shade100,
                                child: ListTile(
                                  title: Text(personnel.name),
                                  subtitle: Text(personnel.email),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red),
                                    onPressed: () => _toggleSelection(
                                        personnel), // 📌 Seçileni kaldır
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("Henüz personel seçilmedi.")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _printSelectedPersonnel,
          child: const Text("Seçilenleri Göster"),
        ),
      ),
    );
  }
}

//-----
class _FileUploadScreen extends StatefulWidget {
  const _FileUploadScreen({required this.onUsersConverted});
  final Function(List<User>) onUsersConverted;

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<_FileUploadScreen> {
  List<List<dynamic>> _fileData = [];
  final List<User> _convertedUsers = [];
  String _fileName = "Henüz dosya seçilmedi.";
  bool _isDragging = false;
  bool _isLoading = false; // 📌 Yükleniyor durumu

  // 📌 Dosya Seçme (CSV & XLSX)
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      String? extension = result.files.first.extension;

      if (fileBytes != null) {
        setState(() => _isLoading = true); // 📌 Yükleniyor başlat
        if (extension == "csv") {
          _readCSVFile(fileBytes, fileName);
        } else if (extension == "xlsx") {
          _readExcelFile(fileBytes, fileName);
        }
      }
    }
  }

  // 📌 CSV Dosyasını Oku
  void _readCSVFile(Uint8List bytes, String fileName) {
    final csvString = utf8.decode(bytes);
    List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(csvString);

    setState(() {
      _fileData = csvTable;
      _fileName = fileName;
      _isLoading = false; // 📌 Yükleniyor tamamlandı
    });
  }

  // 📌 XLSX (Excel) Dosyasını Oku
  void _readExcelFile(Uint8List bytes, String fileName) {
    final excel = lib.Excel.decodeBytes(bytes);
    List<List<dynamic>> rows = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        rows.add(row.map((cell) => cell?.value ?? '').toList());
      }
      break; // 📌 İlk tabloyu al
    }

    setState(() {
      _fileData = rows;
      _fileName = fileName;
      _isLoading = false; // 📌 Yükleniyor tamamlandı
    });
  }

  // 📌 Yüklenen Dosyayı Temizle
  void _clearFile() {
    setState(() {
      _fileData = [];
      _fileName = "Henüz dosya seçilmedi.";
      _convertedUsers.clear();
    });
  }

  // 📌 Verileri `User` Modeline Dönüştür
  Future<void> _convertData() async {
    setState(() => _isLoading = true); // 📌 Yükleniyor başlat
    _convertedUsers.clear();

    for (var element in _fileData) {
      List<String> values =
          element.toString().split(',').map((e) => e.trim()).toList();

      try {
        User user = User(
          id: int.tryParse(values[0]),
          name: values[1],
          email: values[2],
          phone: values[3],
          tradeStatus: values[4].toLowerCase() == 'true',
          investmentStatus: values[5].toLowerCase() == 'true',
          investmentAmount: int.tryParse(values[6]) ?? 0,
          assignedTo: values[7],
          callDuration: int.tryParse(values[8]),
          phoneStatus: values[9],
          previousInvestment: values[10].toLowerCase() == 'true',
          expectedInvestmentDate: _parseDate(values[11]),
          createdAt: DateTime.now(),
        );
        print(user.toString());

        _convertedUsers.add(user);
      } catch (e) {
        print("❌ Kullanıcı dönüşüm hatası: $e");
      }
    }

    setState(() => _isLoading = false); // 📌 Yükleniyor tamamlandı
    widget.onUsersConverted(_convertedUsers);
  }

  // 📌 Tarih dönüşümü için yardımcı fonksiyon
  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    return DateTime.tryParse(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 📌 Dosya Yükleme Alanı
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _pickFile,
                onPanStart: (_) => setState(() => _isDragging = true),
                onPanCancel: () => setState(() => _isDragging = false),
                child: Container(
                  width: 400,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    color: _isDragging
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _isDragging
                          ? "Dosyayı bırakın!"
                          : "CSV veya XLSX dosyanızı buraya sürükleyin\nyada tıklayın.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 📌 Seçili Dosya Adı
            Text(
              "Seçili Dosya: $_fileName",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 📌 Dosya Temizleme Butonu
            if (_fileData.isNotEmpty)
              ElevatedButton(
                onPressed: _clearFile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Dosyayı Temizle"),
              ),

            const SizedBox(height: 20),

            // 📌 **Loading Animasyonu**
            if (_isLoading)
              const CircularProgressIndicator() // 📌 Dosya yüklenirken göster
            else
              ElevatedButton(
                onPressed: _convertData, // 📌 Verileri dönüştür
                child: const Text("Verileri İşle"),
              ),

            const SizedBox(height: 20),

            // 📌 Dosya İçeriğini Göster
            Expanded(
              child: _convertedUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _convertedUsers.length,
                      itemBuilder: (context, index) {
                        User user = _convertedUsers[index];
                        if (index == 0) {
                          return Divider();
                        }

                        return Card(
                          child: ListTile(
                            leading: Text(index.toString()),
                            title: Text(
                                "${user.name} (${user.email})"), // 📌 Ad ve Email
                            subtitle: Text(
                              "Telefon: ${user.phone ?? 'Yok'} | "
                              "Durum: ${user.phoneStatus ?? 'Bilinmiyor'} | "
                              "Yatırım: ${user.investmentAmount} | "
                              "Atanan: ${user.assignedTo ?? 'Atama Yok'}",
                            ),
                          ),
                        );
                      },
                    )
                  : const Text("Henüz dosya yüklenmedi."),
            ),
          ],
        ),
      ),
    );
  }
}

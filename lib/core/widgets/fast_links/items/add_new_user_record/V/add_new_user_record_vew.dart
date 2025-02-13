import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({
    super.key,
  });

  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();

  // **Zorunlu Alanlar**
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // **Opsiyonel Alanlar**
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _investmentAmountController =
      TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _phoneStatusController = TextEditingController();

  bool _tradeStatus = false;
  bool _investmentStatus = false;
  bool _previousInvestment = false;
  DateTime? _expectedInvestmentDate;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newUser = {
        "name": _nameController.text,
        "email": _emailController.text,
        "phone":
            _phoneController.text.isNotEmpty ? _phoneController.text : null,
        "trade_status": _tradeStatus,
        "investment_status": _investmentStatus,
        "investment_amount": _investmentAmountController.text.isNotEmpty
            ? double.tryParse(_investmentAmountController.text) ?? 0
            : 0,
        "assigned_to": _assignedToController.text.isNotEmpty
            ? _assignedToController.text
            : null,
        "phone_status": _phoneStatusController.text.isNotEmpty
            ? _phoneStatusController.text
            : "Bilinmiyor",
        "previous_investment": _previousInvestment,
        "expected_investment_date": _expectedInvestmentDate != null
            ? DateFormat('yyyy-MM-dd').format(_expectedInvestmentDate!)
            : null,
        "created_at": DateTime.now().toIso8601String(),
      };

      print(newUser);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _expectedInvestmentDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Yeni Kullanıcı Ekle",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),
                  _buildTextField(
                      _nameController, "Ad Soyad", Icons.person, true),
                  _buildTextField(
                      _emailController, "E-posta", Icons.email, true),

                  _buildTextField(_phoneController, "Telefon (Opsiyonel)",
                      Icons.phone, false),
                  _buildTextField(_investmentAmountController,
                      "Yatırım Tutarı (₺)", Icons.attach_money, false),
                  _buildTextField(_assignedToController, "Atanan Temsilci",
                      Icons.account_box, false),
                  _buildTextField(_phoneStatusController, "Telefon Durumu",
                      Icons.phone_enabled, false),

                  const SizedBox(height: 10),

                  // **Boolean Alanlar**
                  _buildSwitchTile("Ticaret Durumu", _tradeStatus, (val) {
                    setState(() => _tradeStatus = val);
                  }),
                  _buildSwitchTile("Yatırım Durumu", _investmentStatus, (val) {
                    setState(() => _investmentStatus = val);
                  }),
                  _buildSwitchTile("Önceki Yatırım", _previousInvestment,
                      (val) {
                    setState(() => _previousInvestment = val);
                  }),

                  // **Tarih Seçimi**
                  ListTile(
                    title: const Text("Beklenen Yatırım Tarihi"),
                    subtitle: Text(_expectedInvestmentDate != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(_expectedInvestmentDate!)
                        : "Seçilmedi"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _pickDate(context),
                  ),

                  const SizedBox(height: 20),

                  // **Buton**
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.add),
                    label: const Text("Kullanıcı Ekle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool required,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return "Bu alan zorunludur!";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }
}

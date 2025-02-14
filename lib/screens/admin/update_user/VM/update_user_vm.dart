import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserDialog extends StatefulWidget {
  final User user;
  final VoidCallback onUpdate;

  const UpdateUserDialog(
      {super.key, required this.user, required this.onUpdate});

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _investmentAmountController;
  String? _assignedTo;
  bool? _tradeStatus;
  bool? _investmentStatus;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone ?? "");
    _investmentAmountController = TextEditingController(
        text: widget.user.investmentAmount?.toString() ?? "0");
    _assignedTo = widget.user.assignedTo ?? "";
    _tradeStatus = widget.user.tradeStatus ?? false;
    _investmentStatus = widget.user.investmentStatus ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Kullanıcı Güncelle"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, "Ad Soyad", Icons.person),
            _buildTextField(_phoneController, "Telefon", Icons.phone),
            _buildTextField(
                _investmentAmountController, "Yatırım Tutarı", Icons.money,
                isNumber: true),
            SwitchListTile(
              title: const Text("Ticaret Durumu"),
              value: _tradeStatus ?? false,
              onChanged: (value) => setState(() => _tradeStatus = value),
            ),
            SwitchListTile(
              title: const Text("Yatırım Durumu"),
              value: _investmentStatus ?? false,
              onChanged: (value) => setState(() => _investmentStatus = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal")),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateUser,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("Kaydet"),
        ),
      ],
    );
  }

  void _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedUser = User(
      id: widget.user.id,
      name: _nameController.text.trim(),
      email: widget.user.email,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      tradeStatus: _tradeStatus,
      investmentStatus: _investmentStatus,
      investmentAmount:
          int.tryParse(_investmentAmountController.text.trim()) ?? 0,
      assignedTo: _assignedTo,
      createdAt: widget.user.createdAt,
    );

    try {
      await Provider.of<UserManager>(context, listen: false)
          .updateUser(updatedUser);
      widget.onUpdate();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Hata oluştu: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(icon),
        ),
        validator: (value) => value!.isEmpty ? "$label boş bırakılamaz" : null,
      ),
    );
  }
}

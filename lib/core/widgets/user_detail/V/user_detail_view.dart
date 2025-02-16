import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/appointment_section.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/contact_actions.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/notes_timeline.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/tag_manager.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/user_info_card.dart';
import 'package:flutter/material.dart';

class UserDetailWidget extends StatelessWidget {
  final User user;

  const UserDetailWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 900, // Genişliği sabitledik, ihtiyaca göre değiştirilebilir.
        child: Scaffold(
          appBar: AppBar(
            title: Text('Müşteri Detay Ekranı'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RowElementD(data: 'Fonlama'),
                  RowElementD(data: 'KYC Onay'),
                  RowElementD(data: 'Uzman Ataması'),
                  RowElementD(data: 'Temsilci Değişikliği')
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                  child: Row(
                children: [
                  //left
                  Expanded(
                      child: Column(
                    children: [
                      UserInfoCard(user: user),
                      const SizedBox(height: 12),
                      TagManager(user: user),
                      ContactActions(user: user),
                      const SizedBox(height: 12),
                    ],
                  )),
                  //right
                  Expanded(
                      child: Column(
                    children: [
                      AppointmentSection(user: user),
                      const SizedBox(height: 12),
                      NotesTimeline(user: user),
                    ],
                  ))
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class RowElementD extends StatefulWidget {
  const RowElementD({super.key, required this.data});
  final String data;

  @override
  State<RowElementD> createState() => _RowElementDState();
}

class _RowElementDState extends State<RowElementD> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blue,
          )),
      child: Row(
        children: [
          Text(
            widget.data,
            style: TextStyle(color: Colors.blue),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                isActive = !isActive;
              });
            },
            icon: isActive
                ? Icon(
                    Icons.done,
                    color: Colors.green,
                  )
                : Icon(Icons.circle_outlined, color: Colors.blue),
          )
        ],
      ),
    );
  }
}

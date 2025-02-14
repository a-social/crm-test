import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelMainContent extends StatelessWidget {
  const PersonelMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final personel = Provider.of<PersonnelProvider>(context).personel;
    if (personel == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/404',
        (route) => false,
      );
      return SizedBox();
    } else {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Column(
              children: [
                Text("Hoşgeldin ${personel.name}",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: Card(
                    child: Row(
                      children: [
                        // 📌 Solda StatBox'ları içeren genişleyebilir bir alan
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: StatBox(
                                          title: "Gerçek Müşteri",
                                          value: "18",
                                          subValue: "")),
                                  Expanded(
                                      child: StatBox(
                                          title: "Arama Süresi",
                                          value: "1:42",
                                          subValue: "")),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: StatBox(
                                          title: "Havuz",
                                          value: "48",
                                          subValue: "%8")),
                                  Expanded(
                                      child: StatBox(
                                          title: "Yeni Başvurular",
                                          value: "15",
                                          subValue: "+12%")),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Placeholder for graph
                              Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(children: [
                                        Expanded(child: SizedBox.shrink()),
                                        SizedBox(height: 15),
                                        Expanded(child: SizedBox.shrink()),
                                      ]))),
                            ],
                          ),
                        ),

                        // 📌 Sağda Kullanıcı Listesi (Esnek Genişlik)
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(
              width: 30,
            ),
            Expanded(
                child: Column(
              children: [
                const Text("Son Değişiklikler",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Expanded(
                    child: Column(
                  children: [
                    Flexible(flex: 2, child: UserListScreenView()),
                    SizedBox.square(dimension: 5),
                    Flexible(child: SizedBox.shrink()),
                  ],
                ))
              ],
            )),
          ]));
    }
  }
}

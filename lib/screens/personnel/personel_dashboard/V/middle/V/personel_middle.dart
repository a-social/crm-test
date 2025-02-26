import 'package:crm_k/core/service/auth_provider.dart';
import 'package:crm_k/screens/404/V/404.dart';
import 'package:crm_k/screens/admin/dashboard/V/middle/graphics_view.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/middle/V/list_user_for_personel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelMainContent extends StatelessWidget {
  const PersonelMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isPersonel = Provider.of<AuthProvider>(context).isPersonnel;

    // 📌 Eğer personel bilgisi yoksa 404 sayfasına yönlendir
    if (!isPersonel) {
      return const PageNotFoundScreen();
    } else {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            // Expanded(
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //               child: StatBox(
            //                   title: "Havuz", value: "48", subValue: "%8")),
            //           Expanded(
            //               child: StatBox(
            //                   title: "Yeni Başvurular",
            //                   value: "15",
            //                   subValue: "+12%")),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //               child: StatBox(
            //                   title: "Gerçek Müşteri",
            //                   value: "18",
            //                   subValue: "")),
            //           Expanded(
            //               child: StatBox(
            //                   title: "Benim Müşterilerim",
            //                   value: "186",
            //                   subValue: "",
            //                   widget: MyCustomersView())),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: SizedBox(
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             Expanded(
            //                 child: StatBox(
            //                     title: "Gerçek Müşteri",
            //                     value: "18",
            //                     subValue: "")),
            //             Expanded(
            //                 child: StatBox(
            //                     title: "Arama Süresi",
            //                     value: "1:42",
            //                     subValue: "")),
            //           ],
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //                 child: StatBox(
            //                     title: "Havuz", value: "48", subValue: "%8")),
            //             Expanded(
            //                 child: StatBox(
            //                     title: "Yeni Başvurular",
            //                     value: "15",
            //                     subValue: "+12%")),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Expanded(
            //     child: Column(
            //   children: [
            //     Text("Hoşgeldin ${personel.name}",
            //         style:
            //             TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            //     const SizedBox(height: 10),
            //     Expanded(
            //       child: Card(
            //         child: Row(
            //           children: [
            //             // 📌 Solda StatBox'ları içeren genişleyebilir bir alan
            //             Expanded(
            //               child: Column(
            //                 children: [
            //                   const SizedBox(height: 20),

            //                   // Placeholder for graph
            //                   Flexible(
            //                       child: Padding(
            //                           padding: EdgeInsets.all(15),
            //                           child: Column(children: [
            //                             Expanded(child: SizedBox.shrink()),
            //                             SizedBox(height: 15),
            //                             Expanded(child: SizedBox.shrink()),
            //                           ]))),
            //                 ],
            //               ),
            //             ),

            //             // 📌 Sağda Kullanıcı Listesi (Esnek Genişlik)
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // )),

            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Atanan Müşterilerim",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Expanded(
                        child: Column(
                      children: [
                        Flexible(
                            flex: 10, child: PersonelsUserListScreenView()),
                      ],
                    ))
                  ],
                )),
            Expanded(child: BarChartScreen()),
          ]));
    }
  }
}

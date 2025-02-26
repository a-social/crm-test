import 'package:crm_k/screens/admin/add_company/V/add_company_view.dart';
import 'package:crm_k/screens/admin/add_person/V/admin_add_person.dart';
import 'package:crm_k/screens/admin/add_user/V/add_user.dart';
import 'package:crm_k/screens/admin/add_user_from_export/V/add_user_from_export.dart';
import 'package:crm_k/screens/admin/auto_user_load/V/auto_user_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/admin/delete_company/V/delete_company.dart';
import 'package:crm_k/screens/admin/delete_person/V/delete_person.dart';
import 'package:crm_k/screens/admin/delete_user/V/delete_user.dart';
import 'package:crm_k/screens/admin/hot_data/V/hot_data_view.dart';
import 'package:crm_k/screens/admin/show_companies/V/show_companies_view.dart';
import 'package:crm_k/screens/admin/update_person/V/update_person_view.dart';
import 'package:flutter/material.dart';

class DynamicDrawerVMAdmin {
  static final List<Map<String, dynamic>> menuItems = [
    {"title": "Ana Sayfa", "icon": Icons.dashboard, "page": DashboardScreen()},
    {
      "title": "Personel İşlemleri",
      "icon": Icons.group,
      "submenu": [
        {
          "title": "Personel Ekle",
          "icon": Icons.person_add,
          "page": PersonnelAddScreen()
        },
        {
          "title": "Personel Düzenle",
          "icon": Icons.edit,
          "page": PersonelUpdateView()
        },
        {"title": "Personel Sil", "icon": Icons.delete, "page": DeletePerson()},
        {
          "title": "Otomatik Müşteri Atama",
          "icon": Icons.auto_awesome,
          "page": AdminFunctionLoadDatButton()
        },
        {
          "title": "Veri Seti Ekle",
          "icon": Icons.file_upload_outlined,
          "page": UploadUserScreen()
        },
      ]
    },
    {
      "title": "Müşteri İşlemleri",
      "icon": Icons.people,
      "submenu": [
        {
          "title": "Müşteri Ekle",
          "icon": Icons.person_add,
          "page": UserAddScreen()
        },
        {"title": "Müşteri Düzenle", "icon": Icons.edit, "page": DeleteUser()},
        {
          "title": "Müşteri Sil",
          "icon": Icons.person_off,
          "page": DeleteUser()
        },
      ]
    },
    {
      "title": "Raporlar",
      "icon": Icons.bar_chart,
      "page": PersonnelAddScreen()
    },
    {
      "title": "Firma İşlemleri",
      "icon": Icons.group,
      "submenu": [
        {"title": "Firma Ekle", "icon": Icons.person_add, "page": AddCompany()},
        {
          "title": "Firma Düzenle",
          "icon": Icons.edit,
          "page": PersonelUpdateView()
        },
        {
          "title": "Firma Sil",
          "icon": Icons.delete,
          "page": DeleteCompanyView()
        },
        {
          "title": "Firma Görüntüle",
          "icon": Icons.auto_awesome,
          "page": CompanyListView()
        },
      ]
    },
    {"title": "Çıkış Yap", "icon": Icons.logout, "page": DashboardScreen()},
  ];
}

import 'package:crm_k/core/icons/unit_icons.dart';
import 'package:crm_k/core/lang/unit_strings.dart';
import 'package:crm_k/core/widgets/fast_links/items/add_new_user_record/V/add_new_user_record_vew.dart';
import 'package:flutter/material.dart';

import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';

class FastLinkMenuITems {
  static final Map<String, Map<Icon, Widget>> menuItems = {
    // Yeni Yatırım Modülü Eylemleri
    UnitStrings.fastButtonAddInvestor: {
      UnitIcons.fastButtonAddInvestor: AddUserForm()
    },
    UnitStrings.fastButtonSendInvestmentProposal: {
      UnitIcons.fastButtonSendInvestmentProposal: DashboardScreen()
    },
    UnitStrings.fastButtonPortfolioAnalysis: {
      UnitIcons.fastButtonPortfolioAnalysis: DashboardScreen()
    },
    UnitStrings.fastButtonRiskAnalysis: {
      UnitIcons.fastButtonRiskAnalysis: DashboardScreen()
    },
    UnitStrings.fastButtonStartInvestment: {
      UnitIcons.fastButtonStartInvestment: DashboardScreen()
    },
    UnitStrings.fastButtonContractManagement: {
      UnitIcons.fastButtonContractManagement: DashboardScreen()
    },
    UnitStrings.fastButtonInvestmentMeeting: {
      UnitIcons.fastButtonInvestmentMeeting: DashboardScreen()
    },
    UnitStrings.fastButtonFundTransfer: {
      UnitIcons.fastButtonFundTransfer: DashboardScreen()
    },
    UnitStrings.fastButtonMarketAnalysis: {
      UnitIcons.fastButtonMarketAnalysis: DashboardScreen()
    },

    // Yeni Modüller
    //ileride eklenecekler yada eklenebilir işemler
    UnitStrings.riskManagementSystem: {
      UnitIcons.riskManagementSystem: DashboardScreen()
    },
    UnitStrings.marketChartModule: {
      UnitIcons.marketChartModule: DashboardScreen()
    },
    UnitStrings.customerEducationModule: {
      UnitIcons.customerEducationModule: DashboardScreen()
    },
    UnitStrings.investmentStrategyModule: {
      UnitIcons.investmentStrategyModule: DashboardScreen()
    },
  };
  static void showAddUserDialog(BuildContext context, Widget widget) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Dışına tıklayınca kapanabilir
      barrierLabel: "UserDialog",
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: animation, // Açılış animasyonu için büyütme efekti
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.sizeOf(context).width / 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 📌 Kullanıcı Ekleme Formu
                    widget,

                    // 📌 Kapatma Butonu
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

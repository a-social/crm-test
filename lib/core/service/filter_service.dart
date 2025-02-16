import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String? crmNumber;
  String? searchQuery;
  String? accountType;
  String? status;
  String? reference;
  String? metaNo;
  bool kycApproved = false;
  String? tag;
  String? dateType;
  DateTime? startDate;
  DateTime? endDate;

  void setCRMNumber(String value) {
    crmNumber = value;
  }

  void setSearchQuery(String value) {
    searchQuery = value;
  }

  void setAccountType(String? value) {
    accountType = value;
  }

  void setStatus(String? value) {
    status = value;
  }

  void setReference(String value) {
    reference = value;
  }

  void setMetaNo(String value) {
    metaNo = value;
  }

  void setTag(String? value) {
    tag = value;
  }

  void setDateType(String? value) {
    dateType = value;
  }

  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  void toggleKYCApproved() {
    kycApproved = !kycApproved;
  }

  void applyFilters() {
    notifyListeners();
  }

  void resetFilters() {
    crmNumber = null;
    searchQuery = null;
    accountType = null;
    status = null;
    reference = null;
    metaNo = null;
    kycApproved = false;
    tag = null;
    dateType = null;
    startDate = null;
    endDate = null;
    notifyListeners();
  }
}

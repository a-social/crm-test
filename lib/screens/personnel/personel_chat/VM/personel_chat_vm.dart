import 'package:crm_k/core/models/chat_model/chat_model.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatChannel> _channels = [
    ChatChannel(
        id: "1",
        name: "Ahmet Yılmaz",
        lastMessage: "Nasılsın?",
        lastUpdated: DateTime.now().subtract(Duration(minutes: 5))),
    ChatChannel(
        id: "2",
        name: "Zeynep Kaya",
        lastMessage: "Bugün toplantı var mı?",
        lastUpdated: DateTime.now().subtract(Duration(minutes: 15))),
    ChatChannel(
        id: "3",
        name: "Sistem",
        lastMessage: "Sistem mesajı örneği.",
        lastUpdated: DateTime.now().subtract(Duration(minutes: 30))),
  ];

  final Map<String, List<ChatMessage>> _messages = {
    "1": [
      ChatMessage(
          sender: "Ahmet Yılmaz",
          message: "Merhaba!",
          timestamp: DateTime.now().subtract(Duration(minutes: 10))),
      ChatMessage(
          sender: "Ben",
          message: "Nasılsın?",
          timestamp: DateTime.now().subtract(Duration(minutes: 5))),
    ],
    "2": [
      ChatMessage(
          sender: "Zeynep Kaya",
          message: "Bugün toplantı var mı?",
          timestamp: DateTime.now().subtract(Duration(minutes: 15))),
      ChatMessage(
          sender: "Ben",
          message: "Evet, saat 14:00'te toplantımız var.",
          timestamp: DateTime.now().subtract(Duration(minutes: 10))),
    ],
    "3": [
      ChatMessage(
          sender: "Sistem",
          message: "Bu bir sistem mesajıdır.",
          timestamp: DateTime.now().subtract(Duration(minutes: 30))),
    ],
  };

  String? _selectedChannelId;

  List<ChatChannel> get channels => _channels;
  List<ChatMessage> get messages =>
      _selectedChannelId != null ? _messages[_selectedChannelId] ?? [] : [];
  String? get selectedChannelId => _selectedChannelId;

  void selectChannel(String channelId) {
    _selectedChannelId = channelId;
    notifyListeners(); // UI'yi güncelle
  }

  void sendMessage(String sender, String message) {
    if (_selectedChannelId == null) return;

    _messages[_selectedChannelId]!.add(
      ChatMessage(sender: sender, message: message, timestamp: DateTime.now()),
    );
    notifyListeners();
  }
}

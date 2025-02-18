import 'package:crm_k/screens/personnel/personel_chat/VM/personel_chat_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelChat extends StatelessWidget {
  const PersonelChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: ChatChannelList()),
          Expanded(flex: 3, child: ChatMessages()),
        ],
      ),
    );
  }
}

class ChatChannelList extends StatelessWidget {
  const ChatChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: chatViewModel.channels.length,
        itemBuilder: (context, index) {
          final channel = chatViewModel.channels[index];
          bool isSelected = chatViewModel.selectedChannelId == channel.id;

          return GestureDetector(
            onTap: () {
              chatViewModel
                  .selectChannel(channel.id); // Sohbet seçildiğinde güncelle
            },
            child: Container(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  Text(
                    channel.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus(); // TextField ilk açıldığında aktif olsun
  }

  void _sendMessage(ChatViewModel chatViewModel) {
    if (_controller.text.trim().isEmpty) return;

    chatViewModel.sendMessage("Ben", _controller.text.trim());
    _controller.clear();

    // Yeni mesaj eklenince otomatik en alta kaydır
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final messages = chatViewModel.messages;

    return Column(
      children: [
        // Mesajlar Listesi
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              bool isMe = message.sender == "Ben";

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 300, // Maksimum genişlik 300px olacak
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[300] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${message.timestamp.hour}:${message.timestamp.minute}",
                          style: TextStyle(
                              fontSize: 12,
                              color: isMe ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Mesaj Gönderme Alanı
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode, // Sürekli aktif olacak
                  decoration: InputDecoration(
                    hintText: "Mesajınızı yazın...",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onSubmitted: (_) => _sendMessage(chatViewModel),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: () => _sendMessage(chatViewModel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  final String openAIKey = "YOUR_OPENAI_API_KEY"; // Replace with your key

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"sender": "user", "message": userMessage});
    });

    var url = Uri.parse("https://api.openai.com/v1/chat/completions");
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $openAIKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful chatbot."},
          {"role": "user", "content": userMessage}
        ],
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String botReply = data['choices'][0]['message']['content'];

      setState(() {
        messages.add({"sender": "bot", "message": botReply});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: messages[index]["sender"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: messages[index]["sender"] == "user"
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]["message"]!,
                      style: TextStyle(
                          color: messages[index]["sender"] == "user"
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

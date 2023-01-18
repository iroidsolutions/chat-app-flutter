class ChatRoom {
  String? chatId;
  Map<String, dynamic>? participants;
  String? lastMsg;

  ChatRoom({this.chatId, this.participants, this.lastMsg});

  ChatRoom.fromMap(Map<String, dynamic> map) {
    chatId = map['chatId'];
    participants = map['participants'];
    lastMsg = map['lastMsg'];
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMsg': lastMsg,
    };
  }
}

class ChatRoom {
  String? chatId;
  Map<String, dynamic>? participants;
  String? lastMsg;
  DateTime? createdon;

  ChatRoom({this.chatId, this.participants, this.lastMsg, this.createdon});

  ChatRoom.fromMap(Map<String, dynamic> map) {
    chatId = map['chatId'];
    participants = map['participants'];
    lastMsg = map['lastMsg'];
    createdon = map['createdon'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMsg': lastMsg,
      'createdon': createdon,
    };
  }
}

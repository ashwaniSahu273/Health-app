class MessageModel{
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.sender,this.text,this.seen,this.createdon, required messageid});

  MessageModel.frommap(Map<String, dynamic> map){
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdon = map['createdon'].toDate();
  }

  String? get messageid => null;

  Map<String, dynamic> tomap(){
    return {
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdon': createdon
    };
  }

}
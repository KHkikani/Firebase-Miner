import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  String note;
  DateTime time;

  Note({required this.title, required this.note, required this.time});

  factory Note.fromMap({required Map data}) {
    Timestamp time = data['time'] as Timestamp;
    DateTime dateTime = DateTime.parse(time.toDate().toString());
    return Note(
      title: data['title'],
      note: data['note'],
      time: dateTime,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFireStoreHelper {
  CloudFireStoreHelper._();

  static final CloudFireStoreHelper cloudFireStoreHelper =
      CloudFireStoreHelper._();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Todo : insert

  Future<void> addNote({required Map<String, dynamic> data}) async {
    await fireStore.collection("Notes").add(data);
  }

  Future<void> updateNote(
      {required String id, required Map<String, dynamic> data}) async {
    await fireStore.collection("Notes").doc(id).set(data);
  }

  Future<void> deleteNote(
      {required String id}) async {
    await fireStore.collection("Notes").doc(id).delete();
  }
}

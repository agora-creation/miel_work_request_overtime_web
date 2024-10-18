import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_request_overtime_web/models/request_overtime.dart';

class RequestOvertimeService {
  String collection = 'requestOvertime';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  Future<RequestOvertimeModel?> selectData(String id) async {
    RequestOvertimeModel? ret;
    await firestore.collection(collection).doc(id).get().then((value) {
      ret = RequestOvertimeModel.fromSnapshot(value);
    });
    return ret;
  }
}

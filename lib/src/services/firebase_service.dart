import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get courses => _db.collection('courses');
  CollectionReference get users => _db.collection('users');
  CollectionReference get announcements => _db.collection('announcements');
}

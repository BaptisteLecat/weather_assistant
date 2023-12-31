import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherjourney/src/features/locations/domain/location/location.dart';
import 'package:weatherjourney/src/features/locations/domain/parameters/user_id_location_id_parameter.dart/user_id_location_id_parameter.dart';
import 'package:weatherjourney/src/features/locations/domain/parameters/user_id_location_parameter/user_id_location_parameter.dart';
import 'package:weatherjourney/src/features/weather/domain/generation/generation.dart';

class LocationFirestoreRepository {
  static String ressource = 'users';
  static String subRessource = 'locations';
  FirebaseFirestore firestore;

  LocationFirestoreRepository({FirebaseFirestore? firestore})
      : firestore =
            (firestore != null) ? firestore : FirebaseFirestore.instance;

  CollectionReference<Location> fetchAllByCustomFilter({
    required String docId,
  }) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return reference;
  }

  Future<List<Location>> fetchAllForOne({
    required String docId,
  }) async {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return await reference.get().then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Location>> fetchAllForOneWithStream({
    required String docId,
  }) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return reference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Location>> fetchAllForOneOrderByCreatedAtWithStream({
    required String docId,
  }) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .orderBy('createdAt', descending: true)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return reference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future fetchOne({
    required String docId,
    required String subDocId,
  }) async {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return await reference.doc(subDocId).get().then((snapshot) {
      return snapshot.data();
    });
  }

  Stream<Location> fetchOneWithStream(
      {required String docId, required String subDocId}) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .doc(subDocId)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return reference.snapshots().map((snapshot) {
      return snapshot.data()!;
    });
  }

  Future<Location> insert({
    required String docId,
    required Location entity,
  }) async {
    final id = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .doc()
        .id;
    entity = entity.copyWith(id: id);
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return await reference.doc(entity.id).set(entity).then((_) {
      return entity;
    });
  }

  Future remove({
    required String docId,
    required String subDocId,
  }) async {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return await reference.doc(subDocId).delete().then((_) {
      return true;
    });
  }

  Future<Location> update({
    required String docId,
    required Location entity,
  }) async {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return await reference
        .doc(entity.id.toString())
        .update(entity.toJson())
        .then((_) {
      return entity;
    });
  }

  CollectionReference<Location> fetchAllForOneByCustomFilter({
    required String docId,
  }) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .withConverter<Location>(
          fromFirestore: (snapshot, _) => Location.fromJson(snapshot.data()!),
          toFirestore: (location, _) => location.toJson(),
        );
    return reference;
  }

  Stream<Generation?> fetchLastGenerationForLocationWithStream({
    required String docId,
    required String subDocId,
  }) {
    final reference = firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .doc(subDocId)
        .collection('generations')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .withConverter<Generation>(
          fromFirestore: (snapshot, _) => Generation.fromJson(snapshot.data()!),
          toFirestore: (generation, _) => generation.toJson(),
        );
    return reference.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.map((doc) => doc.data()).first;
    });
  }

  Future<void> deleteLocation({
    required String docId,
    required String subDocId,
  }) async {
    await firestore
        .collection(ressource)
        .doc(docId)
        .collection(subRessource)
        .doc(subDocId)
        .delete();
  }
}

final locationFirestoreRepositoryProvider =
    Provider<LocationFirestoreRepository>((ref) {
  return LocationFirestoreRepository();
});

final locationsListFutureProvider =
    FutureProvider.autoDispose.family<List<Location>, String>(
  (ref, docId) {
    final locationRepository = ref.watch(locationFirestoreRepositoryProvider);
    return locationRepository.fetchAllForOne(docId: docId);
  },
);

final locationsListStreamProvider =
    StreamProvider.autoDispose.family<List<Location>, String>((ref, docId) {
  final locationRepository = ref.watch(locationFirestoreRepositoryProvider);
  return locationRepository.fetchAllForOneWithStream(docId: docId);
});

final locationByIdStreamProvider = StreamProvider.autoDispose
    .family<Location, UserIdLocationIdParameter>(
        (ref, useruidLocationParameter) {
  final locationRepository = ref.watch(locationFirestoreRepositoryProvider);
  return locationRepository.fetchOneWithStream(
    docId: useruidLocationParameter.userId,
    subDocId: useruidLocationParameter.locationId,
  );
});

final lastGenerationForLocationStreamProvider = StreamProvider.autoDispose
    .family<Generation?, UserIdLocationParameter>(
        (ref, userUidLocationParameter) {
  final locationRepository = ref.watch(locationFirestoreRepositoryProvider);
  return locationRepository.fetchLastGenerationForLocationWithStream(
    docId: userUidLocationParameter.uid,
    subDocId: userUidLocationParameter.location.id!,
  );
});

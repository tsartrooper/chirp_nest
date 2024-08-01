import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowersNotifier extends StateNotifier<List<String>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FollowersNotifier() : super([]) {
    _initializeFollowers();
  }

  Future<void> _initializeFollowers() async {
    try {
      final currentUserId = _auth.currentUser!.uid;
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final List<String> followers = List<String>.from(data?['followers'] ?? []);
        state = followers;
      }
    } catch (e) {
      print('Error initializing followers: $e');
      // Optionally, handle error state here if needed.
    }
  }

  Future<void> addFollower(String followerId) async {
    final currentUserId = _auth.currentUser!.uid;

    try {
      // Update Firestore with the new follower
      await _firestore.collection('users').doc(currentUserId).update({
        'followers': FieldValue.arrayUnion([followerId]),
      });

      // Update the state locally
      state = [...state, followerId];
    } catch (e) {
      print('Error adding follower: $e');
      // Optionally, handle error state here if needed.
    }
  }

  Future<void> removeFollower(String followerId) async {
    final currentUserId = _auth.currentUser!.uid;

    try {
      // Update Firestore to remove the follower
      await _firestore.collection('users').doc(currentUserId).update({
        'followers': FieldValue.arrayRemove([followerId]),
      });

      // Update the state locally
      state = state.where((id) => id != followerId).toList();
    } catch (e) {
      print('Error removing follower: $e');
      // Optionally, handle error state here if needed.
    }
  }
}

final followersProvider = StateNotifierProvider<FollowersNotifier, List<String>>(
      (ref) => FollowersNotifier(),
);
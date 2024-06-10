import 'package:easycook/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class ResepModel extends ChangeNotifier {
  Map<String, int> likes = {};
  Map<String, bool> likedByCurrentUser = {};

  Future<void> initData(String resepId) async {
    try {
      final likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      likes[resepId] = likesAndBookmarks['likes'] ?? 0;

      String? userId = await getUserId();
      if (userId != null) {
        List<String> likedUserIds =
            List<String>.from(likesAndBookmarks['liked_user_ids'] ?? []);
        likedByCurrentUser[resepId] = likedUserIds.contains(userId);
      } else {
        likedByCurrentUser[resepId] = false;
      }

      notifyListeners();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<String?> getUserId() async {
    FirebaseAuth.User? user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> likeResep(String resepId, String userId) async {
    try {
      Map<String, dynamic> likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      int currentLikes = likesAndBookmarks['likes'] ?? 0;
      List<String> likedUserIds =
          List<String>.from(likesAndBookmarks['liked_user_ids'] ?? []);

      if (!likedUserIds.contains(userId)) {
        likes[resepId] = currentLikes + 1;
        likedUserIds.add(userId);
        likedByCurrentUser[resepId] = true;

        // Add logic to update liked recipes collection in Firebase
        await FirebaseService().addLikedRecipe(resepId,
            userId); // Method to add liked recipe in Firebase users collection
      }

      await FirebaseService().updateLikesAndBookmarks(resepId, likes[resepId]!,
          likedUserIds.contains(userId), likedUserIds);
      notifyListeners();
    } catch (e) {
      print('Error liking recipe: $e');
      throw Exception('Failed to like recipe');
    }
  }

  Future<void> unlikeResep(String resepId, String userId) async {
    try {
      Map<String, dynamic> likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      int currentLikes = likesAndBookmarks['likes'] ?? 0;
      List<String> likedUserIds =
          List<String>.from(likesAndBookmarks['liked_user_ids'] ?? []);

      if (likedUserIds.contains(userId)) {
        likes[resepId] = currentLikes - 1;
        likedUserIds.remove(userId);
        likedByCurrentUser[resepId] = false;

        // Add logic to remove liked recipe from collection in Firebase
        await FirebaseService().removeLikedRecipe(resepId,
            userId); // Method to remove liked recipe from Firebase users collection
      }

      await FirebaseService().updateLikesAndBookmarks(resepId, likes[resepId]!,
          likedUserIds.contains(userId), likedUserIds);
      notifyListeners();
    } catch (e) {
      print('Error unliking recipe: $e');
      throw Exception('Failed to unlike recipe');
    }
  }

  bool isLikedByCurrentUser(String resepId) {
    return likedByCurrentUser[resepId] ?? false;
  }
}

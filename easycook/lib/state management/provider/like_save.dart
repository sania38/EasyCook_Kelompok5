import 'package:easycook/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ResepModel extends ChangeNotifier {
  Map<String, int> likes = {};
  Map<String, bool> likedByCurrentUser = {};
  Map<String, bool> bookmarks = {};

  void initData(String resepId) async {
    try {
      final likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      likes[resepId] = likesAndBookmarks['likes'] ?? 0;
      notifyListeners();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> likeResep(String resepId) async {
    try {
      Map<String, dynamic> likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      int currentLikes = likesAndBookmarks['likes'];
      bool isBookmarked = likesAndBookmarks['is_bookmarked'];

      if (likedByCurrentUser.containsKey(resepId) &&
          likedByCurrentUser[resepId]!) {
        // Jika sudah dilike, maka lakukan unlike
        likes[resepId] = (likes[resepId] ?? 0) - 1;
        likedByCurrentUser[resepId] = false;
      } else {
        likes[resepId] = currentLikes + 1;
        likedByCurrentUser[resepId] = true;
      }

      FirebaseService()
          .updateLikesAndBookmarks(resepId, likes[resepId]!, isBookmarked);
    } catch (e) {
      print('Error liking recipe: $e');
      throw Exception('Failed to like recipe');
    }

    notifyListeners();
  }

  bool isLikedByCurrentUser(String resepId) {
    return likedByCurrentUser.containsKey(resepId) &&
        likedByCurrentUser[resepId]!;
  }

  Future<void> unlikeResep(String resepId) async {
    try {
      if (likedByCurrentUser.containsKey(resepId) &&
          likedByCurrentUser[resepId]!) {
        likes[resepId] = (likes[resepId] ?? 0) - 1;
        likedByCurrentUser[resepId] = false;

        FirebaseService().updateLikesAndBookmarks(
            resepId, likes[resepId] ?? 0, bookmarks[resepId] ?? false);

        notifyListeners();
      }
    } catch (e) {
      print('Error unliking recipe: $e');
      throw Exception('Failed to unlike recipe');
    }
  }

  void toggleBookmark(String resepId) {
    if (bookmarks.containsKey(resepId)) {
      bookmarks[resepId] = !bookmarks[resepId]!;
    } else {
      bookmarks[resepId] = true;
    }
    notifyListeners();
    FirebaseService().updateLikesAndBookmarks(
        resepId, likes[resepId] ?? 0, bookmarks[resepId] ?? false);
  }

  bool isLiked(String resepId) {
    return likes.containsKey(resepId) && likes[resepId]! > 0;
  }
}

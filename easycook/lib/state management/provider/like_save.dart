import 'package:easycook/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ResepModel extends ChangeNotifier {
  Map<String, int> likes = {};
  Map<String, bool> likedByCurrentUser = {};
  Map<String, bool> bookmarks = {};

  Future<void> likeResep(String resepId) async {
    try {
      // Panggil metode untuk mendapatkan jumlah like dan status bookmark dari Firebase
      Map<String, dynamic> likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(resepId);
      int currentLikes = likesAndBookmarks['likes'];
      bool isBookmarked = likesAndBookmarks['is_bookmarked'];

      // Periksa apakah resep sudah dilike oleh pengguna saat ini
      if (likedByCurrentUser.containsKey(resepId) &&
          likedByCurrentUser[resepId]!) {
        // Jika sudah dilike, maka lakukan unlike
        likes[resepId] = (likes[resepId] ?? 0) - 1;
        likedByCurrentUser[resepId] = false;
      } else {
        // Jika belum dilike, maka lakukan like
        likes[resepId] = currentLikes + 1; // Tambahkan satu like
        likedByCurrentUser[resepId] = true;
      }

      // Panggil metode untuk mengupdate data like di Firebase
      FirebaseService()
          .updateLikesAndBookmarks(resepId, likes[resepId]!, isBookmarked);
    } catch (e) {
      print('Error liking recipe: $e');
      throw Exception('Failed to like recipe');
    }
    // Panggil notifyListeners() agar UI dapat diperbarui
    notifyListeners();
  }

  bool isLikedByCurrentUser(String resepId) {
    return likedByCurrentUser.containsKey(resepId) &&
        likedByCurrentUser[resepId]!;
  }

  Future<void> unlikeResep(String resepId) async {
    try {
      // Periksa apakah resep sudah dilike oleh pengguna saat ini
      if (likedByCurrentUser.containsKey(resepId) &&
          likedByCurrentUser[resepId]!) {
        // Jika sudah dilike, maka lakukan unlike
        likes[resepId] = (likes[resepId] ?? 0) - 1;
        likedByCurrentUser[resepId] = false;

        // Panggil metode untuk mengupdate data like di Firebase
        FirebaseService().updateLikesAndBookmarks(
            resepId, likes[resepId] ?? 0, bookmarks[resepId] ?? false);

        // Panggil notifyListeners() agar UI dapat diperbarui
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

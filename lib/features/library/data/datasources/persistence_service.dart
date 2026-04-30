import 'package:sqflite/sqflite.dart';
import 'db/database_helper.dart';
import '../../domain/entities/track.dart';

class LibraryPersistence {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> saveTrack(Track track) async {
    final db = await _dbHelper.database;
    
    await db.insert(
      'tracks',
      track.toMap()..['isSaved'] = 1,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeTrack(String trackId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tracks',
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }

  Future<List<Track>> getSavedTracks() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tracks');

    return maps.map((map) => Track.fromMap(map)).toList();
  }

  Future<bool> isTrackSaved(String trackId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tracks',
      where: 'id = ?',
      whereArgs: [trackId],
    );
    return maps.isNotEmpty;
  }
}

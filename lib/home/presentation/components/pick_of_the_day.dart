import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PickOfTheDay extends StatelessWidget {
  final List<dynamic> songs;
  final void Function(dynamic song)? onTap;

  const PickOfTheDay({super.key, required this.songs, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }
    // Use the day of year as a seed for deterministic randomness
    final now = DateTime.now();
    final dayOfYear = int.parse(
      DateTime(
        now.year,
        now.month,
        now.day,
      ).difference(DateTime(now.year, 1, 1)).inDays.toString(),
    );
    final random = Random(dayOfYear);
    final song = songs[random.nextInt(songs.length)];
    final String rawTitle = song['title'] ?? '';
    final String displayTitle = rawTitle.replaceFirst(
      RegExp(r'^\d+\s*-\s*'),
      '',
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC19976), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wimbo wa Siku',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFC19976),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap != null
                ? () {
                    HapticFeedback.mediumImpact();
                    onTap!(song);
                  }
                : null,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 26,
                  child: Text(
                    song['number'].toString(),
                    style: const TextStyle(
                      color: Color(0xFFC19976),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC19976),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFC19976)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

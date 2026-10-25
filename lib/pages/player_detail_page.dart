import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../providers/language_provider.dart';
import '../widgets/custom_bottom_bar.dart';

class PlayerDetailPage extends StatefulWidget {
  final FootballPlayer player;

  const PlayerDetailPage({
    super.key,
    required this.player,
  });

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  bool _isFavorite = true;
  bool _hasVoted = false;
  int _voteBonus = 0;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF0096C7);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.player.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${widget.player.club} • ${widget.player.position}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? '${widget.player.name} ditambahkan ke daftar favorit!'
                                : '${widget.player.name} dihapus dari favorit.',
                          ),
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Gambar Pemain Utama (WebP) dengan Card Modern
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Container(
                        width: double.infinity,
                        height: 240,
                        color: widget.player.badgeColor.withValues(alpha: 0.15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gambar WebP
                            Image.network(
                              widget.player.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [primaryColor, const Color(0xFF023E8A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white24,
                                          child: Text(
                                            '#${widget.player.number}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          widget.player.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: primaryColor,
                                  ),
                                );
                              },
                            ),
                            // Gradient Overlay di bagian bawah gambar
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            // Tag Nomor Punggung & Rating di atas gambar
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '#${widget.player.number} • ${widget.player.position}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade700,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Rating ${widget.player.rating}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.player.nickname,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ringkasan Statistik Utama (Karier)
                    Text(
                      lang.tr('stats_title'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStatBox(
                          label: lang.tr('goals'),
                          value: '${widget.player.goals}',
                          icon: Icons.sports_soccer_rounded,
                          color: primaryColor,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          label: lang.tr('assists'),
                          value: '${widget.player.assists}',
                          icon: Icons.hub_rounded,
                          color: const Color(0xFF0077B6),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          label: lang.tr('matches'),
                          value: '${widget.player.matches}',
                          icon: Icons.stadium_rounded,
                          color: const Color(0xFF023E8A),
                          isDark: isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Profil Singkat Pemain
                    Text(
                      lang.tr('player_profile'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        widget.player.bio,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Prestasi & Trofi (Trophies & Achievements)
                    Text(
                      lang.tr('trophies_title'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: widget.player.trophies.map((trophy) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  trophy,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Tombol Aksi Fans: Vote Pemain Favorit (Gaya Framer Motion)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasVoted ? const Color(0xFF023E8A) : primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: primaryColor.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _hasVoted = true;
                            _voteBonus++;
                          });
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              title: Row(
                                children: const [
                                  Icon(Icons.verified_rounded, color: primaryColor, size: 28),
                                  SizedBox(width: 10),
                                  Text('Vote Tercatat!'),
                                ],
                              ),
                              content: Text(
                                'Terima kasih telah memberikan suara untuk ${widget.player.name}!\n\n'
                                'Total vote penggemar: ${widget.player.fanVotes} (+$_voteBonus vote Anda).',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Tutup', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          _hasVoted ? Icons.check_circle_rounded : Icons.thumb_up_alt_rounded,
                          size: 22,
                        ),
                        label: Text(
                          _hasVoted ? 'Sudah Di-vote (${widget.player.fanVotes})' : lang.tr('vote_goat'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            CustomCurvedBottomBar(
              selectedIndex: 2,
              onItemSelected: (idx) {
                if (idx == 0) {
                  Navigator.pop(context);
                }
              },
              onDiamondPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Statistik ${widget.player.name} telah diperbarui.'),
                    backgroundColor: primaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

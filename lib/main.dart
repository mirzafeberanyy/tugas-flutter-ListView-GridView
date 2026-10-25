import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/player.dart';
import 'pages/player_detail_page.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';
import 'widgets/custom_bottom_bar.dart';
import 'widgets/framer_transitions.dart';

void main() {
  // Mendaftarkan 3 State Global (ThemeProvider, UserProvider, LanguageProvider)
  // di root aplikasi menggunakan MultiProvider dari package provider.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// 1. ROOT APP & THEME CONFIGURATION
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    const primaryColor = Color(0xFF0096C7);

    return MaterialApp(
      title: langProvider.tr('app_title'),
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF023E8A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return FramerMotionPageRoute(page: const HomePage());
        }
        return FramerMotionPageRoute(page: const LoginPage());
      },
    );
  }
}

// ============================================================================
// 2. WIDGET REUSABLE: PEMILIH BAHASA (PREMIUM & TANPA EMOJI)
// ============================================================================
class LanguageMenuButton extends StatelessWidget {
  final Color? iconColor;

  const LanguageMenuButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();

    return PopupMenuButton<AppLanguage>(
      tooltip: langProvider.tr('select_language'),
      icon: Icon(
        Icons.language_rounded,
        color: iconColor ?? Colors.white,
      ),
      initialValue: langProvider.currentLanguage,
      onSelected: (AppLanguage lang) {
        context.read<LanguageProvider>().setLanguage(lang);
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: AppLanguage.indonesia,
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: Color(0xFF0096C7)),
              SizedBox(width: 10),
              Text('Bahasa Indonesia (ID)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLanguage.english,
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: Color(0xFF0096C7)),
              SizedBox(width: 10),
              Text('English (EN)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLanguage.gayo,
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: Color(0xFF0096C7)),
              SizedBox(width: 10),
              Text('Basa Gayo - Aceh (GAY)'),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. LOGIN PAGE (BERSIH TANPA BOTTOM BAR + ANIMASI TRANSISI FRAMER MOTION)
// ============================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(text: 'kira@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    const primaryColor = Color(0xFF0096C7);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Bar (Bahasa & Tema)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_soccer_rounded, color: primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'FootyStars Hub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      LanguageMenuButton(iconColor: isDark ? Colors.white70 : primaryColor),
                      IconButton(
                        tooltip: 'Ganti Tema',
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: isDark ? Colors.white70 : primaryColor,
                        ),
                        onPressed: () {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Curved Header dengan drop setengah lingkaran khas konsep desain 0096C7
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 230,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.elliptical(250, 160),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ikon Trophy / Sepak Bola Fans
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.sports_soccer_rounded,
                                  color: primaryColor,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'FootyStars',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang.tr('app_subtitle'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Form Input Fields (Pill Shaped Border 0096C7)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          // Input Email / Username
                          TextField(
                            controller: _emailController,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              hintText: 'surname@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: primaryColor, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color(0xFF023E8A), width: 2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Input Password dengan Toggle Icon
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              hintText: '••••••••',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: primaryColor, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color(0xFF023E8A), width: 2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Forgot Password
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                lang.tr('forgot_password'),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tombol Login (Solid Pill 0096C7 dengan Animasi Framer Motion ke Home)
                          SizedBox(
                            width: 170,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: primaryColor.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                final text = _emailController.text.trim();
                                final name = text.contains('@') ? text.split('@').first : text;
                                context.read<UserProvider>().login(
                                      name.isNotEmpty ? name : 'Kira',
                                      email: text.isNotEmpty ? text : 'kira@gmail.com',
                                    );
                                // Pindah halaman dengan transisi halus Framer Motion
                                Navigator.pushReplacement(
                                  context,
                                  FramerMotionPageRoute(page: const HomePage()),
                                );
                              },
                              child: Text(
                                lang.tr('login_button'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            lang.tr('no_account'),
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
            // TIDAK ADA BOTTOM BAR DI LOGIN PAGE (SESUAI REQUEST USER)
          ],
        ),
      ),
    );
  }
}

// ==================================
// 4. HOME PAGE (GRIDVIEW & LISTVIEW 
// ==================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    const primaryColor = Color(0xFF0096C7);

    // Filter daftar pemain berdasarkan kategori posisi & pencarian
    final filteredPlayers = dummyPlayers.where((player) {
      final matchesCategory = _selectedCategory == 'All' || player.position == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          player.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          player.club.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          player.nationality.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CustomDrawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Konten Utama Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ========================================================
                    // TOP CURVED HEADER BIRU 0096C7
                    // ========================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(36),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Baris Atas: Drawer, Bahasa, Tema, Avatar dengan Dot Hijau
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (ctx) => IconButton(
                                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                                ),
                              ),
                              Row(
                                children: [
                                  LanguageMenuButton(iconColor: Colors.white),
                                  IconButton(
                                    tooltip: 'Ganti Tema',
                                    icon: Icon(
                                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      context.read<ThemeProvider>().toggleTheme();
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  // Avatar User dengan Online Green Dot
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white24,
                                        child: Text(
                                          userProvider.username.isNotEmpty
                                              ? userProvider.username.substring(0, 1).toUpperCase()
                                              : 'K',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF22C55E),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: primaryColor, width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Sapaan Pengguna
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${userProvider.username.isNotEmpty ? userProvider.username : "Kira"}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang.tr('app_subtitle'),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Search Bar Pill Putih dengan Icon Search Bulat 0096C7
                          Container(
                            height: 52,
                            padding: const EdgeInsets.only(left: 20, right: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val;
                                      });
                                    },
                                    style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: lang.tr('search_hint'),
                                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Categories Filter (Semua, Penyerang, Gelandang, Bek)
                          Text(
                            lang.tr('categories'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCategoryCard(
                                title: lang.tr('cat_all'),
                                categoryKey: 'All',
                                icon: Icons.sports_soccer_rounded,
                              ),
                              _buildCategoryCard(
                                title: lang.tr('cat_forward'),
                                categoryKey: 'Forward',
                                icon: Icons.bolt_rounded,
                              ),
                              _buildCategoryCard(
                                title: lang.tr('cat_midfield'),
                                categoryKey: 'Midfielder',
                                icon: Icons.hub_rounded,
                              ),
                              _buildCategoryCard(
                                title: lang.tr('cat_defender'),
                                categoryKey: 'Defender',
                                icon: Icons.shield_outlined,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ========================================================
                    // 1. GRIDVIEW: SOROTAN PEMAIN BOLA DENGAN GAMBAR WEBP
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.tr('featured_grid'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                lang.tr('featured_grid_sub'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'GridView (WebP)',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // GridView.builder menampilkan kartu pemain dengan gambar WebP
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredPlayers.length > 4 ? 4 : filteredPlayers.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final player = filteredPlayers[index];
                          return _buildPlayerGridCard(player, isDark, primaryColor);
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ========================================================
                    // KARTU SPOTLIGHT BINTANG UTAMA (FANS & PRESTASI)
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Thumbnail Foto WebP Spotlight
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: Image.network(
                                      dummyPlayers[0].imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        color: primaryColor,
                                        child: const Icon(Icons.sports_soccer_rounded, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dummyPlayers[0].name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.emoji_events_rounded, size: 14, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(
                                            '5x Ballon d\'Or • 915 Gol',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.favorite_rounded, size: 14, color: Colors.redAccent),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${dummyPlayers[0].fanVotes} Favorit',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol Detail Pill 0096C7
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      FramerMotionPageRoute(
                                        page: PlayerDetailPage(player: dummyPlayers[0]),
                                      ),
                                    );
                                  },
                                  child: const Text('Detail'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ========================================================
                    // 2. LISTVIEW & LISTTILE DENGAN FOTO WEBP
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.tr('all_list'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                lang.tr('all_list_sub'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ListView (WebP)',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ListView.builder menggunakan ListTile dan gambar WebP
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: filteredPlayers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final player = filteredPlayers[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            // Leading Foto Pemain WebP
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Image.network(
                                  player.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => CircleAvatar(
                                    backgroundColor: player.badgeColor.withValues(alpha: 0.15),
                                    child: Text(
                                      '#${player.number}',
                                      style: TextStyle(
                                        color: player.badgeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  player.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: primaryColor, size: 16),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '${player.club} • ${player.position} • ${player.goals} Gol',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${player.rating}',
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                              ],
                            ),
                            onTap: () {
                              // Navigasi halaman dengan Framer Motion transition
                              Navigator.push(
                                context,
                                FramerMotionPageRoute(
                                  page: PlayerDetailPage(player: player),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ========================================================
                    // 3. KARTU STATUS KETIGA STATE GLOBAL (INTEGRITAS TUGAS)
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.hub_rounded, color: primaryColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    lang.tr('global_state_title'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 18),
                              // State 1: UserProvider
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  radius: 18,
                                  child: Icon(Icons.person_rounded, size: 20),
                                ),
                                title: Text(lang.tr('state_user_title')),
                                subtitle: Text(
                                  'Username: ${userProvider.username} | Status: ${userProvider.isLoggedIn ? lang.tr("status_logged_in") : lang.tr("status_guest")}',
                                ),
                              ),
                              const Divider(height: 12),
                              // State 2: ThemeProvider
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 18,
                                  child: Icon(
                                    themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                    size: 20,
                                  ),
                                ),
                                title: Text(lang.tr('state_theme_title')),
                                subtitle: Text(
                                  'Tema: ${themeProvider.isDarkMode ? "Dark Mode" : "Light Mode"}',
                                ),
                                trailing: Switch(
                                  value: themeProvider.isDarkMode,
                                  activeColor: primaryColor,
                                  onChanged: (val) {
                                    context.read<ThemeProvider>().toggleTheme();
                                  },
                                ),
                              ),
                              const Divider(height: 12),
                              // State 3: LanguageProvider
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  radius: 18,
                                  child: Icon(Icons.translate_rounded, size: 20),
                                ),
                                title: Text(lang.tr('state_lang_title')),
                                subtitle: Text(
                                  'Bahasa: ${lang.languageName} (${lang.shortCode})',
                                ),
                                trailing: DropdownButton<AppLanguage>(
                                  value: lang.currentLanguage,
                                  underline: const SizedBox(),
                                  onChanged: (AppLanguage? newLang) {
                                    if (newLang != null) {
                                      context.read<LanguageProvider>().setLanguage(newLang);
                                    }
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: AppLanguage.indonesia,
                                      child: Text('ID'),
                                    ),
                                    DropdownMenuItem(
                                      value: AppLanguage.english,
                                      child: Text('EN'),
                                    ),
                                    DropdownMenuItem(
                                      value: AppLanguage.gayo,
                                      child: Text('GAY'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ========================================================
            // FLOATING CURVED BOTTOM BAR DENGAN ANIMASI SELEKSI TAB
            // ========================================================
            CustomCurvedBottomBar(
              selectedIndex: _currentNavIndex,
              onItemSelected: (idx) {
                setState(() {
                  _currentNavIndex = idx;
                });
              },
              onDiamondPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aksi Cepat: Beri vote untuk kandidat Ballon d\'Or 2026'),
                    backgroundColor: primaryColor,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Kategori di Bagian Header Biru
  Widget _buildCategoryCard({
    required String title,
    required String categoryKey,
    required IconData icon,
  }) {
    final isSelected = _selectedCategory == categoryKey;
    const primaryColor = Color(0xFF0096C7);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF023E8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : primaryColor,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Item GridView Pemain Bola dengan Foto WebP
  Widget _buildPlayerGridCard(FootballPlayer player, bool isDark, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          FramerMotionPageRoute(
            page: PlayerDetailPage(player: player),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar WebP Pemain di bagian atas kartu
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      player.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: player.badgeColor.withValues(alpha: 0.2),
                        child: Center(
                          child: Icon(Icons.sports_soccer_rounded, color: player.badgeColor, size: 36),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '#${player.number}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${player.rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info Pemain di bagian bawah kartu
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${player.club} • ${player.position}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${player.goals} Gol',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 5. CUSTOM DRAWER (BEBAS EMOJI & TEMA FANS SEPAK BOLA)
// ============================================================================
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    const primaryColor = Color(0xFF0096C7);

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.sports_soccer_rounded, color: primaryColor, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  '${langProvider.tr("welcome_drawer")}, ${userProvider.username.isNotEmpty ? userProvider.username : "Pengguna"}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userProvider.email.isNotEmpty ? userProvider.email : "user@gmail.com",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: primaryColor),
            title: Text(langProvider.tr('home')),
            onTap: () => Navigator.pop(context),
          ),
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: primaryColor,
            ),
            title: Text(langProvider.tr('dark_mode')),
            value: themeProvider.isDarkMode,
            activeColor: primaryColor,
            onChanged: (val) {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: primaryColor),
            title: Text(langProvider.tr('language')),
            subtitle: Text(langProvider.languageName),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return SimpleDialog(
                    title: Text(langProvider.tr('select_language')),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LanguageProvider>().setLanguage(AppLanguage.indonesia);
                          Navigator.pop(ctx);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('Bahasa Indonesia (ID)'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LanguageProvider>().setLanguage(AppLanguage.english);
                          Navigator.pop(ctx);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('English (EN)'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LanguageProvider>().setLanguage(AppLanguage.gayo);
                          Navigator.pop(ctx);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('Basa Gayo - Aceh (GAY)'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: Text(
              langProvider.tr('logout'),
              style: const TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              context.read<UserProvider>().logout();
              Navigator.pushReplacement(
                context,
                FramerMotionPageRoute(page: const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
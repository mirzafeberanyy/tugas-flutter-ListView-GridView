import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';

void main() {
  // Mendaftarkan 3 State Global (ThemeProvider, UserProvider, LanguageProvider)
  // di root aplikasi menggunakan MultiProvider dari library provider.
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

// 1. ROOT APP & ROUTING
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan tema global menggunakan context.watch<ThemeProvider>()
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: langProvider.tr('app_title'),
      debugShowCheckedModeBanner: false,
      // Tema dinamis (Light / Dark) diambil dari ThemeProvider (State Global 1)
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF456B8C),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF456B8C),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF456B8C),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E2A38),
          foregroundColor: Colors.white,
        ),
      ),
      // Mendaftarkan route untuk navigasi
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

// WIDGET PEMILIH BAHASA (REUSABLE)
class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();

    return PopupMenuButton<AppLanguage>(
      tooltip: langProvider.tr('select_language'),
      icon: const Icon(Icons.language),
      initialValue: langProvider.currentLanguage,
      onSelected: (AppLanguage lang) {
        // STATE GLOBAL 3: Mengubah bahasa global via context.read
        context.read<LanguageProvider>().setLanguage(lang);
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: AppLanguage.indonesia,
          child: Text('🇮🇩 Bahasa Indonesia'),
        ),
        PopupMenuItem(
          value: AppLanguage.english,
          child: Text('🇬🇧 English'),
        ),
        PopupMenuItem(
          value: AppLanguage.gayo,
          child: Text('🏔️ Basa Gayo (Aceh)'),
        ),
      ],
    );
  }
}

// 2. STATEFUL WIDGET PADA LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(langProvider.tr('login_page')),
        actions: [
          // Tombol pemilih bahasa (State Global 3)
          const LanguageMenuButton(),
          // Tombol toggle tema (State Global 1)
          IconButton(
            tooltip: 'Ganti Tema',
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              langProvider.tr('sign_in'),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? Colors.lightBlueAccent
                    : const Color(0xFF456B8C),
              ),
            ),
            const SizedBox(height: 40),

            // TextField Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people),
                labelText: langProvider.tr('username'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // TextField Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: langProvider.tr('password'),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(langProvider.tr('forgot_password')),
            ),

            const SizedBox(height: 10),
            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B5B95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final inputUsername = _usernameController.text.trim();
                  // STATE GLOBAL 2: Simpan user ke UserProvider
                  context.read<UserProvider>().login(
                        inputUsername.isNotEmpty ? inputUsername : 'Mahasiswa',
                      );

                  // Navigasi ke halaman Home
                  Navigator.pushReplacementNamed(context, '/home');
                },
                icon: const Icon(Icons.login, color: Colors.white),
                label: Text(
                  langProvider.tr('login_button'),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              langProvider.tr('no_account'),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. HOME PAGE (MENAMPILKAN DATA DARI KETIGA STATE GLOBAL)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca ketiga state global untuk ditampilkan di halaman Home
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(langProvider.tr('home')),
        actions: [
          // Pilihan Bahasa (State Global 3)
          const LanguageMenuButton(),
          // Toggle Tema (State Global 1)
          IconButton(
            tooltip: 'Ganti Tema',
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '${langProvider.tr('greeting')}, ${userProvider.username.isNotEmpty ? userProvider.username : "Pengguna"}!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                userProvider.email,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 28),

              // Card status dari Ketiga State Global
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        langProvider.tr('global_state_title'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 20),

                      // Informasi State 1: UserProvider
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(langProvider.tr('state_user_title')),
                        subtitle: Text(
                          'User: ${userProvider.username}\nStatus: ${userProvider.isLoggedIn ? langProvider.tr("status_logged_in") : langProvider.tr("status_guest")}',
                        ),
                      ),
                      const Divider(height: 16),

                      // Informasi State 2: ThemeProvider
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Icon(
                            themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                        ),
                        title: Text(langProvider.tr('state_theme_title')),
                        subtitle: Text(
                          'Tema: ${themeProvider.isDarkMode ? "Dark Mode" : "Light Mode"}',
                        ),
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            context.read<ThemeProvider>().toggleTheme();
                          },
                        ),
                      ),
                      const Divider(height: 16),

                      // Informasi State 3: LanguageProvider
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          child: Icon(Icons.translate),
                        ),
                        title: Text(langProvider.tr('state_lang_title')),
                        subtitle: Text(
                          '${langProvider.tr("language")}: ${langProvider.languageName}',
                        ),
                        trailing: DropdownButton<AppLanguage>(
                          value: langProvider.currentLanguage,
                          underline: const SizedBox(),
                          onChanged: (AppLanguage? newLang) {
                            if (newLang != null) {
                              context.read<LanguageProvider>().setLanguage(newLang);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: AppLanguage.indonesia,
                              child: Text('🇮🇩 ID'),
                            ),
                            DropdownMenuItem(
                              value: AppLanguage.english,
                              child: Text('🇬🇧 EN'),
                            ),
                            DropdownMenuItem(
                              value: AppLanguage.gayo,
                              child: Text('🏔️ GAYO'),
                            ),
                          ],
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
    );
  }
}

// 4. CUSTOM DRAWER (MENERAPKAN KETIGA STATE GLOBAL)
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca ketiga state global untuk drawer
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E2A38) : const Color(0xFFF4F6FB),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Drawer dengan data dinamis dari UserProvider & LanguageProvider
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF263545) : const Color(0xFFF4F6FB),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 55),
                const SizedBox(height: 12),
                Text(
                  '${langProvider.tr("welcome_drawer")}, ${userProvider.email.isNotEmpty ? userProvider.email : "fluter@gmail.com"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (userProvider.username.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '(${userProvider.username})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.lightBlueAccent : const Color(0xFF456B8C),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Menu Home
          ListTile(
            leading: Icon(
              Icons.home,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            title: Text(langProvider.tr('home')),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Menu Toggle Tema (Dark Mode) dari ThemeProvider (State Global 1)
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            title: Text(langProvider.tr('dark_mode')),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),

          // Menu Pemilihan Bahasa dari LanguageProvider (State Global 3)
          ListTile(
            leading: Icon(
              Icons.language,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
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
                          child: Text('🇮🇩 Bahasa Indonesia'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LanguageProvider>().setLanguage(AppLanguage.english);
                          Navigator.pop(ctx);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('🇬🇧 English'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LanguageProvider>().setLanguage(AppLanguage.gayo);
                          Navigator.pop(ctx);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('🏔️ Basa Gayo (Aceh)'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const Divider(),

          // Menu Logout yang mereset UserProvider (State Global 2)
          ListTile(
            leading: Icon(
              Icons.logout,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            title: Text(langProvider.tr('logout')),
            onTap: () {
              // Mereset state user pada UserProvider
              context.read<UserProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. STATELESS WIDGET & ROUTING
// MyApp adalah StatelessWidget karena tidak ada perubahan state pada root aplikasi.
// Di sini kita mengatur tema dan Routing (Navigasi).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas UI Flutter',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF456B8C), // Warna biru AppBar sesuai gambar
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

// 2. STATEFUL WIDGET
// LoginPage menggunakan StatefulWidget karena biasanya halaman login 
// membutuhkan interaksi yang mengubah state (misalnya mengetik di TextField).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menangani input dari pengguna
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      // LAYOUTING: Menggunakan Padding, Column, dan SizedBox
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF456B8C),
              ),
            ),
            const SizedBox(height: 40),
            
            // WIDGET: TextField untuk Username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.people),
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // WIDGET: TextField untuk Password
            TextField(
              controller: _passwordController,
              obscureText: true, // Menyembunyikan teks password
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot Password'),
            ),
            
            const SizedBox(height: 10),
            // WIDGET: ElevatedButton untuk tombol Login
            SizedBox(
              width: double.infinity, // Memenuhi lebar layar
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B5B95), // Warna ungu sesuai gambar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // NAVIGASI: Pindah ke halaman Home dan hapus halaman login dari history (stack)
                  Navigator.pushReplacementNamed(context, '/home');
                },
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            const Text(
              'Does not have account?',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. STATELESS WIDGET PADA HALAMAN HOME
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      // Menambahkan Drawer (Menu Samping)
      drawer: const CustomDrawer(),
      body: const Center(
        // LAYOUT: Center digunakan untuk meletakkan widget di tengah layar
        child: Text(
          'Hello World',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Widget Custom untuk Drawer agar kode lebih rapi
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F6FB), // Warna background drawer yang sedikit kebiruan
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Bagian Header Drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF4F6FB),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FlutterLogo(size: 60), // Logo flutter
                SizedBox(height: 16),
                Text(
                  'Welcome, fluter@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          // List menu di dalam drawer
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black54),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Menutup drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black54),
            title: const Text('Profile'),
            onTap: () {
              // Aksi untuk menu profile (kosong untuk saat ini)
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black54),
            title: const Text('Logout'),
            onTap: () {
              // NAVIGASI: Logout dan kembali ke halaman Login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'providers/music_provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/player_screen.dart';
import 'screens/playlist_detail_screen.dart';
import 'screens/artist_detail_screen.dart';
import 'screens/album_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SpinTunesApp());
}

class SpinTunesApp extends StatelessWidget {
  const SpinTunesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            if (state.uri.path == '/player' || state.uri.path == '/settings') {
              return child;
            }
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
            GoRoute(
              path: '/player',
              builder: (context, state) => const PlayerScreen(),
            ),
            GoRoute(
              path: '/playlist/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PlaylistDetailScreen(playlistId: id);
              },
            ),
            GoRoute(
              path: '/artist/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ArtistDetailScreen(artistId: id);
              },
            ),
            GoRoute(
              path: '/album/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return AlbumDetailScreen(albumId: id);
              },
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );

    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: MaterialApp.router(
        title: 'SpinTunes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF6B9D),
            secondary: Color(0xFF00D9FF),
            surface: Colors.black,
            onSurface: Colors.white,
          ),
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
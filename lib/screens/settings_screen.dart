import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _downloadOnWifi = true;
  bool _highQualityAudio = false;
  double _audioQuality = 320;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0e27),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0a0e27), Color(0xFF1a1f3a), Color(0xFF2a1e4a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 8),

                      // Playback Section
                      _buildSectionTitle('Playback'),
                      const SizedBox(height: 12),

                      GlassCard(
                        child: Column(
                          children: [
                            _buildToggleOption(
                              'High Quality Audio',
                              'Stream music at maximum quality',
                              Icons.high_quality,
                              _highQualityAudio,
                                  (value) => setState(() => _highQualityAudio = value),
                            ),
                            _buildDivider(),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Audio Quality',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'Adjust streaming quality',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${_audioQuality.toInt()} kbps',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFF667eea),
                                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                                      thumbColor: Colors.white,
                                      overlayColor: const Color(0xFF667eea).withOpacity(0.3),
                                    ),
                                    child: Slider(
                                      value: _audioQuality,
                                      min: 96,
                                      max: 320,
                                      divisions: 3,
                                      onChanged: (value) => setState(() => _audioQuality = value),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Download Section
                      _buildSectionTitle('Downloads'),
                      const SizedBox(height: 12),

                      GlassCard(
                        child: Column(
                          children: [
                            _buildToggleOption(
                              'Download on WiFi Only',
                              'Save mobile data when downloading',
                              Icons.wifi,
                              _downloadOnWifi,
                                  (value) => setState(() => _downloadOnWifi = value),
                            ),
                            _buildDivider(),
                            _buildActionOption(
                              'Manage Downloads',
                              'View and manage downloaded content',
                              Icons.download,
                                  () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Notifications Section
                      _buildSectionTitle('Notifications'),
                      const SizedBox(height: 12),

                      GlassCard(
                        child: _buildToggleOption(
                          'Push Notifications',
                          'Get notified about new releases',
                          Icons.notifications,
                          _notificationsEnabled,
                              (value) => setState(() => _notificationsEnabled = value),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // About Section
                      _buildSectionTitle('About'),
                      const SizedBox(height: 12),

                      GlassCard(
                        child: Column(
                          children: [
                            _buildActionOption(
                              'Terms of Service',
                              'Read our terms and conditions',
                              Icons.description,
                                  () {},
                            ),
                            _buildDivider(),
                            _buildActionOption(
                              'Privacy Policy',
                              'Learn how we protect your data',
                              Icons.privacy_tip,
                                  () {},
                            ),
                            _buildDivider(),
                            _buildActionOption(
                              'About SpinTunes',
                              'Version 1.0.0',
                              Icons.info,
                                  () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildToggleOption(
      String title,
      String subtitle,
      IconData icon,
      bool value,
      Function(bool) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFFf093fb)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF667eea),
            activeTrackColor: const Color(0xFF667eea).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionOption(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

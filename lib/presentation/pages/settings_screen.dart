import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../widgets/custom_back_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a120d),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 6.0, bottom: 6.0),
          child: CustomBackButton(color: Colors.white),
        ),
        title: Text(
          'Ajustes',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildPreferencesGroup(context),
            const SizedBox(height: 24),
            _buildAccountGroup(context),
            const SizedBox(height: 24),
            _buildAboutGroup(context),
            const SizedBox(height: 32),
            _buildDeleteAccountButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesGroup(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'PREFERENCIAS',
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF102217).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  _buildThemeSelectorRow(context, themeProvider),
                  _buildDivider(),
                  _buildColorSelectorRow(context, themeProvider),
                  _buildDivider(),
                  _buildSettingsRow(
                    title: 'Idioma',
                    rightWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Español',
                          style: GoogleFonts.manrope(
                              color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded,
                            color: Colors.white24, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelectorRow(BuildContext context, ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tema de la App',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              _buildThemeButton(
                  context, provider, ThemeMode.light, Icons.wb_sunny_rounded),
              const SizedBox(width: 8),
              _buildThemeButton(
                  context, provider, ThemeMode.dark, Icons.nightlight_round),
              const SizedBox(width: 8),
              _buildThemeButton(
                  context, provider, ThemeMode.system, Icons.settings_rounded),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildThemeButton(BuildContext context, ThemeProvider provider,
      ThemeMode mode, IconData icon) {
    final isSelected = provider.themeMode == mode;
    final activeColor = provider.primaryColor;

    return GestureDetector(
      onTap: () => provider.setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 10)]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? activeColor : Colors.white54,
        ),
      ),
    );
  }

  Widget _buildColorSelectorRow(BuildContext context, ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Color de Énfasis',
            style: GoogleFonts.manrope(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              _buildColorDot(provider, ThemeProvider.defaultBlue),
              const SizedBox(width: 6),
              _buildColorDot(provider, ThemeProvider.premiumGreen),
              const SizedBox(width: 6),
              _buildColorDot(provider, ThemeProvider.gold),
              const SizedBox(width: 6),
              _buildColorDot(provider, ThemeProvider.rose),
              const SizedBox(width: 6),
              _buildColorDot(provider, ThemeProvider.violet),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorDot(ThemeProvider provider, Color color) {
    final isSelected = provider.primaryColor == color;
    return GestureDetector(
      onTap: () => provider.setPrimaryColor(color),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)]
              : null,
        ),
      ),
    );
  }

  Widget _buildAccountGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'CUENTA',
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF102217).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  _buildSettingsRow(
                    title: 'Editar Perfil',
                    icon: Icons.person_outline_rounded,
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    title: 'Cambiar Contraseña',
                    icon: Icons.lock_outline_rounded,
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    title: 'Privacidad y Datos',
                    icon: Icons.security_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'ACERCA DE AGAPEMAP',
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF102217).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  _buildSettingsRow(title: 'Términos de Servicio'),
                  _buildDivider(),
                  _buildSettingsRow(title: 'Política de Privacidad'),
                  _buildDivider(),
                  _buildSettingsRow(
                    title: 'Versión 1.0.0',
                    isTextOnlyRight: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          'Eliminar Cuenta',
          style: GoogleFonts.manrope(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required String title,
    IconData? icon,
    Widget? rightWidget,
    bool isTextOnlyRight = false,
  }) {
    return InkWell(
      onTap: isTextOnlyRight ? null : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  color: isTextOnlyRight ? Colors.white54 : Colors.white,
                  fontSize: 15,
                  fontWeight:
                      isTextOnlyRight ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
            if (rightWidget != null) rightWidget,
            if (!isTextOnlyRight && rightWidget == null)
              const Icon(Icons.chevron_right_rounded,
                  color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 1, color: Colors.white.withOpacity(0.05));
  }
}

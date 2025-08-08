import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

import 'package:arc_gui/l10n/app_localizations.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 800;
    //final pageProvider = Provider.of<PageProvider>(context, listen: false);

    return Container(
      width: isCompact ? 80 : 300,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.appTitle,
               style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          _buildTile(context, Icons.smart_toy,    AppLocalizations.of(context)!.robotMenu,          AppPage.robot,          isCompact),
          _buildTile(context, Icons.message,      AppLocalizations.of(context)!.communicationMenu,  AppPage.communication,  isCompact),
          _buildTile(context, Icons.videocam,     AppLocalizations.of(context)!.videoMenu,          AppPage.video,          isCompact),
          _buildTile(context, Icons.auto_awesome, AppLocalizations.of(context)!.intentionMenu,      AppPage.intention,      isCompact),
          //const SizedBox(height: 20,),
          Divider(color: Theme.of(context).dividerColor),
          _buildTile(context, Icons.play_arrow, AppLocalizations.of(context)!.launchMenu, AppPage.launch, isCompact),
          Divider(color: Theme.of(context).dividerColor),
          const Spacer(),
          Divider(color: Theme.of(context).dividerColor),
          _buildTile(context, Icons.settings, AppLocalizations.of(context)!.settingsMenu, AppPage.settings, isCompact),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, AppPage page, bool isCompact) {
    final pageProvider = Provider.of<PageProvider>(context);
    final isCurrent = pageProvider.currentPage == page;
    //final isLaunch = page == AppPage.launch;

    // Outlined icon mapping
    final outlinedIcons = {
      Icons.smart_toy: Icons.smart_toy_outlined,
      Icons.message: Icons.message_outlined,
      Icons.videocam: Icons.videocam_outlined,
      Icons.auto_awesome: Icons.auto_awesome_outlined,
      Icons.play_arrow: Icons.play_arrow_outlined,
      Icons.settings: Icons.settings_outlined,
    };

    final selectedIcon = isCurrent ? icon : (outlinedIcons[icon] ?? icon);

    final tile = ListTile(
      leading: Icon(
        selectedIcon,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      title: isCompact
          ? null
          : Text(
              label,
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
      onTap: () => pageProvider.changePage(page),
      horizontalTitleGap: isCompact ? 0 : null,
      minLeadingWidth: isCompact ? 0 : null,
      contentPadding: isCompact ? const EdgeInsets.symmetric(horizontal: 16) : null,
    );

    if (isCurrent) {
      return Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: tile,
      );
    }

    return tile;
  }
}

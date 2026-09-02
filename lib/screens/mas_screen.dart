import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../data/user_session.dart';
import '../navigation/app_routes.dart';
import '../theme/app_spacing.dart';
import '../widgets/ajustes_perfil_section.dart';
import '../widgets/mas_menu_item.dart';
import '../widgets/section_header.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({super.key, this.embedded = false});

  static const screenKey = ValueKey<String>('ajustes_screen');

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final options = SampleData.masOptions;

    final body = ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
        AppSpacing.screenHorizontal,
        embedded ? 120 : AppSpacing.xxl,
      ),
      children: [
        if (embedded) ...[
          const ScreenHeader(
            title: 'Ajustes',
            subtitle: 'Perfil y personalización',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ],
        const AjustesPerfilSection(),
        const SizedBox(height: AppSpacing.sectionGap),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: MasMenuItem(
              emoji: option.emoji,
              titulo: option.titulo,
              onTap: switch (option.titulo) {
                'Lugares' => () => AppNavigation.openPanelLugares(context),
                'Apariencia' => () => AppNavigation.openApariencia(context),
                _ => null,
              },
            ),
          ),
        ),
      ],
    );

    if (embedded) {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(child: body),
      );
    }

    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        return Scaffold(
          key: MasScreen.screenKey,
          appBar: AppBar(title: const Text('Ajustes')),
          body: SafeArea(child: body),
        );
      },
    );
  }
}

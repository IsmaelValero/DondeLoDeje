import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/user_session.dart';
import '../data/models.dart';
import '../data/opcion_catalogo.dart';
import '../data/recuerdos_query.dart';
import '../navigation/app_routes.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_navigation.dart';
import '../widgets/app_search_field.dart';
import '../widgets/home_category_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/lugar_frecuente_card.dart';
import '../widgets/recuerdo_card.dart';

/// Pantalla principal con buscador y categorías planas (paginadas).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const screenKey = ValueKey<String>('home_screen');
  static const categoriasPorPagina = 8;
  static const gridCrossAxisCount = 2;
  static const gridAspectRatio = 1.32;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageAnimationDuration = Duration(milliseconds: 220);

  late final PageController _pageController;
  late final TextEditingController _searchController;
  int _paginaActual = 0;
  List<Recuerdo> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = RecuerdosQuery.search(_searchController.text);
    });
  }

  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  void _onCategoriaTap(OpcionCatalogo categoria) {
    AppNavigation.openLugarZonas(context, categoria.id);
  }

  List<List<OpcionCatalogo>> _paginas(List<OpcionCatalogo> opciones) {
    if (opciones.isEmpty) return [[]];

    final paginas = <List<OpcionCatalogo>>[];
    for (var i = 0; i < opciones.length; i += HomeScreen.categoriasPorPagina) {
      final fin = (i + HomeScreen.categoriasPorPagina).clamp(0, opciones.length);
      paginas.add(opciones.sublist(i, fin));
    }
    return paginas;
  }

  void _ensureValidPage(int totalPaginas) {
    if (totalPaginas == 0) return;

    final paginaSegura = _paginaActual.clamp(0, totalPaginas - 1);
    if (paginaSegura == _paginaActual) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final safe = _paginaActual.clamp(0, totalPaginas - 1);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(safe);
      }
      if (_paginaActual != safe) {
        setState(() => _paginaActual = safe);
      }
    });
  }

  Future<void> _irPaginaAnterior() async {
    if (!_pageController.hasClients || _paginaActual <= 0) return;
    await _pageController.previousPage(
      duration: _pageAnimationDuration,
      curve: Curves.easeOut,
    );
  }

  Future<void> _irPaginaSiguiente() async {
    if (!_pageController.hasClients) return;
    await _pageController.nextPage(
      duration: _pageAnimationDuration,
      curve: Curves.easeOut,
    );
  }

  static double _gridHeightFor(int itemCount, double width) {
    if (itemCount <= 0) return 0;

    const spacing = AppSpacing.md;
    const crossAxisCount = HomeScreen.gridCrossAxisCount;
    const aspectRatio = HomeScreen.gridAspectRatio;

    final rows = (itemCount / crossAxisCount).ceil();
    final cellWidth = (width - spacing) / crossAxisCount;
    final cellHeight = cellWidth / aspectRatio;
    return rows * cellHeight + (rows - 1) * spacing;
  }

  Future<void> _openCrearRecuerdo() async {
    final created = await Navigator.of(context).pushNamed(AppRoutes.crearRecuerdo);
    if (created == true && mounted) {
      _onSearchChanged();
    }
  }

  Widget _buildCategoriasGrid(List<OpcionCatalogo> categoriasPagina) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: HomeScreen.gridCrossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: HomeScreen.gridAspectRatio,
      ),
      itemCount: categoriasPagina.length,
      itemBuilder: (context, index) {
        final categoria = categoriasPagina[index];
        return LugarFrecuenteCard(
          opcion: categoria,
          objetosCount: RecuerdosQuery.countForOpcion(categoria),
          onTap: () => _onCategoriaTap(categoria),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        CatalogoSession.instance,
        UserSession.instance,
      ]),
      builder: (context, _) {
        final categorias = CatalogoSession.instance.categorias;
        final paginas = _paginas(categorias);
        final totalPaginas = paginas.length;

        _ensureValidPage(totalPaginas);

        final paginaSegura =
            totalPaginas == 0 ? 0 : _paginaActual.clamp(0, totalPaginas - 1);
        final query = _searchController.text.trim();

        final slotsVisibles = totalPaginas > 1
            ? HomeScreen.categoriasPorPagina
            : categorias.length.clamp(0, HomeScreen.categoriasPorPagina);

        return Scaffold(
          key: HomeScreen.screenKey,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(
                    subtitle: RecuerdosQuery.subtituloInicio(),
                    userName: UserSession.instance.displayName,
                    onAjustesTap: () => AppNavigation.openMas(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppSearchField(
                    key: const Key('home_search'),
                    controller: _searchController,
                    onSubmitted: (_) => _onSearchChanged(),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  if (_isSearching)
                    _HomeSearchResults(
                      query: query,
                      results: _searchResults,
                      onUpdated: _onSearchChanged,
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final gridHeight =
                            _gridHeightFor(slotsVisibles, constraints.maxWidth);

                        if (totalPaginas <= 1) {
                          return SizedBox(
                            height: gridHeight,
                            child: _buildCategoriasGrid(paginas.first),
                          );
                        }

                        return SizedBox(
                          height: gridHeight,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalPaginas,
                            onPageChanged: (index) {
                              setState(() => _paginaActual = index);
                            },
                            itemBuilder: (context, pageIndex) {
                              return _buildCategoriasGrid(paginas[pageIndex]);
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _isSearching
              ? null
              : HomeCategoryNav(
                  canGoLeft: paginaSegura > 0,
                  canGoRight: paginaSegura < totalPaginas - 1,
                  onPrevious: _irPaginaAnterior,
                  onNext: _irPaginaSiguiente,
                  pageIndex: paginaSegura,
                  pageCount: totalPaginas,
                ),
          floatingActionButton: AppFab(onPressed: _openCrearRecuerdo),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

class _HomeSearchResults extends StatelessWidget {
  const _HomeSearchResults({
    required this.query,
    required this.results,
    required this.onUpdated,
  });

  final String query;
  final List<Recuerdo> results;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Text(
          'No hay resultados para “$query”.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < results.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.itemGap),
          RecuerdoCard(
            recuerdo: results[i],
            onUpdated: onUpdated,
          ),
        ],
      ],
    );
  }
}

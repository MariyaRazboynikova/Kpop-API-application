import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpop_application/core/themes/themes.dart';
import 'package:kpop_application/core/themes/themes_provider.dart';
import 'package:kpop_application/features/data/models/group_model.dart';
import 'package:kpop_application/features/presentaion/bloc/groups_bloc.dart';
import 'package:kpop_application/features/presentaion/pages/members_page.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Инициируем загрузку групп при открытии страницы
    Future.microtask(() {
      context.read<GroupsBloc>().add(FetchGroup());
    });
  }

  @override
  Widget build(BuildContext context) {
    final themesProvider = context.watch<ThemesProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'Female k-pop groups',
            style: GoogleFonts.dmSerifDisplay(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Switch(
            activeColor: Theme.of(context).colorScheme.tertiary,
            inactiveThumbColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.secondary,
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return const Icon(Icons.sunny);
              }
              return const Icon(Icons.star);
            }),
            value: themesProvider.themeData == darkMode,
            onChanged: (value) {
              themesProvider.toggleTheme();
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/intro_page',
              (route) => false,
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.tertiary,
            size: 30,
          ),
        ),
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded) {
            // Сортировка групп по имени
            List<Group> sortedGroups = List.from(state.groups.groups);
            sortedGroups.sort((a, b) => a.name.compareTo(b.name));
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Поиск по названию группы...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedGroups.length,
                    itemBuilder: (context, index) {
                      var group = sortedGroups[index];
                      if (!group.name.toLowerCase().contains(searchQuery)) {
                        return Container();
                      }
                      return ListTile(
                        title: Text(group.name),
                        subtitle: Text(group.agencyName),
                        leading:
                            group.thumbUrl != null
                                ? Image.network(group.thumbUrl!)
                                : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MembersPage(
                                    group: group,
                                    idols: state.groups.idols,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is GroupsError) {
            return const Center(child: Text('Ошибка загрузки групп'));
          }
          return Container();
        },
      ),
    );
  }
}

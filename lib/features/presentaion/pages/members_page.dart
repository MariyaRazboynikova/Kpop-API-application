import 'package:flutter/material.dart';
import 'package:kpop_application/features/data/models/group_model.dart';
import 'package:kpop_application/features/data/models/idol_member.dart';
import 'package:kpop_application/features/presentaion/pages/idols_page.dart';

class MembersPage extends StatelessWidget {
  final Group group;
  final List<Idol> idols;

  const MembersPage({Key? key, required this.group, required this.idols})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: ListView.builder(
        itemCount: group.members.length,
        itemBuilder: (context, index) {
          var member = group.members[index];
          // Получаем имя айдола по его idolId
          String idolName = getIdolName(member.idolId, idols);

          return ListTile(
            title: Text(idolName), // Отображаем имя айдола
            subtitle: Text(member.roles ?? "Роль не указана"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          IdolsPage(memberId: member.idolId, idols: idols),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getIdolName(String idolId, List<Idol> idols) {
    // Находим айдола по его id и возвращаем его имя
    return idols
        .firstWhere(
          (idol) => idol.id == idolId,
          orElse: () => throw Exception('Айдол с id $idolId не найден'),
        )
        .name;
  }
}

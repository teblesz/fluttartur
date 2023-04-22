import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quest_tiles.dart';
part 'team_wrap.dart';
part 'game_buttons.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listener: (context, state) => listenGameCubit(context, state),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _QuestTiles(),
          Expanded(
            child: _TeamWrap(),
          ),
          BlocBuilder<GameCubit, GameState>(
              // TODO remove this
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return Text(state.status.name);
              }),
          _GameButtons(),
        ],
      ),
    );
  }
}

void listenGameCubit(context, state) {
  switch (state.status) {
    case GameStatus.squadChoice:
      break;
    case GameStatus.squadVoting:
      break;
    case GameStatus.questVoting:
      _pushSquadVotingDialog(context);
      //navigation to page
      break;
    case GameStatus.questResults:
      //popup
      break;
    case GameStatus.gameResults:
      //popup with leave room
      break;
  }
}
//guziki na dole, nie popup, jak kliknie to wyszarzyc,
// zmiana stanu przez nasluhwanie na squad w gameloop,
// a stan w fs smienia tylko lider

Future<void> _pushSquadVotingDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Vote this squad"),
          content: null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Approve"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Reject"),
            ),
          ],
        );
      });
}

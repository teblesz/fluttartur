part of 'game_form.dart';

class _GameButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // streamBuilder is here to start streaming player for bussiness logic (?)
    return StreamBuilder<Player>(
        stream: context.read<DataRepository>().streamPlayer(),
        builder: (context, snapshot) {
          var usersPlayer = snapshot.data ?? Player.empty;
          return BlocBuilder<GameCubit, GameState>(
              // TODO remove this
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                if (state.status == GameStatus.squadChoice &&
                    usersPlayer.isLeader) {
                  return _SubmitSquadButton();
                } else if (state.status == GameStatus.squadVoting) {
                  return _VoteSquadPanel();
                } else {
                  return const SizedBox.shrink();
                }
              });
        });
  }
}

class _SubmitSquadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: context.read<GameCubit>().submitSquad,
      child: const Text(
        "Submit Team",
        style: TextStyle(
          fontSize: 23,
        ),
      ),
    );
  }
}

class _VoteSquadPanel extends StatefulWidget {
  @override
  State<_VoteSquadPanel> createState() => _VoteSquadPanelState();
}

class _VoteSquadPanelState extends State<_VoteSquadPanel> {
  bool _isDisabled = false;

  void _updateisDisabled(bool newState) {
    setState(() {
      _isDisabled = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Vote for this squad',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _VoteSquadButton(
                isPositive: true,
                isDisabled: _isDisabled,
                updateisDisabled: _updateisDisabled,
              ),
              _VoteSquadButton(
                isPositive: false,
                isDisabled: _isDisabled,
                updateisDisabled: _updateisDisabled,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _VoteSquadButton extends StatelessWidget {
  const _VoteSquadButton({
    required this.isDisabled,
    required this.updateisDisabled,
    required this.isPositive,
  });

  final bool isDisabled;
  final Function(bool) updateisDisabled;

  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                context.read<GameCubit>().voteSquad(isPositive);
                updateisDisabled(!isDisabled);
              },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              isPositive ? Colors.green.shade700 : Colors.red.shade700),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            isPositive ? "Accept" : "Reject",
            style: const TextStyle(fontSize: 25),
          ),
        ));
  }
}

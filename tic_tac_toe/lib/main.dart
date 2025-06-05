import 'package:flutter/material.dart';

// Color scheme
const Color kPrimaryColor = Color(0xFFFFFFFF); // #ffffff
const Color kSecondaryColor = Color(0xFF222222); // #222222
const Color kAccentColor = Color(0xFF4caf50); // #4caf50

void main() {
  runApp(const TicTacToeApp());
}

/// The entry point of the TicTacToe App
// PUBLIC_INTERFACE
class TicTacToeApp extends StatelessWidget {
  /// This is a public stateless widget root for the TicTacToe application.
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe Interactive',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
        colorScheme: const ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          tertiary: kAccentColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: kSecondaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: kPrimaryColor,
            backgroundColor: kAccentColor,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const TicTacToeMainContainer(),
    );
  }
}

/// Main container for the TicTacToe game
// PUBLIC_INTERFACE
class TicTacToeMainContainer extends StatefulWidget {
  /// The main stateful widget for the TicTacToe game.
  const TicTacToeMainContainer({super.key});

  @override
  State<TicTacToeMainContainer> createState() => _TicTacToeMainContainerState();
}

enum Player { x, o }
enum GameStatus { playing, draw, win }

class _TicTacToeMainContainerState extends State<TicTacToeMainContainer> {
  // Represents the 3x3 grid as a flat list [0..8]
  List<Player?> _board = List<Player?>.filled(9, null, growable: false);

  // The current player turn (X always starts)
  Player _currentPlayer = Player.x;

  // Game outcome
  GameStatus _gameStatus = GameStatus.playing;
  Player? _winner;

  // PUBLIC_INTERFACE
  void _resetGame() {
    /// Resets the board and game state to start a new game.
    setState(() {
      _board = List<Player?>.filled(9, null, growable: false);
      _currentPlayer = Player.x;
      _gameStatus = GameStatus.playing;
      _winner = null;
    });
  }

  // PUBLIC_INTERFACE
  void _handleCellTap(int index) {
    /// Handles clicking on a cell; updates the game board and checks for game end.
    if (_board[index] != null || _gameStatus != GameStatus.playing) return;
    setState(() {
      _board[index] = _currentPlayer;
      if (_checkWin(_currentPlayer)) {
        _gameStatus = GameStatus.win;
        _winner = _currentPlayer;
      } else if (_board.every((cell) => cell != null)) {
        _gameStatus = GameStatus.draw;
      } else {
        _currentPlayer = _currentPlayer == Player.x ? Player.o : Player.x;
      }
    });
  }

  // PUBLIC_INTERFACE
  bool _checkWin(Player player) {
    /// Checks if the player has won. Returns true if they have three in a row.
    // All possible winning triplets by cell index
    const List<List<int>> winLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6]             // diagonals
    ];
    for (final line in winLines) {
      if (_board[line[0]] == player &&
          _board[line[1]] == player &&
          _board[line[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TicTacToe Interactive'),
        backgroundColor: kAccentColor,
        foregroundColor: kPrimaryColor,
        elevation: 1,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Player turn indicator
              _buildPlayerIndicator(),
              const SizedBox(height: 28),

              // 3x3 Grid
              AspectRatio(
                aspectRatio: 1,
                child: _buildBoardGrid(),
              ),
              const SizedBox(height: 28),

              // Game status
              _buildStatus(),

              const SizedBox(height: 18),

              // Reset button
              ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the player turn indicator widget
  Widget _buildPlayerIndicator() {
    if (_gameStatus == GameStatus.playing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Player ",
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            _currentPlayer == Player.x ? "X" : "O",
            style: TextStyle(
              color: kAccentColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            "'s turn",
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // Build the 3x3 board grid
  Widget _buildBoardGrid() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: Border.all(
          color: kSecondaryColor.withAlpha((0.15 * 255).toInt()),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return _buildCell(index);
        },
      ),
    );
  }

  // Build a single grid cell
  Widget _buildCell(int index) {
    final cellValue = _board[index];
    Color borderSide = kSecondaryColor.withAlpha((0.2 * 255).toInt());
    Color bgColor = kPrimaryColor;
    Widget child;

    if (cellValue == Player.x) {
      child = Text(
        "X",
        style: TextStyle(
          color: kAccentColor,
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
      );
    } else if (cellValue == Player.o) {
      child = Text(
        "O",
        style: TextStyle(
          color: kSecondaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _handleCellTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeIn,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderSide, width: 1.3),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // Build the status area: who won, draw, or playing
  Widget _buildStatus() {
    String msg;
    Color color;
    switch (_gameStatus) {
      case GameStatus.playing:
        msg = "Game in progress";
        color = kSecondaryColor.withAlpha((0.8 * 255).toInt());
        break;
      case GameStatus.win:
        msg = "Player ${_winner == Player.x ? 'X' : 'O'} wins!";
        color = kAccentColor;
        break;
      case GameStatus.draw:
        msg = "It's a draw!";
        color = kSecondaryColor.withAlpha((0.8 * 255).toInt());
        break;
    }
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 180),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      child: Text(msg, textAlign: TextAlign.center),
    );
  }
}

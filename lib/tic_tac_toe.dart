import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> _board = List.generate(9, (index) => '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe', style: TextStyle(fontSize: 28)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBoard(),
            const SizedBox(height: 20),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: _buildTile,
        itemCount: 9,
      ),
    );
  }

  Widget _buildTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: _board[index] == 'X' ? Colors.white : Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetBoard,
      child: const Text(
        'Reset',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _currentPlayer = 'X';

  void _handleTap(int index) {
    setState(() {
      if (_board[index] == '') {
        _board[index] = _currentPlayer;

        if (_checkWinner()) {
          _resetBoard();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEndGameDialog('$_currentPlayer wins!');
          });
        } else if (_isBoardFull()) {
          _resetBoard();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEndGameDialog('It\'s a tie!');
          });
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      }
    });
  }

  void _resetBoard() {
    setState(() {
      _board = List.generate(9, (index) => '');
    });
  }

  bool _checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (_board[combination[0]] != '' &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[0]] == _board[combination[2]]) {
        return true;
      }
    }
    return false;
  }

  bool _isBoardFull() {
    return !_board.contains('');
  }

  void _showEndGameDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Text(message, style: const TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('OK',
                  style: TextStyle(fontSize: 16, color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
}

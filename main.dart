import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print("Choose game mode:");
    print("1 - Two players");
    print("2 - Easy mode (Player vs Random AI)");
    print("3 - Hard mode (Player vs Unbeatable AI)");
    print("4 - Exit");
    int choice = int.parse(stdin.readLineSync()!);

    if (choice == 4) break;

    switch (choice) {
      case 1:
        playGame(humanVsHuman);
        break;
      case 2:
        playGame(humanVsEasyAI);
        break;
      case 3:
        playGame(humanVsHardAI);
        break;
      default:
        print("Invalid choice. Try again.");
    }
  }
}

void playGame(Function(List<String>, String) gameMode) {
  List<String> board = List.filled(9, ' ');
  String currentPlayer = 'X';

  while (true) {
    printBoard(board);
    gameMode(board, currentPlayer);

    String? winner = checkWinner(board);
    if (winner != null) {
      printBoard(board);
      print("Player $winner wins!");
      break;
    } else if (!board.contains(' ')) {
      printBoard(board);
      print("It's a tie!");
      break;
    }

    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}

void humanVsHuman(List<String> board, String player) {
  int move = getHumanMove(board, player);
  board[move] = player;
}

void humanVsEasyAI(List<String> board, String player) {
  if (player == 'X') {
    int move = getHumanMove(board, player);
    board[move] = player;
  } else {
    int move = getRandomMove(board);
    board[move] = player;
  }
}

void humanVsHardAI(List<String> board, String player) {
  if (player == 'X') {
    int move = getHumanMove(board, player);
    board[move] = player;
  } else {
    int move = getBestMove(board, player);
    board[move] = player;
  }
}

int getHumanMove(List<String> board, String player) {
  int move;
  while (true) {
    print("Player $player, enter your move (1-9):");
    move = int.parse(stdin.readLineSync()!) - 1;
    if (move >= 0 && move < 9 && board[move] == ' ') {
      return move;
    }
    print("Invalid move. Try again.");
  }
}

int getRandomMove(List<String> board) {
  List<int> availableMoves = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i] == ' ') availableMoves.add(i);
  }
  return availableMoves[Random().nextInt(availableMoves.length)];
}

int getBestMove(List<String> board, String player) {
  int bestScore = -9999;
  int bestMove = -1;
  for (int i = 0; i < board.length; i++) {
    if (board[i] == ' ') {
      board[i] = player;
      int score = minimax(board, 0, false, player);
      board[i] = ' ';
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }
  return bestMove;
}

int minimax(List<String> board, int depth, bool isMaximizing, String player) {
  String? result = checkWinner(board);
  if (result == player) return 10 - depth;
  if (result == (player == 'X' ? 'O' : 'X')) return depth - 10;
  if (!board.contains(' ')) return 0;

  if (isMaximizing) {
    int bestScore = -9999;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == ' ') {
        board[i] = player;
        int score = minimax(board, depth + 1, false, player);
        board[i] = ' ';
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = 9999;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == ' ') {
        board[i] = player == 'X' ? 'O' : 'X';
        int score = minimax(board, depth + 1, true, player);
        board[i] = ' ';
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}

String? checkWinner(List<String> board) {
  List<List<int>> winConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for (var condition in winConditions) {
    if (board[condition[0]] == board[condition[1]] &&
        board[condition[1]] == board[condition[2]] &&
        board[condition[0]] != ' ') {
      return board[condition[0]];
    }
  }
  return null;
}

void printBoard(List<String> board) {
  print('\n ${board[0]} | ${board[1]} | ${board[2]}');
  print('---+---+---');
  print(' ${board[3]} | ${board[4]} | ${board[5]}');
  print('---+---+---');
  print(' ${board[6]} | ${board[7]} | ${board[8]}\n');
}

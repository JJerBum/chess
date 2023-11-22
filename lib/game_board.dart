import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_methods.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // 체스판을 대표하는 2차원 리스트,
  // 체스 조각을 포함할 수 있는 각 위치가 흰색입니다
  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initializedBoard();
  }

  // The currently selected piece on the chess board,
  // If no piece is selected, this is null.
  ChessPiece? selectedPiece;

  // 선택한 말의 행 인덱스
  // 기본값은 -1이며, 현재 선택되어 있습니다.
  int selectedRow = -1;

  // 선택한 말의 열 인덱스
  // 기본값은 -1이며, 현재 선택되어 있습니다.
  int selectedCol = -1;

  // 현재 선택한 말에 대한 유효한 이동 목록
  // 각 이동은 행과 열 두 개의 요소가 있는 목록으로 표시됩니다
  List<List<int>> validMoves = [];

  // 흑인 선수가 가져간 흰색 조각 목록
  List<ChessPiece> whitePiecesTaken = [];

  // 흰색 선수가 가져간 검은색  조각 목록
  List<ChessPiece> balckPiecesTaken = [];

  // 누구 차례인지 표시하는 부울
  bool isWhiteTurn = true;

  // 왕의 위치(왕이 확인되는지 나중에 확인하기 쉽도록 이것을 추적합니다
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  // initialize board\\
  void _initializedBoard() {
    // 널(null)로 보드를 초기화합니다. 즉, 해당 위치에 조각이 없음을 의미합니다
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // newBoard[3][3] = ChessPiece(
    //   type: ChessPieceType.bishop,
    //   isWhite: true,
    //   imagePath: 'lib/images/queen.png',
    // );

    // place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'lib/images/pawn.png',
      );

      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/images/pawn.png',
      );
    }

    // place rooks
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/images/rook.png',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/images/rook.png',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/images/rook.png',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/images/rook.png',
    );

    // place knigths
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/images/knight.png',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/images/knight.png',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/images/knight.png',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/images/knight.png',
    );

    // place bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/images/bishop.png',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/images/bishop.png',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/images/bishop.png',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/images/bishop.png',
    );

    // place queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'lib/images/queen.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'lib/images/queen.png',
    );

    // place kinghs
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'lib/images/king.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'lib/images/king.png',
    );

    board = newBoard;
  }

  // USER SELECTED A PIECE
  void pieceSelected(int row, int col) {
    setState(() {
      // 아직 선택된 말이 없습니다. 첫 번째 선택입니다
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      // 이미 선택한 항목이 있지만 사용자가 선택할 수 있습니다 그들 중 다른 것을 고릅니다
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      // 그 위치에 말이 있으면 말을 선택합니다
      // if (board[row][col] != null) {
      //   selectedPiece = board[row][col];
      //   selectedRow = row;
      //   selectedCol = col;
      // }

      // if a piece is selected, calculate it's valid moves
      validMoves =
          calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);

      // 조각이 있고 사용자가 유효한 이동 수단인 정사각형을 탭하면 거기로 이동합니다
      if (selectedPiece != null &&
          validMoves.any(
            (element) => element[0] == row && element[1] == col,
          )) {
        movePiece(row, col);
      }
    });
  }

  // CALCULATE RAW VALID MOVES
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    // 후보 움직임
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    // 말의 색갈에 따른 방향
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:

        // 정사각형이 차지 중이  아닐 때 pawns은 앞으로 나아갈 수 있다.
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // pawns 은 정사각현 두 칸을 이동이 가능하다. 단, pawns이 초기화위체 있다면
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        // pawns은 대각선으로 죽일 수 있다.
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;

      case ChessPieceType.rook:
        // 수평과  수직의 방향
        var directions = [
          [-1, 0], // UP
          [1, 0], // Down
          [0, -1], // Left
          [0, 1], // Right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (isInBoard(newRow, newCol) == false) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill
              }
              break; // blacked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.knight:
        // 기사가 움직일 수 있는 8개의 L자형 모두
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // capture
            }
            continue; // block
          }
          candidateMoves.add([newRow, newCol]);
        }

        break;
      case ChessPieceType.bishop:
        // 사선 방향
        var directions = [
          [-1, -1], // up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1], // down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        // 8가지 방향 모두: 상, 하, 좌, 우, 대각선 4개 추가
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, 1], // right
          [0, -1], // left
          [-1, -1], // up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1], // down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (isInBoard(newRow, newCol) == false) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.king:
        // all eight directions
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, 1], // right
          [0, -1], // left
          [-1, -1], // up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1], // down right
          [-1, -1], // up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1], // down right
        ];

        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }

    return candidateMoves;
  }

  // Move Piece
  void movePiece(int newRow, int newCol) {
    // 새로운 장소에 적이 있다면
    if (board[newRow][newCol] != null) {
      // 캡처한 조각을 해당 목록에 추가합니다
      var capturePiece = board[newRow][newCol];
      if (capturePiece!.isWhite) {
        whitePiecesTaken.add(capturePiece);
      } else {
        balckPiecesTaken.add(capturePiece);
      }
    }

    // check if the piece being moved in a king
    if (selectedPiece!.type == ChessPieceType.king) {
      // udpate the approariate king pos
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    // 말을 옮기고 옛 자리를 정리합니다
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // see if any kings and clear the old spot
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    // check if it's check mate
    if (isCheckMate(isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("check mate!"),
          actions: [
            // play again button
            TextButton(
              onPressed: resetGame,
              child: const Text("Play again"),
            )
          ],
        ),
      );
    }

    //  change turn
    isWhiteTurn = !isWhiteTurn;
  }

  // IS KING IN CHESS?
  bool isKingInCheck(bool isWhiteKing) {
    // get the position of the king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    // check if any anemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // skip empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        // check if the king's position is in this piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }

    return false;
  }

  // CALCULATE REAL VALID MOVE
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulatiaor) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    // 모든 후보 이동을 생성한 후, 체크 결과를 초래할 모든 것을 필터링합니다
    if (checkSimulatiaor) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        // 이것은 모의실험을 할 것입니다 그것이 안전한지 알아보기 위한 미래의 움직임
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }

    return realValidMoves;
  }

  // 안전한지 알아보기 위한 미래의 움직임을 시뮬레이션해 보십시오(자신의 왕을 공격하지 마십시오!)
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    // save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    // if the piece is king, save it's current position and update to the new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      // update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    // simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    // check if our own king is under attack
    bool kingInCheck = isKingInCheck(piece.isWhite);

    // restore board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    // if the piece was the king, restore it original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    // if king is in check = true, means it's not a safe move. safe move = false
    return !kingInCheck;
  }

  // IS IT CHECKMATE?
  bool isCheckMate(bool isWhiteKing) {
    // if the king is not in check, then it's not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    // if there is at latest one legal move for any of the plyaer's pieces, then it's not checkamte
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the other color
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValideMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        // if this piece has any valid moves, then it's not checkmate
        if (pieceValideMoves.isNotEmpty) {
          return false;
        }
      }
    }

    // if none of the above conditions are met, then there are no legal moves left ot make
    // it's check mate!
    return true;
  }

  // REST TO NEW GAME
  void resetGame() {
    Navigator.pop(context);
    _initializedBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    balckPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // WITH PIECE TAKEN
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: whitePiecesTaken.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          // GAME STATUS
          Text(
            checkStatus ? "CHECK!" : "",
          ),

          // CHESS BOARD
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 8 * 8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) {
                // 이 정사각형의 행과 열 위치를 구합니다
                int row = index ~/ 8;
                int col = index % 8;

                // 이 정사각형이 선택되었는지 확인합니다.
                bool isSelected = (selectedRow == row && selectedCol == col);

                // 만약 유효한 움직임이면 체크한다.
                bool isValidMove = false;
                for (var position in validMoves) {
                  // 열과 행을 비교한다.
                  if (position[0] == row && position[1] == col) {
                    isValidMove = true;
                  }
                }

                return Square(
                  isWhite: isWhite(index),
                  piece: board[row][col],
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  onTap: () => pieceSelected(row, col),
                );
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              itemCount: balckPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: balckPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}

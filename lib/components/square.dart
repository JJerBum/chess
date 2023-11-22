import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.piece,
    required this.isWhite,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  });

  // 이 클래스(stateless widget)은 grid의 itemBuilder에 의해서 index마다 호출된다.
  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    // if selected, sqaure is green
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMove) {
      squareColor = Colors.green[300];
    }

    // 그렇지 않으면 흰색이나 검은색입니다
    else {
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}

import java.io.PrintStream;
import java.io.OutputStream;

Piece[][] currentBoard = {
  {
    new Piece(0,0,"rook",true),
    new Piece(0,1,"knight",true),
    new Piece(0,2,"bishop",true),
    new Piece(0,3,"queen",true),
    new Piece(0,4,"king",true),
    new Piece(0,5,"bishop",true),
    new Piece(0,6,"knight",true),
    new Piece(0,7,"rook",true)
  },
  {
    new Piece(1,0,"pawn",true),
    new Piece(1,1,"pawn",true),
    new Piece(1,2,"pawn",true),
    new Piece(1,3,"pawn",true),
    new Piece(1,4,"pawn",true),
    new Piece(1,5,"pawn",true),
    new Piece(1,6,"pawn",true),
    new Piece(1,7,"pawn",true)
  },
  {
    new Piece(2,0,"empty",false),
    new Piece(2,1,"empty",false),
    new Piece(2,2,"empty",false),
    new Piece(2,3,"empty",false),
    new Piece(2,4,"empty",false),
    new Piece(2,5,"empty",false),
    new Piece(2,6,"empty",false),
    new Piece(2,7,"empty",false)
  },
  {
    new Piece(3,0,"empty",false),
    new Piece(3,1,"empty",false),
    new Piece(3,2,"empty",false),
    new Piece(3,3,"empty",false),
    new Piece(3,4,"empty",false),
    new Piece(3,5,"empty",false),
    new Piece(3,6,"empty",false),
    new Piece(3,7,"empty",false)
  },
  {
    new Piece(4,0,"empty",false),
    new Piece(4,1,"empty",false),
    new Piece(4,2,"empty",false),
    new Piece(4,3,"empty",false),
    new Piece(4,4,"empty",false),
    new Piece(4,5,"empty",false),
    new Piece(4,6,"empty",false),
    new Piece(4,7,"empty",false)
  },
  {
    new Piece(5,0,"empty",false),
    new Piece(5,1,"empty",false),
    new Piece(5,2,"empty",false),
    new Piece(5,3,"empty",false),
    new Piece(5,4,"empty",false),
    new Piece(5,5,"empty",false),
    new Piece(5,6,"empty",false),
    new Piece(5,7,"empty",false)
  },
  {
    new Piece(6,0,"pawn",false),
    new Piece(6,1,"pawn",false),
    new Piece(6,2,"pawn",false),
    new Piece(6,3,"pawn",false),
    new Piece(6,4,"pawn",false),
    new Piece(6,5,"pawn",false),
    new Piece(6,6,"pawn",false),
    new Piece(6,7,"pawn",false)
  },
  {
    new Piece(7,0,"rook",false),
    new Piece(7,1,"knight",false),
    new Piece(7,2,"bishop",false),
    new Piece(7,3,"queen",false),
    new Piece(7,4,"king",false),
    new Piece(7,5,"bishop",false),
    new Piece(7,6,"knight",false),
    new Piece(7,7,"rook",false)
  }
};

//Piece[][] potentialBoard = new Piece[8][8];

Piece selectedPiece;

boolean isWhiteTurn = true;
boolean isPieceSelected = false;

void setup() {
  size(2000,2000);
  System.setErr(new PrintStream(new OutputStream() {
      public void write(int b) {
      }
  }));
}

void draw() {
  background(255);
  fill(168);
  for(int i = 0; i < 8; i++) {
    for(int j = 0; j < 8; j++) {
      if ((i+j)%2 == 0) {
        rect(i*width/8, (7-j)*height/8, width/8, height/8);
      }
    }
  }
  for(Piece[] row: currentBoard) {
    for(Piece piece: row) {
      piece.display();
    }
  }
}

void mouseReleased() {
  //println("White turn: ", isWhiteTurn);
  Piece selPiece = currentBoard[7 - (mouseY*8/height)][mouseX*8/width];
  //println(!isPieceSelected, selectedPiece == null, selectedPiece.white == isWhiteTurn);
  if (!isPieceSelected || selectedPiece == null || (!selPiece.type.equals("empty") && selPiece.white == isWhiteTurn)) {
    //println(0);
    if (!selPiece.type.equals("empty") && selPiece.white == isWhiteTurn) {
      //println(1);
      selectedPiece = selPiece;
      isPieceSelected = true;
    }
  }
  else {
    //printt(selectedPiece.pieceMoves(), null);
    //printt(null, new int[]{7 - (mouseY*8/height), mouseX*8/width});
    if (in(selectedPiece.pieceMoves(currentBoard), new int[]{7 - (mouseY*8/height), mouseX*8/width})) {
      Piece[][] potentialBoard = makePotential();
      //String selType = selectedPiece.type;
      //if castling, check to see if castle through check
      if (selectedPiece.type.equals("king") && selectedPiece.column - mouseX*8/width > 1) {
        print("you are castling left");
        Piece[][] potentialBoard2 = makePotential();
        potentialBoard2[selectedPiece.row][selectedPiece.column].type = "empty";
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column - 1].type = selectedPiece.type;
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column - 1].white = selectedPiece.white;
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column - 1].hasMoved = true;
        
        if(imInCheck(potentialBoard2)) {
          return;
        }
      }
      if (selectedPiece.type.equals("king") && mouseX*8/width - selectedPiece.column > 1) {
        Piece[][] potentialBoard2 = makePotential();
        potentialBoard2[selectedPiece.row][selectedPiece.column].type = "empty";
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column + 1].type = selectedPiece.type;
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column + 1].white = selectedPiece.white;
        potentialBoard2[7 - (mouseY*8/height)][selectedPiece.column + 1].hasMoved = true;
        
        if(imInCheck(potentialBoard2)) {
          return;
        }
      }
      potentialBoard[selectedPiece.row][selectedPiece.column].type = "empty";
      potentialBoard[7 - (mouseY*8/height)][mouseX*8/width].type = selectedPiece.type;
      potentialBoard[7 - (mouseY*8/height)][mouseX*8/width].white = selectedPiece.white;
      potentialBoard[7 - (mouseY*8/height)][mouseX*8/width].hasMoved = true;
      
      if(!imInCheck(potentialBoard)) {
        currentBoard = potentialBoard;
        isWhiteTurn = !isWhiteTurn;
        isPieceSelected = false;
        
        
        if (selectedPiece.type.equals("king") && selectedPiece.column - mouseX*8/width > 1) {
          currentBoard[selectedPiece.row][0].type = "empty";
          currentBoard[selectedPiece.row][3].type = "rook";
          currentBoard[selectedPiece.row][3].white = selectedPiece.white;
          currentBoard[selectedPiece.row][3].hasMoved = true;
        }
        if (selectedPiece.type.equals("king") && mouseX*8/width - selectedPiece.column > 1) {
          currentBoard[selectedPiece.row][7].type = "empty";
          currentBoard[selectedPiece.row][5].type = "rook";
          currentBoard[selectedPiece.row][5].white = selectedPiece.white;
          currentBoard[selectedPiece.row][5].hasMoved = true;
        }
      }
    }
  }
}

boolean imInCheck(Piece[][] board) {
  //Piece[][] board = potentialBoard != null?potentialBoard:currentBoard;
  
  //println(board[2][2]);
  for(Piece[] row: board)
    for(Piece piece: row)
      if (!piece.type.equals("empty") && piece.white != isWhiteTurn)
        for(int[] location: piece.pieceMoves(board)) 
          if (board[location[0]][location[1]].type.equals("king")) return true;
  
  return false;
}

void printt(ArrayList<int[]> aL, int[] a) {
  if (aL != null) for(int[] ints: aL) printt(null, ints);
  else println("[" + a[0] + ", " + a[1] + "]");
}

boolean in(ArrayList<int[]> aL, int[] a) {//because why not
  for(int[] ints: aL) {
    if (ints[0] == a[0] && ints[1] == a[1]) return true;
  }
  return false;
}

Piece[][] makePotential() {
  Piece[][] potential = new Piece[8][8];
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      potential[i][j] = new Piece(currentBoard[i][j]);
    }
  }
  return potential;
}

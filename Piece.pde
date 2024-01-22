class Piece {
  String type;
  int row, column;
  boolean white;
  boolean hasMoved = false;
  
  Piece(int row, int column, String type, boolean white) {
    this.row = row;
    this.column = column;
    this.type = type;
    this.white = white;
  }
  
  Piece(Piece clone) {
    this.row = clone.row;
    this.column = clone.column;
    this.type = clone.type;
    this.white = clone.white;
    this.hasMoved = clone.hasMoved;
  }
  
  void display() {
    if (type == "empty") return;
    if (type == "pawn" && white && row == 7) type = "queen";
    if (type == "pawn" && !white && row == 0) type = "queen";
    shape(loadShape(type+"_"+(white?"White":"Black")+".svg"), column*height/8, (7-row)*width/8, height/8, width/8);
  }
  
  ArrayList<int[]> pieceMoves(Piece[][] board) {
    ArrayList<int[]> ret = new ArrayList<int[]>();
      if (type.equals("pawn")) {
        if (white) {
          if (row == 1) ret.add(new int[]{row + 2, column});
          if (row != 7) ret.add(new int[]{row + 1, column});
          if (row < 7 && column > 0) {
            Piece attackablePiece = board[row + 1][column-1];
            if (!attackablePiece.type.equals("empty") && !attackablePiece.white) ret.add(new int[] {row+1, column-1});
          }
          if (row < 7 && column < 7) {
            Piece attackablePiece = board[row + 1][column+1];
            if (!attackablePiece.type.equals("empty") && !attackablePiece.white) ret.add(new int[] {row+1, column+1});
          }
        }
        else {
          if (row == 6) ret.add(new int[]{row - 2, column});
          if (row != 0) ret.add(new int[]{row - 1, column});
          if (row > 0 && column > 0) {
            Piece attackablePiece = board[row - 1][column-1];
            if (!attackablePiece.type.equals("empty") && attackablePiece.white) ret.add(new int[] {row-1, column-1});
          }
          if (row > 0 && column < 7) {
            Piece attackablePiece = board[row - 1][column+1];
            if (!attackablePiece.type.equals("empty") && attackablePiece.white) ret.add(new int[] {row-1, column+1});
          }
        }
      }
      else if (type.equals("rook")) {
        int i = 1;
        while (true) {//left
          if (column-i < 0) break;
          if (!board[row][column-i].type.equals("empty") && board[row][column-i].white == white) break;
          ret.add(new int[]{row, column-i});
          if (!board[row][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//right
          if (column+i > 7) break;
          if (!board[row][column+i].type.equals("empty") && board[row][column+i].white == white) break;
          ret.add(new int[]{row, column+i});
          if (!board[row][column+i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//up
          if (row+i > 7) break;
          if (!board[row+i][column].type.equals("empty") && board[row+i][column].white == white) break;
          ret.add(new int[]{row+i, column});
          if (!board[row+i][column].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//down
          if (row-i < 0) break;
          if (!board[row-i][column].type.equals("empty") && board[row-i][column].white == white) break;
          ret.add(new int[]{row-i, column});
          if (!board[row-i][column].type.equals("empty")) break;
          i++;
        }
      }
      else if (type.equals("bishop")) {
        int i = 1;
        while (true) {//downleft
          if (column-i < 0 || row-i < 0) break;
          if (!board[row-i][column-i].type.equals("empty") && board[row-i][column-i].white == white) break;
          ret.add(new int[]{row-i, column-i});
          if (!board[row-i][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//downright
          if (column+i > 7 || row-i < 0) break;
          if (!board[row-i][column+i].type.equals("empty") && board[row-i][column+i].white == white) break;
          ret.add(new int[]{row-i, column+i});
          //println("eh?", !board[row-i][column+i].type.equals("empty"));
          if (!board[row-i][column+i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//upleft
          if (column-i < 0 || row+i > 7) break;
          if (!board[row+i][column-i].type.equals("empty") && board[row+i][column-i].white == white) break;
          ret.add(new int[]{row+i, column-i});
          if (!board[row+i][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//upright
          if (column+i > 7 || row+i > 7) break;
          if (!board[row+i][column+i].type.equals("empty") && board[row+i][column+i].white == white) break;
          ret.add(new int[]{row+i, column+i});
          if (!board[row+i][column+i].type.equals("empty")) break;
          i++;
        }
      }
      else if (type.equals("knight")){
        if(column > 1 && row > 0 && (board[row-1][column-2].type.equals("empty") || board[row-1][column-2].white != white)) //leftleftdown
          ret.add(new int[]{row-1, column-2});
        if(column > 0 && row > 1 && (board[row-2][column-1].type.equals("empty") || board[row-2][column-1].white != white)) //leftdowndown
          ret.add(new int[]{row-2, column-1});
        if(column < 7 && row > 1 && (board[row-2][column+1].type.equals("empty") || board[row-2][column+1].white != white)) //rightdowndown
          ret.add(new int[]{row-2, column+1});
        if(column < 6 && row > 0 && (board[row-1][column+2].type.equals("empty") || board[row-1][column+2].white != white)) //rightrightdown
          ret.add(new int[]{row-1, column+2});
        if(column < 6 && row < 7 && (board[row+1][column+2].type.equals("empty") || board[row+1][column+2].white != white)) //rightrightup
          ret.add(new int[]{row+1, column+2});
        if(column < 7 && row < 6 && (board[row+2][column+1].type.equals("empty") || board[row+2][column+1].white != white)) //rightupup
          ret.add(new int[]{row+2, column+1});
        if(column > 0 && row < 6 && (board[row+2][column-1].type.equals("empty") || board[row+2][column-1].white != white)) //leftupup
          ret.add(new int[]{row+2, column-1});
        if(column > 1 && row < 7 && (board[row+1][column-2].type.equals("empty") || board[row+1][column-2].white != white)) //leftleftup
          ret.add(new int[]{row+1, column-2});
      }
      else if (type.equals("queen")) {
        int i = 1;
        while (true) {//left
          if (column-i < 0) break;
          if (!board[row][column-i].type.equals("empty") && board[row][column-i].white == white) break;
          ret.add(new int[]{row, column-i});
          if (!board[row][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//right
          if (column+i > 7) break;
          if (!board[row][column+i].type.equals("empty") && board[row][column+i].white == white) break;
          ret.add(new int[]{row, column+i});
          if (!board[row][column+i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//up
          if (row+i > 7) break;
          if (!board[row+i][column].type.equals("empty") && board[row+i][column].white == white) break;
          ret.add(new int[]{row+i, column});
          if (!board[row+i][column].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//down
          if (row-i < 0) break;
          if (!board[row-i][column].type.equals("empty") && board[row-i][column].white == white) break;
          ret.add(new int[]{row-i, column});
          if (!board[row-i][column].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//downleft
          if (column-i < 0 || row-i < 0) break;
          if (!board[row-i][column-i].type.equals("empty") && board[row-i][column-i].white == white) break;
          ret.add(new int[]{row-i, column-i});
          if (!board[row-i][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//downright
          if (column+i > 7 || row-i < 0) break;
          if (!board[row-i][column+i].type.equals("empty") && board[row-i][column+i].white == white) break;
          ret.add(new int[]{row-i, column+i});
          if (!board[row-i][column+i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//upleft
          if (column-i < 0 || row+i > 7) break;
          if (!board[row+i][column-i].type.equals("empty") && board[row+i][column-i].white == white) break;
          ret.add(new int[]{row+i, column-i});
          if (!board[row+i][column-i].type.equals("empty")) break;
          i++;
        }
        i = 1;
        while (true) {//upright
          if (column+i > 7 || row+i > 7) break;
          if (!board[row+i][column+i].type.equals("empty") && board[row+i][column+i].white == white) break;
          ret.add(new int[]{row+i, column+i});
          if (!board[row+i][column+i].type.equals("empty")) break;
          i++;
        }
      }
      else if (type.equals("king")) {
        //left
        if (column > 0 && (board[row][column-1].type.equals("empty") || board[row][column-1].white != white))
          ret.add(new int[]{row, column-1});
        //leftdown
        if (column > 0 && row > 0 && (board[row-1][column-1].type.equals("empty") || board[row-1][column-1].white != white))
          ret.add(new int[]{row-1, column-1});
        //down
        if (row > 0 && (board[row-1][column].type.equals("empty") || board[row-1][column].white != white))
          ret.add(new int[]{row-1, column});
        //rightdown
        if (column < 7 && row > 0 && (board[row-1][column+1].type.equals("empty") || board[row-1][column+1].white != white))
          ret.add(new int[]{row-1, column+1});
        //right
        if (column < 7 && (board[row][column+1].type.equals("empty") || board[row][column+1].white != white))
          ret.add(new int[]{row, column+1});
        //rightup
        if (column < 7 && row < 7 && (board[row+1][column+1].type.equals("empty") || board[row+1][column+1].white != white))
          ret.add(new int[]{row+1, column+1});
        //up
        if (row < 7 && (board[row+1][column].type.equals("empty") || board[row+1][column].white != white))
          ret.add(new int[]{row+1, column});
        //leftup
        if (column > 0 && row < 7 && (board[row+1][column-1].type.equals("empty") || board[row+1][column-1].white != white))
          ret.add(new int[]{row+1, column-1});
        if (!hasMoved && white && !board[0][0].hasMoved && board[0][1].type.equals("empty") && board[0][2].type.equals("empty") && board[0][3].type.equals("empty")) ret.add(new int[]{0,2});
        if (!hasMoved && !white && !board[7][0].hasMoved && board[7][1].type.equals("empty") && board[7][2].type.equals("empty") && board[7][3].type.equals("empty")) ret.add(new int[]{7,2});
        if (!hasMoved && white && !board[0][7].hasMoved && board[0][6].type.equals("empty") && board[0][5].type.equals("empty")) ret.add(new int[]{0,6});
        if (!hasMoved && !white && !board[7][7].hasMoved && board[7][6].type.equals("empty") && board[7][5].type.equals("empty")) ret.add(new int[]{7,6});
      }
      return ret;
    }
    
    String toString() {
      return "Row: " + row+", Column: "+column+", Type: "+type+", IsWhite: "+white;
    }
}

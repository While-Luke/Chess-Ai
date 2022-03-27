//each turn, after player makes a turn, check for checkmate + stalemate, check for check, then ai starts //<>//
//first check for forced checkmate, then check for forced loss and how to stop it, then check for piece values after each move
//how to label each move: dict[3]("l1" "n1" "l2" "n2" "value")
//how to find best move: check value at the end of every sequence, find what is the lowest value that can occur for each first move and pick the highest one


int[][] white_pieces; //0 = nothing, 1 = pawn, 3 = knight, 4 = bishop, 5 = rook, 9 = queen, 2 = king
int[][] black_pieces;

PImage white_pawn;
PImage white_rook;
PImage white_knight;
PImage white_bishop;
PImage white_queen;
PImage white_king;

PImage black_pawn;
PImage black_rook;
PImage black_knight;
PImage black_bishop;
PImage black_queen;
PImage black_king;

int chosenx, choseny;
boolean mouse_held = false;
int piece_held;
int alt_piece_held;
int taken_piece;
int[][] possible_moves;
int counter;
int moving_x, moving_y;

int black_en_passant = 100;
int white_en_passant = 100;

boolean white_promoting = false;
boolean black_promoting = false;

boolean white_king_moved = false;
boolean white_rook1_moved = false;
boolean white_rook2_moved = false;
boolean black_king_moved = false;
boolean black_rook1_moved = false;
boolean black_rook2_moved = false;

boolean white_in_check = false;
boolean black_in_check = false;

boolean white_wins = false;
boolean black_wins = false;

void setup() {
  size(1000, 1000);
  ellipseMode(CENTER);

  white_pawn = loadImage("white_pawn.png");
  white_rook = loadImage("white_rook.png");
  white_knight = loadImage("white_knight.png");
  white_bishop = loadImage("white_bishop.png");
  white_queen = loadImage("white_queen.png");
  white_king = loadImage("white_king.png");

  black_pawn = loadImage("black_pawn.png");
  black_rook = loadImage("black_rook.png");
  black_knight = loadImage("black_knight.png");
  black_bishop = loadImage("black_bishop.png");
  black_queen = loadImage("black_queen.png");
  black_king = loadImage("black_king.png");

  white_pieces = new int[8][8];
  black_pieces = new int[8][8];
  possible_moves = new int[8][8];

  for (int i = 0; i < 8; i++) {//place the pawns
    white_pieces[i][1] = 1;
    black_pieces[i][6] = 1;
  }

  white_pieces[0][0] = 5;//place the rest of whites pieces
  white_pieces[7][0] = 5;
  white_pieces[1][0] = 3;
  white_pieces[6][0] = 3;
  white_pieces[2][0] = 4;
  white_pieces[5][0] = 4;
  white_pieces[3][0] = 9;
  white_pieces[4][0] = 2;

  black_pieces[0][7] = 5;//place the rest of whites pieces
  black_pieces[7][7] = 5;
  black_pieces[1][7] = 3;
  black_pieces[6][7] = 3;
  black_pieces[2][7] = 4;
  black_pieces[5][7] = 4;
  black_pieces[3][7] = 9;
  black_pieces[4][7] = 2;
  
  
  //ai_turn();
  //println(millis());
}

void draw() {
  background(100);
  translate(100, 100);

  for (int i = 0; i < 8; i++) { 
    for (int j = 0; j < 8; j++) {
      if ((i + j) % 2 == 0) { //create the board
        fill(118, 150, 86);
      } else {
        fill(238, 238, 210);
      }
      if (i == chosenx && j == choseny) {
        fill(255);
      }
      square(i*100, 700 - j*100, 100);

      switch(white_pieces[i][j]) { //show white pieces
        case(1):
        image(white_pawn, i*100, 700 - j*100);
        break;

        case(5):
        image(white_rook, i*100, 700 - j*100);
        break;

        case(3):
        image(white_knight, i*100, 700 - j*100);
        break;

        case(4):
        image(white_bishop, i*100, 700 - j*100);
        break;

        case(9):
        image(white_queen, i*100, 700 - j*100);
        break;

        case(2):
        image(white_king, i*100, 700 - j*100);
        break;
      }
      switch(black_pieces[i][j]) { //show black pieces
        case(1):
        image(black_pawn, i*100, 700 - j*100);
        break;

        case(5):
        image(black_rook, i*100, 700 - j*100);
        break;

        case(3):
        image(black_knight, i*100, 700 - j*100);
        break;

        case(4):
        image(black_bishop, i*100, 700 - j*100);
        break;

        case(9):
        image(black_queen, i*100, 700 - j*100);
        break;

        case(2):
        image(black_king, i*100, 700 - j*100);
        break;
      }

      if (mouse_held && possible_moves[i][j] == 1) {
        fill(100);
        circle(i * 100 + 50, 750 - j*100, 30); //show possible moves
      }
    }
  }

  fill(255);
  if (white_promoting) { //show if pawn is promoting
    rect((moving_x + 1) * 100, 0, 100, 400);
    image(white_queen, (moving_x + 1) * 100, 0);
    image(white_rook, (moving_x + 1) * 100, 100);
    image(white_bishop, (moving_x + 1) * 100, 200);
    image(white_knight, (moving_x + 1) * 100, 300);
  }
  if (black_promoting) {
    rect((moving_x + 1) * 100, 400, 100, 400);
    image(black_queen, (moving_x + 1) * 100, 400);
    image(black_rook, (moving_x + 1) * 100, 500);
    image(black_bishop, (moving_x + 1) * 100, 600);
    image(black_knight, (moving_x + 1) * 100, 700);
  }


  fill(0);
  textSize(20); //show coordinates of the board
  text("A", 45, 825);
  text("B", 145, 825);
  text("C", 245, 825);
  text("D", 345, 825);
  text("E", 445, 825);
  text("F", 545, 825);
  text("G", 645, 825);
  text("H", 745, 825);

  text("8", -25, 50);
  text("7", -25, 150);
  text("6", -25, 250);
  text("5", -25, 350);
  text("4", -25, 450);
  text("3", -25, 550);
  text("2", -25, 650);
  text("1", -25, 750);


  if (white_in_check && !black_wins) { //show if in check
    fill(255);
    textSize(50);
    text("CHECK", 300, 850);
  }
  if (black_in_check && !white_wins) {
    fill(0);
    textSize(50);
    text("CHECK", 300, -25);
  }

  if ((black_wins && !white_in_check) || (white_wins && !black_in_check)) {
    fill(255, 0, 0);
    textSize(60);
    text("Stalemate!", 220, 370);
    text("Its a Draw", 220, 470);
  } else if (black_wins) {
    fill(255, 0, 0);
    textSize(60);
    text("Checkmate!", 220, 370);
    text("Black Wins", 220, 470);
  } else if (white_wins) {
    fill(255, 0, 0);
    textSize(60);
    text("Checkmate!", 220, 370);
    text("White Wins", 220, 470);
  }
}


void keyReleased() {
  if (white_wins || black_wins) { //restart the game
    white_pieces = new int[8][8];
    black_pieces = new int[8][8];

    for (int i = 0; i < 8; i++) {//place the pawns
      white_pieces[i][1] = 1;
      black_pieces[i][6] = 1;
    }

    white_pieces[0][0] = 5;//place the rest of whites pieces
    white_pieces[7][0] = 5;
    white_pieces[1][0] = 3;
    white_pieces[6][0] = 3;
    white_pieces[2][0] = 4;
    white_pieces[5][0] = 4;
    white_pieces[3][0] = 9;
    white_pieces[4][0] = 2;

    black_pieces[0][7] = 5;//place the rest of whites pieces
    black_pieces[7][7] = 5;
    black_pieces[1][7] = 3;
    black_pieces[6][7] = 3;
    black_pieces[2][7] = 4;
    black_pieces[5][7] = 4;
    black_pieces[3][7] = 9;
    black_pieces[4][7] = 2;

    black_en_passant = 100;
    white_en_passant = 100;

    white_promoting = false;
    black_promoting = false;

    white_king_moved = false;
    white_rook1_moved = false;
    white_rook2_moved = false;
    black_king_moved = false;
    black_rook1_moved = false;
    black_rook2_moved = false;

    white_in_check = false;
    black_in_check = false;

    white_wins = false;
    black_wins = false;
  }
}


void mousePressed() {
  if (!mouse_held && !white_promoting && !black_promoting) {
    if (mouseX > 100 && mouseX < 900 && mouseY > 100 && mouseY < 900) { //chose a piece
      possible_moves = new int[8][8];
      chosenx = mouseX/100 - 1;
      choseny = 8 - mouseY/100;
      if (white_pieces[(mouseX/100)-1][8 - mouseY/100] != 0) {
        find_whites_moves();
      }
    }
    mouse_held = true;
  }
}

void mouseReleased() {
  mouse_held = false;
  if (white_promoting) { //promoting a pawn
    if (mouseX > (moving_x + 2) * 100 && mouseX < (moving_x + 3) * 100 && mouseY > 100 && mouseY < 500) {
      switch(mouseY / 100) {
        case(1):
        white_pieces[moving_x][moving_y] = 9;
        break;

        case(2):
        white_pieces[moving_x][moving_y] = 5;
        break;

        case(3):
        white_pieces[moving_x][moving_y] = 4;
        break;

        case(4):
        white_pieces[moving_x][moving_y] = 3;
        break;
      }
      white_promoting = false;

      if (white_check_check()) {
        black_in_check = true;
      }

      black_check_checkmate();

      if (!white_wins) {
        ai_turn();
      }
    }
  } else {
    if (mouseX > 100 && mouseX < 900 && mouseY > 100 && mouseY < 900) { //moves chosen piece
      moving_x = (mouseX/100)-1;
      moving_y = 8 - mouseY/100;
      if (possible_moves[moving_x][moving_y] == 1) {
        white_pieces[moving_x][moving_y] = piece_held;
        white_pieces[chosenx][choseny] = 0;
        black_pieces[moving_x][moving_y] = 0;

        if (piece_held == 1 && choseny == 1 && moving_y == 3) {//checks for en passant
          white_en_passant = chosenx;
        }
        if (piece_held == 1 && moving_y == 5 && black_pieces[moving_x][moving_y] == 0 && black_pieces[moving_x][moving_y - 1] == 1) {
          black_pieces[moving_x][moving_y - 1] = 0;
        }

        if (piece_held == 1 && moving_y == 7) {//check for promotion
          white_promoting = true;
        }


        if (!white_rook1_moved && !white_king_moved && piece_held == 2 && moving_x == 2 && moving_y == 0) {//checks for castling
          white_pieces[0][0] = 0;
          white_pieces[3][0] = 5;
        }
        if (!white_rook2_moved && !white_king_moved && piece_held == 2 && moving_x == 6 && moving_y == 0) {
          white_pieces[7][0] = 0;
          white_pieces[5][0] = 5;
        }
        if (piece_held == 2) { 
          white_king_moved = true;
        }
        if (!white_rook1_moved && piece_held == 5 && chosenx == 0 && choseny == 0) {
          white_rook1_moved = true;
        }
        if (!white_rook2_moved && piece_held == 5 && chosenx == 7 && choseny == 0) {
          white_rook2_moved = true;
        }


        if (white_check_check()) {
          black_in_check = true;
        }

        black_check_checkmate();

        white_in_check = false;
        black_en_passant = 100;

        if (!white_wins && !white_promoting) {
          ai_turn();
          white_check_checkmate();
        }
      }
    }
  }
}


boolean white_check_check() { //check if black is in check
  for (int a = 0; a < 8; a++) {
    for (int b = 0; b < 8; b++) {
      if (white_pieces[a][b] != 0) {
        alt_piece_held = white_pieces[a][b];

        switch(alt_piece_held) { 
          case(1):
          if (b < 7 && a > 0 && black_pieces[a - 1][b + 1] == 2) {
            return true;
          }
          if (b < 7 && a < 7 && black_pieces[a + 1][b + 1] == 2) {
            return true;
          }
          break;

          case(5):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && white_pieces[a - counter][b] == 0 && black_pieces[a - counter][b] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && black_pieces[a - counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && white_pieces[a + counter][b] == 0 && black_pieces[a + counter][b] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && black_pieces[a + counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b - counter >= 0 && white_pieces[a][b - counter] == 0 && black_pieces[a][b - counter] == 0) {
              counter++;
            } else {
              if (b - counter >= 0 && black_pieces[a][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b + counter <= 7 && white_pieces[a][b + counter] == 0 && black_pieces[a][b + counter] == 0) {
              counter++;
            } else {
              if (b + counter <= 7 && black_pieces[a][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(3):
          for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
              if ((abs(a - i) == 1 && abs(b - j) == 2) ^ (abs(a - i) == 2 && abs(b - j) == 1)) {
                if (black_pieces[i][j] == 2) {
                  return true;
                }
              }
            }
          }
          break;

          case(4):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && b - counter >= 0 && white_pieces[a - counter][b - counter] == 0 && black_pieces[a - counter][b- counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b - counter >= 0  && black_pieces[a - counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b - counter >= 0 && white_pieces[a + counter][b - counter] == 0 && black_pieces[a + counter][b - counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b - counter >= 0 && black_pieces[a + counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b + counter <= 7 && white_pieces[a + counter][b + counter] == 0 && black_pieces[a + counter][b + counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b + counter <= 7 && black_pieces[a + counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a - counter >= 0 && b + counter <= 7 && white_pieces[a - counter][b + counter] == 0 && black_pieces[a - counter][b + counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b + counter <= 7 && black_pieces[a - counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(9):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && white_pieces[a - counter][b] == 0 && black_pieces[a - counter][b] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && black_pieces[a - counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && white_pieces[a + counter][b] == 0 && black_pieces[a + counter][b] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && black_pieces[a + counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b - counter >= 0 && white_pieces[a][b - counter] == 0 && black_pieces[a][b - counter] == 0) {
              counter++;
            } else {
              if (b - counter >= 0 && black_pieces[a][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b + counter <= 7 && white_pieces[a][b + counter] == 0 && black_pieces[a][b + counter] == 0) {
              counter++;
            } else {
              if (b + counter <= 7 && black_pieces[a][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          counter = 1;
          while (true) {
            if (a - counter >= 0 && b - counter >= 0 && white_pieces[a - counter][b - counter] == 0 && black_pieces[a - counter][b- counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b - counter >= 0  && black_pieces[a - counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b - counter >= 0 && white_pieces[a + counter][b - counter] == 0 && black_pieces[a + counter][b - counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b - counter >= 0 && black_pieces[a + counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b + counter <= 7 && white_pieces[a + counter][b + counter] == 0 && black_pieces[a + counter][b + counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b + counter <= 7 && black_pieces[a + counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a - counter >= 0 && b + counter <= 7 && white_pieces[a - counter][b + counter] == 0 && black_pieces[a - counter][b + counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b + counter <= 7 && black_pieces[a - counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(2):
          for (int i = -1; i < 2; i++) {
            for (int j = -1; j < 2; j++) {
              if (a + i >= 0 && a + i <= 7 && b + j >= 0 && b + j <= 7) {
                if (!(i == 0 && j == 0) && black_pieces[a + i][b + j] == 2) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
  }
  return false;
}


boolean black_check_check() { //check if white is in check
  for (int a = 0; a < 8; a++) {
    for (int b = 0; b < 8; b++) {
      if (black_pieces[a][b] != 0) {
        alt_piece_held = black_pieces[a][b];

        switch(alt_piece_held) { 
          case(1):
          if (b > 0 && a > 0 && white_pieces[a - 1][b - 1] == 2) {
            return true;
          }
          if (b > 0 && a < 7 && white_pieces[a + 1][b - 1] == 2) {
            return true;
          }
          break;

          case(5):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && black_pieces[a - counter][b] == 0 && white_pieces[a - counter][b] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && white_pieces[a - counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && black_pieces[a + counter][b] == 0 && white_pieces[a + counter][b] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && white_pieces[a + counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b - counter >= 0 && black_pieces[a][b - counter] == 0 && white_pieces[a][b - counter] == 0) {
              counter++;
            } else {
              if (b - counter >= 0 && white_pieces[a][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b + counter <= 7 && black_pieces[a][b + counter] == 0 && white_pieces[a][b + counter] == 0) {
              counter++;
            } else {
              if (b + counter <= 7 && white_pieces[a][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(3):
          for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
              if ((abs(a - i) == 1 && abs(b - j) == 2) ^ (abs(a - i) == 2 && abs(b - j) == 1)) {
                if (white_pieces[i][j] == 2) {
                  return true;
                }
              }
            }
          }
          break;

          case(4):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && b - counter >= 0 && black_pieces[a - counter][b - counter] == 0 && white_pieces[a - counter][b- counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b - counter >= 0  && white_pieces[a - counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b - counter >= 0 && black_pieces[a + counter][b - counter] == 0 && white_pieces[a + counter][b - counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b - counter >= 0 && white_pieces[a + counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b + counter <= 7 && black_pieces[a + counter][b + counter] == 0 && white_pieces[a + counter][b + counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b + counter <= 7 && white_pieces[a + counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a - counter >= 0 && b + counter <= 7 && black_pieces[a - counter][b + counter] == 0 && white_pieces[a - counter][b + counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b + counter <= 7 && white_pieces[a - counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(9):
          counter = 1;
          while (true) {
            if (a - counter >= 0 && black_pieces[a - counter][b] == 0 && white_pieces[a - counter][b] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && white_pieces[a - counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && black_pieces[a + counter][b] == 0 && white_pieces[a + counter][b] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && white_pieces[a + counter][b] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b - counter >= 0 && black_pieces[a][b - counter] == 0 && white_pieces[a][b - counter] == 0) {
              counter++;
            } else {
              if (b - counter >= 0 && white_pieces[a][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (b + counter <= 7 && black_pieces[a][b + counter] == 0 && white_pieces[a][b + counter] == 0) {
              counter++;
            } else {
              if (b + counter <= 7 && white_pieces[a][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          counter = 1;
          while (true) {
            if (a - counter >= 0 && b - counter >= 0 && black_pieces[a - counter][b - counter] == 0 && white_pieces[a - counter][b- counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b - counter >= 0  && white_pieces[a - counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b - counter >= 0 && black_pieces[a + counter][b - counter] == 0 && white_pieces[a + counter][b - counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b - counter >= 0 && white_pieces[a + counter][b - counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a + counter <= 7 && b + counter <= 7 && black_pieces[a + counter][b + counter] == 0 && white_pieces[a + counter][b + counter] == 0) {
              counter++;
            } else {
              if (a + counter <= 7 && b + counter <= 7 && white_pieces[a + counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }

          counter = 1;
          while (true) {
            if (a - counter >= 0 && b + counter <= 7 && black_pieces[a - counter][b + counter] == 0 && white_pieces[a - counter][b + counter] == 0) {
              counter++;
            } else {
              if (a - counter >= 0 && b + counter <= 7 && white_pieces[a - counter][b + counter] == 2) {
                return true;
              }
              break;
            }
          }
          break;

          case(2):
          for (int i = -1; i < 2; i++) {
            for (int j = -1; j < 2; j++) {
              if (a + i >= 0 && a + i <= 7 && b + j >= 0 && b + j <= 7) {
                if (!(i == 0 && j == 0) && white_pieces[a + i][b + j] == 2) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
  }
  return false;
}


void white_check_checkmate() { //check if white is in checkmate
  black_wins = true;
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      if (white_pieces[x][y] != 0) {
        possible_moves = new int[8][8];
        chosenx = x;
        choseny = y;

        find_whites_moves();

        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            if (possible_moves[i][j] == 1) {
              black_wins = false;
              break;
            }
          }
          if (!black_wins) {
            break;
          }
        }
      }
      if (!black_wins) {
        break;
      }
    }
    if (!black_wins) {
      break;
    }
  }
}


void black_check_checkmate() { //check if black is in checkmate
  white_wins = true;
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      if (black_pieces[x][y] != 0) {
        possible_moves = new int[8][8];
        chosenx = x;
        choseny = y;

        find_blacks_moves();

        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            if (possible_moves[i][j] == 1) {
              white_wins = false;
              break;
            }
          }
          if (!white_wins) {
            break;
          }
        }
      }
      if (!white_wins) {
        break;
      }
    }
    if (!white_wins) {
      break;
    }
  }
}


void find_whites_moves() {
  piece_held = white_pieces[chosenx][choseny];

  switch(piece_held) { //find possible moves for each piece
    case(1):
    if (choseny == 1 && white_pieces[chosenx][2] == 0 && black_pieces[chosenx][2] == 0 && white_pieces[chosenx][3] == 0 && black_pieces[chosenx][3] == 0) {
      possible_moves[chosenx][3] = 1;
    }
    if (choseny < 7 && white_pieces[chosenx][choseny+1] == 0 && black_pieces[chosenx][choseny+1] == 0) {
      possible_moves[chosenx][choseny+1] = 1;
    }
    if (choseny < 7 && chosenx > 0 && black_pieces[chosenx - 1][choseny + 1] != 0) {
      possible_moves[chosenx-1][choseny+1] = 1;
    }
    if (choseny < 7 && chosenx < 7 && black_pieces[chosenx + 1][choseny + 1] != 0) {
      possible_moves[chosenx+1][choseny+1] = 1;
    }

    if (black_en_passant < 50 && choseny == 4 && abs(chosenx - black_en_passant) == 1 && black_pieces[black_en_passant][4] == 1) {
      possible_moves[black_en_passant][5] = 1;
    }
    break;

    case(5):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && white_pieces[chosenx - counter][choseny] == 0 && black_pieces[chosenx - counter][choseny] == 0) {
        possible_moves[chosenx - counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && black_pieces[chosenx - counter][choseny] != 0) {
          possible_moves[chosenx - counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && white_pieces[chosenx + counter][choseny] == 0 && black_pieces[chosenx + counter][choseny] == 0) {
        possible_moves[chosenx + counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && black_pieces[chosenx + counter][choseny] != 0) {
          possible_moves[chosenx + counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny - counter >= 0 && white_pieces[chosenx][choseny - counter] == 0 && black_pieces[chosenx][choseny - counter] == 0) {
        possible_moves[chosenx][choseny - counter] = 1;
        counter++;
      } else {
        if (choseny - counter >= 0 && black_pieces[chosenx][choseny - counter] != 0) {
          possible_moves[chosenx][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny + counter <= 7 && white_pieces[chosenx][choseny + counter] == 0 && black_pieces[chosenx][choseny + counter] == 0) {
        possible_moves[chosenx][choseny + counter] = 1;
        counter++;
      } else {
        if (choseny + counter <= 7 && black_pieces[chosenx][choseny + counter] != 0) {
          possible_moves[chosenx][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(3):
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((abs(chosenx - i) == 1 && abs(choseny - j) == 2) ^ (abs(chosenx - i) == 2 && abs(choseny - j) == 1)) {
          if (white_pieces[i][j] == 0) {
            possible_moves[i][j] = 1;
          }
        }
      }
    }
    break;

    case(4):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny - counter >= 0 && white_pieces[chosenx - counter][choseny - counter] == 0 && black_pieces[chosenx - counter][choseny- counter] == 0) {
        possible_moves[chosenx - counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny - counter >= 0  && black_pieces[chosenx - counter][choseny - counter] != 0) {
          possible_moves[chosenx - counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny - counter >= 0 && white_pieces[chosenx + counter][choseny - counter] == 0 && black_pieces[chosenx + counter][choseny - counter] == 0) {
        possible_moves[chosenx + counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny - counter >= 0 && black_pieces[chosenx + counter][choseny - counter] != 0) {
          possible_moves[chosenx + counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny + counter <= 7 && white_pieces[chosenx + counter][choseny + counter] == 0 && black_pieces[chosenx + counter][choseny + counter] == 0) {
        possible_moves[chosenx + counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny + counter <= 7 && black_pieces[chosenx + counter][choseny + counter] != 0) {
          possible_moves[chosenx + counter][choseny + counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny + counter <= 7 && white_pieces[chosenx - counter][choseny + counter] == 0 && black_pieces[chosenx - counter][choseny + counter] == 0) {
        possible_moves[chosenx - counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny + counter <= 7 && black_pieces[chosenx - counter][choseny + counter] != 0) {
          possible_moves[chosenx - counter][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(9):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && white_pieces[chosenx - counter][choseny] == 0 && black_pieces[chosenx - counter][choseny] == 0) {
        possible_moves[chosenx - counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && black_pieces[chosenx - counter][choseny] != 0) {
          possible_moves[chosenx - counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && white_pieces[chosenx + counter][choseny] == 0 && black_pieces[chosenx + counter][choseny] == 0) {
        possible_moves[chosenx + counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && black_pieces[chosenx + counter][choseny] != 0) {
          possible_moves[chosenx + counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny - counter >= 0 && white_pieces[chosenx][choseny - counter] == 0 && black_pieces[chosenx][choseny - counter] == 0) {
        possible_moves[chosenx][choseny - counter] = 1;
        counter++;
      } else {
        if (choseny - counter >= 0 && black_pieces[chosenx][choseny - counter] != 0) {
          possible_moves[chosenx][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny + counter <= 7 && white_pieces[chosenx][choseny + counter] == 0 && black_pieces[chosenx][choseny + counter] == 0) {
        possible_moves[chosenx][choseny + counter] = 1;
        counter++;
      } else {
        if (choseny + counter <= 7 && black_pieces[chosenx][choseny + counter] != 0) {
          possible_moves[chosenx][choseny + counter] = 1;
        }
        break;
      }
    }
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny - counter >= 0 && white_pieces[chosenx - counter][choseny - counter] == 0 && black_pieces[chosenx - counter][choseny- counter] == 0) {
        possible_moves[chosenx - counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny - counter >= 0  && black_pieces[chosenx - counter][choseny - counter] != 0) {
          possible_moves[chosenx - counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny - counter >= 0 && white_pieces[chosenx + counter][choseny - counter] == 0 && black_pieces[chosenx + counter][choseny - counter] == 0) {
        possible_moves[chosenx + counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny - counter >= 0 && black_pieces[chosenx + counter][choseny - counter] != 0) {
          possible_moves[chosenx + counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny + counter <= 7 && white_pieces[chosenx + counter][choseny + counter] == 0 && black_pieces[chosenx + counter][choseny + counter] == 0) {
        possible_moves[chosenx + counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny + counter <= 7 && black_pieces[chosenx + counter][choseny + counter] != 0) {
          possible_moves[chosenx + counter][choseny + counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny + counter <= 7 && white_pieces[chosenx - counter][choseny + counter] == 0 && black_pieces[chosenx - counter][choseny + counter] == 0) {
        possible_moves[chosenx - counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny + counter <= 7 && black_pieces[chosenx - counter][choseny + counter] != 0) {
          possible_moves[chosenx - counter][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(2):
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (chosenx + i >= 0 && chosenx + i <= 7 && choseny + j >= 0 && choseny + j <= 7) {
          if (!(i == 0 && j == 0) && white_pieces[chosenx + i][choseny + j] == 0) {
            possible_moves[chosenx + i][choseny + j] = 1;
          }
        }
      }
    }
    if (!white_in_check && !white_rook1_moved && !white_king_moved && white_pieces[1][0] == 0 && white_pieces[2][0] == 0 && white_pieces[3][0] == 0 && black_pieces[1][0] == 0 && black_pieces[2][0] == 0 && black_pieces[3][0] == 0) {
      white_pieces[3][0] = 2;
      white_pieces[4][0] = 0;
      if (!black_check_check()) {
        possible_moves[2][0] = 1;
      }
      white_pieces[3][0] = 0;
      white_pieces[4][0] = 2;
    }
    if (!white_in_check && !white_rook2_moved && !white_king_moved && white_pieces[5][0] == 0 && white_pieces[6][0] == 0 && black_pieces[5][0] == 0 && black_pieces[6][0] == 0) {
      white_pieces[5][0] = 2;
      white_pieces[4][0] = 0;
      if (!black_check_check()) {
        possible_moves[6][0] = 1;
      }
      white_pieces[5][0] = 0;
      white_pieces[4][0] = 2;
    }
    break;
  }

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (possible_moves[i][j] == 1) {
        white_pieces[chosenx][choseny] = 0;
        white_pieces[i][j] = piece_held;
        taken_piece = 0;
        if (black_pieces[i][j] != 0) {
          taken_piece = black_pieces[i][j];
          black_pieces[i][j] = 0;
        }
        if (black_check_check()) {
          possible_moves[i][j] = 0;
        }
        white_pieces[i][j] = 0;
        white_pieces[chosenx][choseny] = piece_held;
        if (taken_piece != 0) {
          black_pieces[i][j] = taken_piece;
        }
      }
    }
  }
}

void find_blacks_moves() {
  piece_held = black_pieces[chosenx][choseny];

  switch(piece_held) { //find possible moves for each piece
    case(1):
    if (choseny == 6 && white_pieces[chosenx][5] == 0 && black_pieces[chosenx][5] == 0 && white_pieces[chosenx][4] == 0 && black_pieces[chosenx][4] == 0) {
      possible_moves[chosenx][4] = 1;
    }
    if (choseny > 0 && white_pieces[chosenx][choseny-1] == 0 && black_pieces[chosenx][choseny-1] == 0) {
      possible_moves[chosenx][choseny-1] = 1;
    }
    if (choseny > 0 && chosenx > 0 && white_pieces[chosenx - 1][choseny - 1] != 0) {
      possible_moves[chosenx-1][choseny-1] = 1;
    }
    if (choseny > 0 && chosenx < 7 && white_pieces[chosenx + 1][choseny - 1] != 0) {
      possible_moves[chosenx+1][choseny-1] = 1;
    }

    if (white_en_passant < 50 && choseny == 3 && abs(chosenx - white_en_passant) == 1 && white_pieces[white_en_passant][3] == 1) {
      possible_moves[white_en_passant][2] = 1;
    }
    break;

    case(5):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && black_pieces[chosenx - counter][choseny] == 0 && white_pieces[chosenx - counter][choseny] == 0) {
        possible_moves[chosenx - counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && white_pieces[chosenx - counter][choseny] != 0) {
          possible_moves[chosenx - counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && black_pieces[chosenx + counter][choseny] == 0 && white_pieces[chosenx + counter][choseny] == 0) {
        possible_moves[chosenx + counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && white_pieces[chosenx + counter][choseny] != 0) {
          possible_moves[chosenx + counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny - counter >= 0 && black_pieces[chosenx][choseny - counter] == 0 && white_pieces[chosenx][choseny - counter] == 0) {
        possible_moves[chosenx][choseny - counter] = 1;
        counter++;
      } else {
        if (choseny - counter >= 0 && white_pieces[chosenx][choseny - counter] != 0) {
          possible_moves[chosenx][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny + counter <= 7 && black_pieces[chosenx][choseny + counter] == 0 && white_pieces[chosenx][choseny + counter] == 0) {
        possible_moves[chosenx][choseny + counter] = 1;
        counter++;
      } else {
        if (choseny + counter <= 7 && white_pieces[chosenx][choseny + counter] != 0) {
          possible_moves[chosenx][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(3):
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((abs(chosenx - i) == 1 && abs(choseny - j) == 2) ^ (abs(chosenx - i) == 2 && abs(choseny - j) == 1)) {
          if (black_pieces[i][j] == 0) {
            possible_moves[i][j] = 1;
          }
        }
      }
    }
    break;

    case(4):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny - counter >= 0 && black_pieces[chosenx - counter][choseny - counter] == 0 && white_pieces[chosenx - counter][choseny- counter] == 0) {
        possible_moves[chosenx - counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny - counter >= 0  && white_pieces[chosenx - counter][choseny - counter] != 0) {
          possible_moves[chosenx - counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny - counter >= 0 && black_pieces[chosenx + counter][choseny - counter] == 0 && white_pieces[chosenx + counter][choseny - counter] == 0) {
        possible_moves[chosenx + counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny - counter >= 0 && white_pieces[chosenx + counter][choseny - counter] != 0) {
          possible_moves[chosenx + counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny + counter <= 7 && black_pieces[chosenx + counter][choseny + counter] == 0 && white_pieces[chosenx + counter][choseny + counter] == 0) {
        possible_moves[chosenx + counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny + counter <= 7 && white_pieces[chosenx + counter][choseny + counter] != 0) {
          possible_moves[chosenx + counter][choseny + counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny + counter <= 7 && black_pieces[chosenx - counter][choseny + counter] == 0 && white_pieces[chosenx - counter][choseny + counter] == 0) {
        possible_moves[chosenx - counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny + counter <= 7 && white_pieces[chosenx - counter][choseny + counter] != 0) {
          possible_moves[chosenx - counter][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(9):
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && black_pieces[chosenx - counter][choseny] == 0 && white_pieces[chosenx - counter][choseny] == 0) {
        possible_moves[chosenx - counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && white_pieces[chosenx - counter][choseny] != 0) {
          possible_moves[chosenx - counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && black_pieces[chosenx + counter][choseny] == 0 && white_pieces[chosenx + counter][choseny] == 0) {
        possible_moves[chosenx + counter][choseny] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && white_pieces[chosenx + counter][choseny] != 0) {
          possible_moves[chosenx + counter][choseny] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny - counter >= 0 && black_pieces[chosenx][choseny - counter] == 0 && white_pieces[chosenx][choseny - counter] == 0) {
        possible_moves[chosenx][choseny - counter] = 1;
        counter++;
      } else {
        if (choseny - counter >= 0 && white_pieces[chosenx][choseny - counter] != 0) {
          possible_moves[chosenx][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (choseny + counter <= 7 && black_pieces[chosenx][choseny + counter] == 0 && white_pieces[chosenx][choseny + counter] == 0) {
        possible_moves[chosenx][choseny + counter] = 1;
        counter++;
      } else {
        if (choseny + counter <= 7 && white_pieces[chosenx][choseny + counter] != 0) {
          possible_moves[chosenx][choseny + counter] = 1;
        }
        break;
      }
    }
    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny - counter >= 0 && black_pieces[chosenx - counter][choseny - counter] == 0 && white_pieces[chosenx - counter][choseny- counter] == 0) {
        possible_moves[chosenx - counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny - counter >= 0  && white_pieces[chosenx - counter][choseny - counter] != 0) {
          possible_moves[chosenx - counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny - counter >= 0 && black_pieces[chosenx + counter][choseny - counter] == 0 && white_pieces[chosenx + counter][choseny - counter] == 0) {
        possible_moves[chosenx + counter][choseny - counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny - counter >= 0 && white_pieces[chosenx + counter][choseny - counter] != 0) {
          possible_moves[chosenx + counter][choseny - counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx + counter <= 7 && choseny + counter <= 7 && black_pieces[chosenx + counter][choseny + counter] == 0 && white_pieces[chosenx + counter][choseny + counter] == 0) {
        possible_moves[chosenx + counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx + counter <= 7 && choseny + counter <= 7 && white_pieces[chosenx + counter][choseny + counter] != 0) {
          possible_moves[chosenx + counter][choseny + counter] = 1;
        }
        break;
      }
    }

    counter = 1;
    while (true) {
      if (chosenx - counter >= 0 && choseny + counter <= 7 && black_pieces[chosenx - counter][choseny + counter] == 0 && white_pieces[chosenx - counter][choseny + counter] == 0) {
        possible_moves[chosenx - counter][choseny + counter] = 1;
        counter++;
      } else {
        if (chosenx - counter >= 0 && choseny + counter <= 7 && white_pieces[chosenx - counter][choseny + counter] != 0) {
          possible_moves[chosenx - counter][choseny + counter] = 1;
        }
        break;
      }
    }
    break;

    case(2):
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (chosenx + i >= 0 && chosenx + i <= 7 && choseny + j >= 0 && choseny + j <= 7) {
          if (!(i == 0 && j == 0) && black_pieces[chosenx + i][choseny + j] == 0) {
            possible_moves[chosenx + i][choseny + j] = 1;
          }
        }
      }
    }
    if (!black_in_check && !black_rook1_moved && !black_king_moved && white_pieces[1][7] == 0 && white_pieces[2][7] == 0 && white_pieces[3][7] == 0 && black_pieces[1][7] == 0 && black_pieces[2][7] == 0 && black_pieces[3][7] == 0) {
      black_pieces[3][7] = 2;
      black_pieces[4][7] = 0;
      if (!white_check_check()) {
        possible_moves[2][7] = 1;
      }
      black_pieces[3][7] = 0;
      black_pieces[4][7] = 2;
    }
    if (!black_in_check && !black_rook2_moved && !black_king_moved && white_pieces[5][7] == 0 && white_pieces[6][7] == 0 && black_pieces[5][7] == 0 && black_pieces[6][7] == 0) {
      black_pieces[5][7] = 2;
      black_pieces[4][7] = 0;
      if (!white_check_check()) {
        possible_moves[6][7] = 1;
      }
      black_pieces[5][7] = 0;
      black_pieces[4][7] = 2;
    }
    break;
  }

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (possible_moves[i][j] == 1) {
        black_pieces[chosenx][choseny] = 0;
        black_pieces[i][j] = piece_held;
        taken_piece = 0;
        if (white_pieces[i][j] != 0) {
          taken_piece = white_pieces[i][j];
          white_pieces[i][j] = 0;
        }
        if (white_check_check()) {
          possible_moves[i][j] = 0;
        }
        black_pieces[i][j] = 0;
        black_pieces[chosenx][choseny] = piece_held;
        if (taken_piece != 0) {
          white_pieces[i][j] = taken_piece;
        }
      }
    }
  }
}

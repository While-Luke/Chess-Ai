//first turn takes around 35s, bring it down to 20s
// now its 12s
//depth of 5 takes 2m 15s

//time for alpha-beta pruning
//305409

int depth = 4;
ArrayList<IntDict> moves;
ArrayList<IntDict> values;
int[] value_tree;
boolean cont, finished, skip, repeat;
int value, moves_size, count;
//float average;

int rem_white_pieces[][];
int rem_black_pieces[][];

int rem_black_en_passant = 100;
int rem_white_en_passant = 100;

boolean rem_white_king_moved = false;
boolean rem_white_rook1_moved = false;
boolean rem_white_rook2_moved = false;
boolean rem_black_king_moved = false;
boolean rem_black_rook1_moved = false;
boolean rem_black_rook2_moved = false;

boolean rem_white_in_check = false;
boolean rem_black_in_check = false;

void ai_turn() {
  values = new ArrayList<IntDict>(); //find of the ai's first possible moves


  for (int j = 0; j < 8; j++) {
    for (int i = 0; i < 8; i++) {
      if (black_pieces[i][j] != 0) {
        chosenx = i;
        choseny = j;
        possible_moves = new int[8][8];
        find_blacks_moves();
        for (int l = 0; l < 8; l++) {
          for (int k = 0; k < 8; k++) {
            if (possible_moves[k][l] == 1) {
              values.add(new IntDict());
              values.get(values.size()-1).set("l1", i);
              values.get(values.size()-1).set("n1", j);
              values.get(values.size()-1).set("l2", k);
              values.get(values.size()-1).set("n2", l);
              values.get(values.size()-1).set("min_value", -1000);
              //values.get(values.size()-1).set("avg_value", 0);
              //values.get(values.size()-1).set("count", 0);
            }
          }
        }
      }
    }
  }

  value_tree = new int[depth-1];
  for (int i = 0; i < depth-1; i++) {
    if (i % 2 == 0) {
      value_tree[i] = 1000;
    } else {
      value_tree[i] = -1000;
    }
  }
  //println(value_tree);


  rem_white_pieces = new int[8][8];
  rem_black_pieces = new int[8][8];
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      rem_white_pieces[i][j] = white_pieces[i][j];
      rem_black_pieces[i][j] = black_pieces[i][j];
    }
  }

  rem_black_en_passant = black_en_passant;
  rem_white_en_passant = white_en_passant;

  rem_white_king_moved = white_king_moved;
  rem_white_rook1_moved = white_rook1_moved;
  rem_white_rook2_moved = white_rook2_moved;
  rem_black_king_moved = black_king_moved;
  rem_black_rook1_moved = black_rook1_moved;
  rem_black_rook2_moved = black_rook2_moved;

  rem_white_in_check = white_in_check;
  rem_black_in_check = black_in_check;


  moves = new ArrayList<IntDict>();
  moves.add(new IntDict());

  moves.get(0).set("l1", values.get(0).get("l1"));
  moves.get(0).set("n1", values.get(0).get("n1"));
  moves.get(0).set("l2", values.get(0).get("l2"));
  moves.get(0).set("n2", values.get(0).get("n2"));

  blacks_move(0);
  moves_size = 0;

  finished = false;
  count = 0;
  while (true) {
    repeat = true;
    count++;
    if (moves.size() % 2 != 0) {
      white_check_checkmate();

      if (black_wins || moves.size() == depth) {
        calculate_value();
        if (skip) {
          moves.remove(moves_size);
          moves_size--;
        } 

        while (repeat) {
          repeat = false;
          refresh_board();

          possible_moves = new int[8][8];
          chosenx = moves.get(moves_size).get("l1");
          choseny = moves.get(moves_size).get("n1");
          if (moves.size() % 2 != 0) {
            find_blacks_moves();
          } else {
            find_whites_moves();
          }

          while (true) {
            cont = true;
            moves.get(moves_size).increment("l2");
            if (moves.get(moves_size).get("l2") == 8) {
              moves.get(moves_size).increment("n2");
              moves.get(moves_size).set("l2", 0);
            }
            if (moves.get(moves_size).get("n2") == 8) {

              while (true) {
                moves.get(moves_size).increment("l1");
                if (moves.get(moves_size).get("l1") == 8) {
                  moves.get(moves_size).increment("n1");
                  moves.get(moves_size).set("l1", 0);
                }
                if (moves.get(moves_size).get("n1") == 8) {
                  moves.remove(moves_size);
                  if (moves.size() == 0) {
                    finished = true;
                    break;
                  }
                  moves_size--;
                  minimax();
                  if (repeat) {
                    break;
                  }
                  refresh_board();
                  cont = false;
                  possible_moves = new int[8][8];
                  chosenx = moves.get(moves_size).get("l1");
                  choseny = moves.get(moves_size).get("n1");
                  if (moves.size() % 2 != 0) {
                    find_blacks_moves();
                  } else {
                    find_whites_moves();
                  }
                  break;
                }
                if (moves.size() % 2 != 0) {
                  if (black_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
                    moves.get(moves_size).set("l2", 0);
                    moves.get(moves_size).set("n2", 0);

                    possible_moves = new int[8][8];
                    chosenx = moves.get(moves_size).get("l1");
                    choseny = moves.get(moves_size).get("n1");
                    find_blacks_moves();
                    break;
                  }
                } else {
                  if (white_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
                    moves.get(moves_size).set("l2", 0);
                    moves.get(moves_size).set("n2", 0);

                    possible_moves = new int[8][8];
                    chosenx = moves.get(moves_size).get("l1");
                    choseny = moves.get(moves_size).get("n1");
                    find_whites_moves();
                    break;
                  }
                }
              }
              if (finished || repeat) {
                break;
              }
            }

            if (cont) {
              if (possible_moves[moves.get(moves_size).get("l2")][moves.get(moves_size).get("n2")] == 1) {
                break;
              }
            }
          }
          if (finished) {
            break;
          }
        }
      } else {
        moves.add(new IntDict());
        moves_size++;
        moves.get(moves_size).set("l1", 0);
        moves.get(moves_size).set("n1", 0);
        while (true) {
          if (white_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
            moves.get(moves_size).set("l2", 0);
            moves.get(moves_size).set("n2", 0);
            cont = true;
            possible_moves = new int[8][8];
            chosenx = moves.get(moves_size).get("l1");
            choseny = moves.get(moves_size).get("n1");
            find_whites_moves();
            while (true) {
              if (possible_moves[moves.get(moves_size).get("l2")][moves.get(moves_size).get("n2")] == 1) {
                break;
              }
              moves.get(moves_size).increment("l2");
              if (moves.get(moves_size).get("l2") == 8) {
                moves.get(moves_size).increment("n2");
                moves.get(moves_size).set("l2", 0);
              }
              if (moves.get(moves_size).get("n2") == 8) {
                cont = false;
                break;
              }
            }
            if (cont) {
              break;
            }
          }
          moves.get(moves_size).increment("l1");
          if (moves.get(moves_size).get("l1") == 8) {
            moves.get(moves_size).set("l1", 0);
            moves.get(moves_size).increment("n1");
          }
        }
      }
    } else {
      black_check_checkmate();

      if (white_wins || moves.size() == depth) {
        calculate_value();
        if (skip) {
          moves.remove(moves_size);
          moves_size--;
        }


        while (repeat) {
          repeat = false;
          refresh_board();

          possible_moves = new int[8][8];
          chosenx = moves.get(moves_size).get("l1");
          choseny = moves.get(moves_size).get("n1");
          if (moves.size() % 2 != 0) {
            find_blacks_moves();
          } else {
            find_whites_moves();
          }

          while (true) {
            cont = true;
            moves.get(moves_size).increment("l2");
            if (moves.get(moves_size).get("l2") == 8) {
              moves.get(moves_size).increment("n2");
              moves.get(moves_size).set("l2", 0);
            }
            if (moves.get(moves_size).get("n2") == 8) {

              while (true) {
                moves.get(moves_size).increment("l1");
                if (moves.get(moves_size).get("l1") == 8) {
                  moves.get(moves_size).increment("n1");
                  moves.get(moves_size).set("l1", 0);
                }
                if (moves.get(moves_size).get("n1") == 8) {
                  moves.remove(moves_size);
                  if (moves.size() == 0) {
                    finished = true;
                    break;
                  }
                  moves_size--;
                  if (repeat) {
                    break;
                  }
                  minimax();
                  refresh_board();
                  cont = false;
                  possible_moves = new int[8][8];
                  chosenx = moves.get(moves_size).get("l1");
                  choseny = moves.get(moves_size).get("n1");
                  if (moves.size() % 2 != 0) {
                    find_blacks_moves();
                  } else {
                    find_whites_moves();
                  }
                  break;
                }
                if (moves.size() % 2 != 0) {
                  if (black_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
                    moves.get(moves_size).set("l2", 0);
                    moves.get(moves_size).set("n2", 0);

                    possible_moves = new int[8][8];
                    chosenx = moves.get(moves_size).get("l1");
                    choseny = moves.get(moves_size).get("n1");
                    find_blacks_moves();
                    break;
                  }
                } else {
                  if (white_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
                    moves.get(moves_size).set("l2", 0);
                    moves.get(moves_size).set("n2", 0);

                    possible_moves = new int[8][8];
                    chosenx = moves.get(moves_size).get("l1");
                    choseny = moves.get(moves_size).get("n1");
                    find_whites_moves();
                    break;
                  }
                }
              }
              if (finished || repeat) {
                break;
              }
            }

            if (cont) {
              if (possible_moves[moves.get(moves_size).get("l2")][moves.get(moves_size).get("n2")] == 1) {
                break;
              }
            }
          }
          if (finished) {
            break;
          }
        }
      } else {
        moves.add(new IntDict());
        moves_size++;
        moves.get(moves_size).set("l1", 0);
        moves.get(moves_size).set("n1", 0);
        while (true) {
          if (black_pieces[moves.get(moves_size).get("l1")][moves.get(moves_size).get("n1")] != 0) {
            moves.get(moves_size).set("l2", 0);
            moves.get(moves_size).set("n2", 0);
            cont = true;
            possible_moves = new int[8][8];
            chosenx = moves.get(moves_size).get("l1");
            choseny = moves.get(moves_size).get("n1");
            find_blacks_moves();
            while (true) {
              if (possible_moves[moves.get(moves_size).get("l2")][moves.get(moves_size).get("n2")] == 1) {
                break;
              }
              moves.get(moves_size).increment("l2");
              if (moves.get(moves_size).get("l2") == 8) {
                moves.get(moves_size).increment("n2");
                moves.get(moves_size).set("l2", 0);
              }
              if (moves.get(moves_size).get("n2") == 8) {
                cont = false;
                break;
              }
            }
            if (cont) {
              break;
            }
          }
          moves.get(moves_size).increment("l1");
          if (moves.get(moves_size).get("l1") == 8) {
            moves.get(moves_size).set("l1", 0);
            moves.get(moves_size).increment("n1");
          }
        }
      }
    }
    if (finished) {
      break;
    }

    refresh_board();
    if (moves.size() % 2 != 0) {
      blacks_move(moves_size);
    } else {
      whites_move(moves_size);
    }
  }

  for (int i = 0; i < values.size(); i++) {
    println(values.get(i));
  }
  //println();

  value = -1000;
  for (int x = 0; x < values.size(); x++) {
    if (values.get(x).get("min_value") > value) {
      value = values.get(x).get("min_value");
    }
  }

  for (int x = 0; x < values.size(); x++) {
    if (values.get(x).get("min_value") < value) {
      values.remove(x);
      x--;
    }
  }

  //average = -1000;
  //for (int x = 0; x < values.size(); x++) {
  //  if (float(values.get(x).get("avg_value"))/float(values.get(x).get("count")) > average) {
  //    average = float(values.get(x).get("avg_value"))/float(values.get(x).get("count"));
  //  }
  //}

  //for (int x = 0; x < values.size(); x++) {
  //  if (float(values.get(x).get("avg_value"))/float(values.get(x).get("count")) < average) {
  //    values.remove(x);
  //    x--;
  //  }
  //}

  value = int(random(values.size()));

  moves.add(new IntDict());
  moves.get(0).set("l1", values.get(value).get("l1"));
  moves.get(0).set("n1", values.get(value).get("n1"));
  moves.get(0).set("l2", values.get(value).get("l2"));
  moves.get(0).set("n2", values.get(value).get("n2"));


  blacks_move(0);
  println(count);
}


void refresh_board() {
  black_wins = false;
  white_wins = false;

  black_en_passant = rem_black_en_passant;
  white_en_passant = rem_white_en_passant;

  white_king_moved = rem_white_king_moved;
  white_rook1_moved = rem_white_rook1_moved;
  white_rook2_moved = rem_white_rook2_moved;
  black_king_moved = rem_black_king_moved;
  black_rook1_moved = rem_black_rook1_moved;
  black_rook2_moved = rem_black_rook2_moved;

  white_in_check = rem_white_in_check;
  black_in_check = rem_black_in_check;

  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      white_pieces[x][y] = rem_white_pieces[x][y];
      black_pieces[x][y] = rem_black_pieces[x][y];
    }
  }

  for (int x = 0; x < moves_size; x++) {
    if (x % 2 == 0) {
      blacks_move(x);
    } else {
      whites_move(x);
    }
  }
}

void blacks_move(int step) {
  black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = black_pieces[moves.get(step).get("l1")][moves.get(step).get("n1")];
  black_pieces[moves.get(step).get("l1")][moves.get(step).get("n1")] = 0;
  white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = 0;

  if (black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n1") == 6 && moves.get(step).get("n2") == 4) {//checks for en passant
    black_en_passant = moves.get(step).get("l1");
  }
  if (black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n2") == 2 && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 0 && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2") + 1] == 1) {
    white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2") + 1] = 0;
  }

  if (black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n2") == 0) {
    black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = 9;
  }


  if (!black_rook1_moved && !black_king_moved && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2 && moves.get(step).get("l2") == 2 && moves.get(step).get("n2") == 7) {//checks for castling
    black_pieces[0][7] = 0;
    black_pieces[3][7] = 5;
  }
  if (!black_rook2_moved && !black_king_moved && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2 && moves.get(step).get("l2") == 6 && moves.get(step).get("n2") == 7) {
    black_pieces[7][7] = 0;
    black_pieces[5][7] = 5;
  }
  if (black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2) { 
    black_king_moved = true;
  }
  if (!black_rook1_moved && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 5 && moves.get(step).get("l1") == 0 && moves.get(step).get("n1") == 7) {
    black_rook1_moved = true;
  }
  if (!black_rook2_moved && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 5 && moves.get(step).get("l1") == 7 && moves.get(step).get("n1") == 7) {
    black_rook2_moved = true;
  }


  if (black_check_check()) {
    white_in_check = true;
  }

  black_in_check = false;
  white_en_passant = 100;
}

void whites_move(int step) {
  white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = white_pieces[moves.get(step).get("l1")][moves.get(step).get("n1")];
  white_pieces[moves.get(step).get("l1")][moves.get(step).get("n1")] = 0;
  black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = 0;

  if (white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n1") == 1 && moves.get(step).get("n2") == 3) {//checks for en passant
    white_en_passant = moves.get(step).get("l1");
  }
  if (white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n2") == 5 && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 0 && black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2") - 1] == 1) {
    black_pieces[moves.get(step).get("l2")][moves.get(step).get("n2") - 1] = 0;
  }

  if (white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 1 && moves.get(step).get("n2") == 7) {//check for promotion
    white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] = 9;
  }


  if (!white_rook1_moved && !white_king_moved && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2 && moves.get(step).get("l2") == 2 && moves.get(step).get("n2") == 0) {//checks for castling
    white_pieces[0][0] = 0;
    white_pieces[3][0] = 5;
  }
  if (!white_rook2_moved && !white_king_moved && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2 && moves.get(step).get("l2") == 6 && moves.get(step).get("n2") == 0) {
    white_pieces[7][0] = 0;
    white_pieces[5][0] = 5;
  }
  if (white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 2) { 
    white_king_moved = true;
  }
  if (!white_rook1_moved && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 5 && moves.get(step).get("l1") == 0 && moves.get(step).get("n1") == 0) {
    white_rook1_moved = true;
  }
  if (!white_rook2_moved && white_pieces[moves.get(step).get("l2")][moves.get(step).get("n2")] == 5 && moves.get(step).get("l1") == 7 && moves.get(step).get("n1") == 0) {
    white_rook2_moved = true;
  }


  if (white_check_check()) {
    black_in_check = true;
  }

  white_in_check = false;
  black_en_passant = 100;
}


void calculate_value() {
  value = 0;
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      value+=black_pieces[x][y];
      value-=white_pieces[x][y];
    }
  }
  if (black_wins) {
    value+=10;
  }
  if (white_wins) {
    value-=15;
  }


  //for (int x = 0; x < values.size(); x++) {
  //  if (moves.get(0).get("l1") == values.get(x).get("l1") && moves.get(0).get("n1") == values.get(x).get("n1") && moves.get(0).get("l2") == values.get(x).get("l2") && moves.get(0).get("n2") == values.get(x).get("n2")) {
  //    values.get(x).add("avg_value", value);
  //    values.get(x).increment("count");
  //    break;
  //  }
  //}

  skip = false;
  if (moves_size > 1) {
    if (moves_size % 2 == 0) {
      if (value > value_tree[moves_size-2]) {
        skip = true;
        value_tree[moves_size-1] = -1000;
      }
    } else {
      if (value < value_tree[moves_size-2]) {
        skip = true;
        value_tree[moves_size-1] = 1000;
      }
    }
  }

  if (!skip && moves_size > 0) {
    if (moves_size % 2 != 0) {
      if (value < value_tree[moves_size-1]) {
        value_tree[moves_size-1] = value;
      }
    } else {
      if (value > value_tree[moves_size-1]) {
        value_tree[moves_size-1] = value;
      }
    }
  }
}


void minimax() {
  //println(value_tree);
  //println(moves_size);
  if (moves_size == 0) {
    for (int x = 0; x < values.size(); x++) {
      if (moves.get(0).get("l1") == values.get(x).get("l1") && moves.get(0).get("n1") == values.get(x).get("n1") && moves.get(0).get("l2") == values.get(x).get("l2") && moves.get(0).get("n2") == values.get(x).get("n2")) {
        values.get(x).set("min_value", value_tree[0]);
        break;
      }
    }
    for (int i = 0; i < depth-1; i++) {
      if (i % 2 == 0) {
        value_tree[i] = 1000;
      } else {
        value_tree[i] = -1000;
      }
    }
  } else {
    if (moves_size % 2 == 0) {
      if (value_tree[moves_size - 1] < value_tree[moves_size] && value_tree[moves_size] != 1000) {
        value_tree[moves_size - 1] = value_tree[moves_size];
      }
      value_tree[moves_size] = 1000;
    } else {
      if (value_tree[moves_size - 1] > value_tree[moves_size] && value_tree[moves_size] != -1000) {
        value_tree[moves_size - 1] = value_tree[moves_size];
      }
      value_tree[moves_size] = -1000;
    }

    if (moves_size > 1) {
      if (moves_size % 2 == 0) {
        if (value > value_tree[moves_size-2]) {
          repeat = true;
          value_tree[moves_size-1] = -1000;
          moves.remove(moves_size);
          moves_size--;
        }
      } else {
        if (value < value_tree[moves_size-2]) {
          repeat = true;
          value_tree[moves_size-1] = 1000;
          moves.remove(moves_size);
          moves_size--;
        }
      }
    }
  }
  //println(value_tree);
}

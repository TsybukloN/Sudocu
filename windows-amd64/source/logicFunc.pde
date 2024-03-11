import java.util.ArrayList;
import java.util.Arrays;

void startInitializeBoard() {
  sudokuBoard = new cell[size][size];

  setDigits();
  cellSize = width / size;

  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      sudokuBoard[i][j] = new cell();
      sudokuBoard[i][j].value = ' ';
    }
  }
}

void cleanBoard() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      sudokuBoard[i][j].value = ' ';
      sudokuBoard[i][j].solved = ' ';
    }
  }
}

void setDigits() {
  int j = 0;
  digits.clear();
  digits.ensureCapacity(size);

  for (char x = '1'; x <= '9' && j++ < size; x++) {
    digits.add(x);
  }

  for (char x = 'A'; x <= 'X' && j++ < size; x++) {
    digits.add(x);
  }
}

boolean isValidMove(int row, int col, char num) {
  for (int i = 0; i < size; i++) {
    if ((sudokuBoard[row][i].value == num && i != col) || (sudokuBoard[i][col].value == num && i != row)) {
      return false;
    }
  }

  int subgridStartRow = row - row % blockSizeY;
  int subgridStartCol = col - col % blockSizeX;
  for (int i = 0; i < blockSizeY; i++) {
    for (int j = 0; j < blockSizeX; j++) {
      if (sudokuBoard[subgridStartRow + i][subgridStartCol + j].value == num && subgridStartRow + i != row && subgridStartCol + j != col) {
        return false;
      }
    }
  }

  return true;
}

boolean isCorrectSolved() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (sudokuBoard[i][j].value != sudokuBoard[i][j].solved) {
        return false;
      }
    }
  }

  return true;
}

void fillInitialValues(int level) {
  boolean fromStartFlag = false;

  for (int i = 0; i < size; i++) {
    fromStartFlag = false;
    for (int j = 0; j < size; j++) {
      ArrayList<Character> set = new ArrayList<Character>(digits);

      while (set.size() > 0) {
        int randomIndex = (int) random(0, set.size());
        char candidate = set.get(randomIndex);

        if (isValidMove(i, j, candidate)) {
          sudokuBoard[i][j].value = candidate;
          break;
        }

        set.remove(randomIndex);
      }

      if (sudokuBoard[i][j].value == ' ') {
        if (fromStartFlag) {
          fromStartFlag = false;
          i = 0;
          cleanBoard();
        } else {
          fromStartFlag = true;
          for (int u = 0; u < j; u++) {
            sudokuBoard[i][u].value = ' ';
          }
        }

        j = -1;
      }
    }
  }

  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      sudokuBoard[i][j].solved = sudokuBoard[i][j].value;
      if (random(0, level+1) >= 1) {
        sudokuBoard[i][j].value = ' ';
        sudokuBoard[i][j].free = true;
      } else {
        sudokuBoard[i][j].free = false;
      }
    }
  }
}

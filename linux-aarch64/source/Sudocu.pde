import controlP5.*;

PImage icon;
PFont usual, seted, dropdownList;
PVector tooltipPosition;
ControlP5 difficultyTool, sizeTool;

int size = 10,
  blockSizeX = 5,
  blockSizeY = size/blockSizeX;

int cellSize,
  selectedRow = -1,
  selectedCol = -1;

boolean isGameStarted = true,
  isSolved = false;

int difficulty = 1;

long startTime, elapsedTimeInSeconds;

ArrayList<Character> digits = new ArrayList<>();

class cell {
  char value;
  char solved;
  boolean free;
};

cell[][] sudokuBoard;

void setup() {
  size(1260, 1260);
  
  strokeWeight(2);
  textAlign(CENTER, CENTER);
  
  usual = createFont("Arial", 27);
  seted = createFont("Comic Sans MS", 26);
  dropdownList = createFont("Arial", 14);

  icon = loadImage("icon.png");
  surface.setIcon(icon);

  tooltipPosition = new PVector(width - 120, 50);

  difficultyTool = new ControlP5(this);
  difficultyTool.addDropdownList("difficulty")
    .setPosition(0, 0)
    .setSize(110, 200)
    .setCaptionLabel("Big-O (Easy)")
    .setFont(dropdownList)
    .addItem("Easy", 0)
    .addItem("Medium", 1)
    .addItem("Hard", 2)
    .setItemHeight(25)
    .setBarHeight(25);

  sizeTool = new ControlP5(this);
  sizeTool.addDropdownList("size")
    .setPosition(120, 0)
    .setSize(106, 200)
    .setCaptionLabel("Size (10x10)")
    .setFont(dropdownList)
    .addItem("6x6", 0)
    .addItem("9x9", 1)
    .addItem("10x10", 2)
    .addItem("14x14", 3)
    .setItemHeight(25)
    .setBarHeight(25);

  startInitializeBoard();
  fillInitialValues(1);
}

void draw() {
  background(255);
  drawGrid();
  drawNumbers();

  if (isGameStarted) {
    displayTooltip();
  }

  if (isCorrectSolved()) {
    isSolved = true;
  }
}

void mousePressed() {
  selectedRow = mouseY / cellSize;
  selectedCol = mouseX / cellSize;
}

void keyPressed() {
  if (selectedRow != -1 && selectedCol != -1 && sudokuBoard[selectedRow][selectedCol].free) {
    char keyChar = Character.toUpperCase((char)key);
    if (digits.contains(keyChar)) {
      sudokuBoard[selectedRow][selectedCol].value = keyChar;
      
    } else if (keyChar == BACKSPACE) {
      sudokuBoard[selectedRow][selectedCol].value = ' ';
    }
  }

  if (keyCode == UP && selectedRow > 0) {
    selectedRow--;
  } else if (keyCode == DOWN && selectedRow < size-1) {
    selectedRow++;
  } else if (keyCode == LEFT && selectedCol > 0) {
    selectedCol--;
  } else if (keyCode == RIGHT && selectedCol < size-1) {
    selectedCol++;
  }
}

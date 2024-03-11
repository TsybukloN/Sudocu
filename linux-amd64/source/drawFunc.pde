void drawGrid() {
  for (int i = 0; i <= size; i++) {
    if (i % blockSizeY == 0) {
      stroke(0);
    } else {
      stroke(200);
    }
    line(0, i * cellSize, width, i * cellSize);
  }

  for (int i = 0; i <= size; i++) {
    if (i % blockSizeX == 0) {
      stroke(0);
    } else {
      stroke(200);
    }
    line(i * cellSize, 0, i * cellSize, height);
  }
}

void drawNumbers() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (!sudokuBoard[i][j].free) {
        textFont(usual);
      } else {
        textFont(seted);
      }
      fill(0);
      text(sudokuBoard[i][j].value, j * cellSize + cellSize / 2, i * cellSize + cellSize / 2);
    }
  }

  if (selectedRow != -1 && selectedCol != -1) {
    fill(150, 200, 255, 150);
    rect(selectedCol * cellSize, selectedRow * cellSize, cellSize, cellSize);
  }
}

void displayTooltip() {
  if (!isSolved && mouseX > width - 25 && 10 <= mouseY && mouseY <= 90) {
    long hours = elapsedTimeInSeconds / 3600;
    long minutes = (elapsedTimeInSeconds % 3600) / 60;
    long seconds = elapsedTimeInSeconds % 60;

    String formattedTime = String.format("%02d:%02d:%02d", hours, minutes, seconds);

    fill(200, 220, 255, 200);
    rect(tooltipPosition.x - 200/2, tooltipPosition.y - 75/2, 200, 75);
    fill(0);
    textFont(usual);
    text("Time: " + formattedTime, tooltipPosition.x, tooltipPosition.y);
  } else if (isSolved) {
    long hours = elapsedTimeInSeconds / 3600;
    long minutes = (elapsedTimeInSeconds % 3600) / 60;
    long seconds = elapsedTimeInSeconds % 60;

    String formattedTime = String.format("%02d:%02d:%02d", hours, minutes, seconds);

    fill(200, 220, 255, 200);
    rect(tooltipPosition.x - 200/2, tooltipPosition.y - 75/2, 200, 75);
    fill(0, 127, 0);
    textFont(usual);
    text("Time: " + formattedTime, tooltipPosition.x, tooltipPosition.y);
  } else {
    fill(50, 122, 254);
    rect(tooltipPosition.x + 95, tooltipPosition.y - 75/2, 25, 75);

    fill(0);

    float angle = -HALF_PI;
    translate(tooltipPosition.x + 108, tooltipPosition.y);
    rotate(angle); 
    textFont(usual);
    text("time", 0, 0);

    rotate(-angle);
    translate(-(tooltipPosition.x + 108), -tooltipPosition.y);
  }

  if (!isSolved) {
    elapsedTimeInSeconds = (millis() - startTime) / 1000;
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("difficulty")) {
    difficulty = (int)theEvent.getController().getValue() + 1;
  }

  if (theEvent.isFrom("size")) {
    int selectedDifficulty = (int)theEvent.getController().getValue();
    switch(selectedDifficulty) {
    case 0:
      size = 6;
      blockSizeX = 3;
      break;
    case 1:
      size = 9;
      blockSizeX = 3;
      break;
    case 2:
      size = 10;
      blockSizeX = 5;
      break;
    case 3:
      size = 14;
      blockSizeX = 7;
      break;
    }

    blockSizeY = size/blockSizeX;
    startInitializeBoard();
  }

  cleanBoard();
  fillInitialValues(difficulty);
  startTime = millis();
  isGameStarted = true;
  isSolved = false;
}

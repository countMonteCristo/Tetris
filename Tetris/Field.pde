class Field {
  float x, y;
  int columns, rows;
  float size;
  
  int startFallSpeed = 40;
  int fallSpeed;
  int controlSpeed = 4;
  
  int score, lines, level;
  
  boolean wasStarted, isFinished, isPaused;
  
  char[] types = {'I', 'O', 'T', 'Z', 'S', 'R', 'L'};
  Tetramino tetra, nextTetra;
  
  ArrayList<Cell> cells;
  int cellIdx[];

  Field(float x, float y, int columns, int rows, float size) {
    this.x = x;
    this.y = y;
    this.columns = columns;
    this.rows = rows;
    this.size = size;

    reset();
    isFinished = true;
   }

  void reset() {
    cells = new ArrayList<Cell>();
    cellIdx = new int[this.columns*this.rows];
    for (int i=0; i<cellIdx.length; i++) {
      cellIdx[i] = -1;
    }
    tetra = null;
    nextTetra = getRandomTetra();

    fallSpeed = startFallSpeed;  
    score = 0;
    lines = 0;
    level = 0;

    isFinished = false;
    wasStarted = false;
    isPaused = false;
  }

  void restart() {
    reset();
    wasStarted = true;
    addTetra();
  }
  
  void flipPaused() {
    isPaused = !isPaused;
  }

  int index(int row, int column) {
    return column + this.columns*row;
  }

  void brokeToCells() {
    for (Cell c : tetra.cells) {
      this.cells.add(c);
      cellIdx[index(c.row, c.column)] = this.cells.size() - 1;
    }
    tetra = null;

    // search for filled rows
    int rowCount[] = new int[this.rows];
    IntList filledRows = new IntList();
    for (Cell c : cells) {
      rowCount[c.row]++;
      if (rowCount[c.row] == columns) {
        filledRows.append(c.row);
      }
    }

    if (filledRows.size() == 0) {
      return;
    }
    lines += filledRows.size();
    level = floor(lines/10);
    fallSpeed = (startFallSpeed - level >= controlSpeed)? (startFallSpeed - level): controlSpeed;
    
    IntList toRemove = new IntList();
    for (int filledRow : filledRows) {
      for (int c=0; c<this.columns; c++) {
        int cell_index = index(filledRow, c);
        int cell_id = cellIdx[cell_index]; 
        if (cell_id == -1) {
          continue;
        } else {
          toRemove.append(cell_id);
        }
      }
    }

    // remove all
    toRemove.sortReverse();
    for (int ci : toRemove) {
      cells.remove(ci);
    }
    switch (filledRows.size()) {
    case 1:
      score += 1;
      break;
    case 2:
      score += 3;
      break;
    case 3:
      score += 7;
      break;
    case 4:
      score += 15;
      break;
    }

    // recreate index table
    for (int i=0; i<this.rows*this.columns; i++) {
      cellIdx[i] = -1;
    }
    for (int i = 0; i<cells.size(); i++) {
      cellIdx[index(cells.get(i).row, cells.get(i).column)] = i;
    }

    for (int c=0; c<this.columns; c++) {
      for (int r=0; r<this.rows; r++) {
        if (filledRows.hasValue(r)) {
          ;
          for (int tr=r-1; tr>=0; tr--) {
            cellIdx[index(tr+1, c)] = cellIdx[index(tr, c)];
          }
          cellIdx[index(0, c)] = -1;
        }
      }
    } 

    for (int c=0; c<this.columns; c++) {
      for (int r=0; r<this.rows; r++) {
        int idx = index(r, c);
        int cell_id = cellIdx[idx];
        if (cell_id!=-1) {
          Cell _c = cells.get(cell_id);
          _c.setPos(r, c);
        }
      }
    }
  }
  
  Tetramino getRandomTetra() {
    int index = floor(random(types.length));
    char type = types[index];
    Tetramino t = new Tetramino(type, 1, floor(columns/2)-1, size);
    return t;
  }
  
  void addTetra() {
    tetra = nextTetra;
    tetra.setSpeeds(0, 0);
    tetra.setActive(true);
    
    nextTetra = getRandomTetra();

    for (Cell c : tetra.cells) {
      if (cellIdx[index(c.row, c.column)] != -1) {
        isFinished = true;
        break;
      }
    }
  }

  void setTetraSpeed(int col_speed, int row_speed) {
    if (tetra != null && !isPaused) {
      tetra.setSpeeds(col_speed, row_speed);
    }
  }

  void tryRotate(int direction) {
    if (tetra != null && !isPaused) {
      tetra.rotateIfPossible(direction, this);
    }
  }
  
  void dropTetra() {
    if (!isFinished && !isPaused) {
      if (tetra != null) {
        while (!tetra.checkFall(this)) {
          tetra.applyGravity();
        }
      }
    }
  }

  void show() {
    pushMatrix();
    translate(x, y);
    strokeWeight(1);
    fill(20);
    rect(0, 0, columns*size, rows*size);

    if (tetra != null) {
      tetra.show();
    }
    for (Cell c : cells) {
      c.show();
    }
    popMatrix();
  }

  void update() {
    if (!isFinished && !isPaused) {
      if (tetra != null) {
        if (frameCount % controlSpeed == 0) {
          // check if we can move
          tetra.tryControlledMove(this);
        }
        if (frameCount % fallSpeed == 0) {
          // check if we fall
          if (tetra.checkFall(this)) {
            tetra.setSpeeds(0, 0);
            tetra.setActive(false);
            brokeToCells();
            addTetra();
          } else {
            tetra.applyGravity();
          }
        }
      }
    }
  }
}

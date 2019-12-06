class Tetramino {
  Cell[] cells;
  char type;
  color fillColor;
  boolean isActive = true;
  int row_speed, col_speed;

  Tetramino(char type, int row, int column, float size) {
    row_speed = 0;
    col_speed = 0;
    
    cells = new Cell[4];
    this.type = type;
    cells[0] = new Cell(row, column, size);

    switch (type) {
    case 'I': 
      cells[1] = new Cell(row-1, column, size);
      cells[2] = new Cell(row+1, column, size);
      cells[3] = new Cell(row+2, column, size);
      fillColor = color(255, 0, 0);
      break;
    case 'O':
      cells[1] = new Cell(row-1, column  , size);
      cells[2] = new Cell(row,   column+1, size);
      cells[3] = new Cell(row-1, column+1, size);
      fillColor = color(0, 255, 0);
      break;
    case 'T':
      cells[1] = new Cell(row-1, column,   size);
      cells[2] = new Cell(row,   column+1, size);
      cells[3] = new Cell(row+1, column,   size);
      fillColor = color(0, 0, 255);
      break;
    case 'Z':
      cells[1] = new Cell(row-1, column,   size);
      cells[2] = new Cell(row-1, column-1, size);
      cells[3] = new Cell(row  , column+1, size);
      fillColor = color(255, 255, 0);
      break;
    case 'S':
      cells[1] = new Cell(row-1, column  , size);
      cells[2] = new Cell(row-1, column+1, size);
      cells[3] = new Cell(row  , column-1, size);
      fillColor = color(255, 0, 255);
      break;
    case 'R':
      cells[1] = new Cell(row-1, column  , size);
      cells[2] = new Cell(row-1, column+1, size);
      cells[3] = new Cell(row+1, column  , size);
      fillColor = color(0, 255, 255);
      break;
    case 'L':
      cells[1] = new Cell(row-1, column  , size);
      cells[2] = new Cell(row-1, column-1, size);
      cells[3] = new Cell(row+1, column  , size);
      fillColor = color(255, 255, 255);
      break;
    }
    
    for (Cell c: cells) {
      c.setColor(fillColor);
    }
  }

  void setActive(boolean f) {
    isActive = f;
    for (Cell c : cells) {
      c.setActive(isActive);
    }
  }
  
  void setSpeeds(int col_v, int row_v) {
    row_speed = row_v;
    col_speed = col_v;
    for (Cell c: cells) {
      c.v_col = col_speed;
    }
  }
  
  void rotateIfPossible(int clockwise, Field f) {
    // clokwise should be 1 or -1 (counter clockwise)
    // 1st cell is always the rotation center
    int cx = cells[0].column;
    int cy = cells[0].row;
    int newRows[] = new int[3];
    int newColumns[] = new int[3];
    boolean canRotate = true;
    
    for (int i=1; i<cells.length; i++) {
      int dx = cells[i].column - cx;
      int dy = cells[i].row - cy;
      
      newRows[i-1] = cy + clockwise*dx;
      newColumns[i-1] = cx - clockwise*dy;
      
      if (newRows[i-1] >= f.rows || newColumns[i-1] < 0 || newColumns[i-1] >=f.columns) {
        canRotate = false;
        break;
      }
      
      for (Cell c: f.cells) {
        if (c.row == newRows[i-1] && c.column == newColumns[i-1]) {
          canRotate = false;
          break;
        }
      }
      if (!canRotate) {
        break;
      }
    }
    
    if (canRotate) {
      for (int i=1; i< cells.length; i++) {
        cells[i].setPos(newRows[i-1],newColumns[i-1]);
      }
    }
  }

  void show() {
    for (Cell c : cells) {
      c.show();
    }
  }

  void tryControlledMove(Field f) {
    // check if we can move left while moving left
    // or if we can moving right while moving right
    boolean canMoveH = true;
    if (col_speed != 0) {
      for (Cell c: cells) {
        if (c.column + col_speed < 0 || c.column + col_speed == f.columns) {
          canMoveH = false;
          break;
        }
        for (Cell fc: f.cells) {
          if (c.column + col_speed == fc.column && c.row == fc.row) {
            canMoveH = false;
            break;
          }
        }
        if (!canMoveH) {
          break;
        }
      }
      if (!canMoveH) {
        setSpeeds(0, row_speed);
      }
      controlledUpdate();
    }
    if (row_speed != 0) {
      if (!checkFall(f)) {
        applyGravity();
      }
    }
  }
  
  boolean checkFall(Field f) {
    boolean isFallen = false;
    for (Cell c: cells) {
      if (c.row + 1 == f.rows) {
        isFallen = true;
        break;
      }
      for (Cell fc: f.cells) {
        if (c.column == fc.column && c.row + 1 == fc.row) {
          isFallen = true;
          break;
        }
      }
      if (isFallen) {
        break;
      }
    }
    return isFallen;
  }
  
  void applyGravity() {
    if (isActive) {
      for (Cell c : cells) {
        c.applyGravity();
      }
    }
  }

  void controlledUpdate() {
    if (isActive) {
      for (Cell c : cells) {
        c.controlledUpdate();
      }
    }
  }
}

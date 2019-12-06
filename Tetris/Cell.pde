class Cell extends Rectangle {
  int row, column;
  int v_col;
  color fillColor;
  boolean isActive = true;
  
  Cell(int row, int column, float size) {
    super(column*size, row*size, size, size);
    setPos(row, column);
  }
  
  void setPos(int row, int column) {
    this.row = row;
    this.column = column;
    x = column*w;
    y = row*h;
  }
  
  void setActive(boolean f) {
    isActive = f;
    v_col = 0;
  }
  
  void setColor(color c) {
    fillColor = c;
  }
  
  void show() {
    strokeWeight(1);
    fill(fillColor);
    rect(x, y, w, h);
  }
  
  void applyGravity() {
    if (isActive) {
      setPos(row + 1, column);
    }
  }
  
  void controlledUpdate() {
    if (isActive) {
      setPos(row, column + v_col);
    }
  }
}

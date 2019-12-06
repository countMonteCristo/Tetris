Field field;

void setup() {
  size(560, 540);
  surface.setTitle("Tetris!");
  field = new Field(20, 20, 10, 20, 25);
}

void keyPressed() {
  if (keyCode == LEFT) {
    field.setTetraSpeed(-1, 0);
  } else if (keyCode == RIGHT) {
    field.setTetraSpeed(1, 0);
  } else if (keyCode == DOWN) {
    field.setTetraSpeed(0, 1);
  } else if (key == ' ') {
    field.dropTetra();
  } else if (key == 'Z' || key == 'z') {
    field.tryRotate(-1);
  } else if (key == 'X' || key == 'x') {
    field.tryRotate(1);
  } else if (key == 'S' || key == 's') {
    field.restart();
  } else if (key == 'P' || key == 'p') {
    field.flipPaused();
  }
}
void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT || keyCode == DOWN) {
    field.setTetraSpeed(0, 0);
  }
}

int x = 0;

void draw() {
  background(150);
  field.show();
  field.update();

  textSize(32);
  fill(0);
  textAlign(LEFT);
  text("Score:", 280, 50);
  textAlign(RIGHT);
  text(field.score, 540, 50);

  textAlign(LEFT);
  text("Lines:", 280, 100);
  textAlign(RIGHT);
  text(field.lines, 540, 100);

  textAlign(LEFT);
  text("Level:", 280, 150);
  textAlign(RIGHT);
  text(field.level, 540, 150);

  if (field.wasStarted) {
    pushMatrix();
    translate(250, 200);
    stroke(0);
    strokeWeight(1);
    noFill();
    rect(50, -25, 125, 125);
    field.nextTetra.show();
    popMatrix();
    
    if (field.isFinished) {
      textAlign(CENTER);
      fill(255, 0, 0);
      text("GAME OVER", 420, 350);
    }
  }
}

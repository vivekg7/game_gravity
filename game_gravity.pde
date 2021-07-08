int aax, aay;
float ax, ay;    // -1 to 1
float vx, vy;
float px, py;
float rad = 20;

Rock rocks[];
final int ROCK_COUNT = 10;

boolean playing = false;

FileHandling fd = new FileHandling();
int best5[] = new int[5];
int gameAvg, gameCount;
int score = 0;

void setup() {
  size(800, 800);
  background(255);
  rocks = new Rock[ROCK_COUNT];
  for (int i=0; i<ROCK_COUNT; i++) {
    rocks[i] = new Rock(random(30)-i*(height/10));
  }
  textAlign(CENTER);
  resetGame();
  getScores();
}

void draw() {
  background(255);
  if (playing) {
    displayGame();
    updateGame();
  } else {
    displayHome();
  }
}

void displayHome() {
  fill(0, 0, 255);
  textSize(40);
  text("Gravity 0.1", width/2, 100);
  textSize(32);
  text("Best5: "+best5[0]+" "+best5[1]+" "+best5[2]+" "+best5[3]+" "+best5[4]+" ", width/2, 200);
  text("Avg: "+gameAvg+" in "+gameCount+" games.", width/2, 300);
  text("Your Score: "+score/60, width/2, 400);
}

void displayGame() {
  noStroke();
  fill(255, 0, 0);
  circle(px, py, rad*2);
  for (int i=0; i<ROCK_COUNT; i++) {
    rocks[i].display();
  }
  stroke(0, 255, 0);
  strokeWeight(3);
  line(px, py, px + ax*100, py + ay*100);
  strokeWeight(1);
  fill(0);
  circle(px, py, 5);
  fill(0, 255, 0);
  textSize(32);
  text(score/60, width/2, 50);
}

void updateGame() {
  for (int i=0; i<ROCK_COUNT; i++) {
    if (rocks[i].contains(px, py, rad)) {
      playing = false;
      updateScores();
      return;
    }
    if(rocks[i].update(1))
      rocks[i].regenerate(height+random(30)-ROCK_COUNT*(height/10));
  }
  vx += ax*0.1;   vy += ay*0.1;
  px += vx;       py += vy;
  if (px > width-rad) {
    px = width-rad;
    vx *= -1;
  }
  if (px < rad) {
    px = rad;
    vx *= -1;
  }
  if (py > height-rad) {
    py = height-rad;
    vy *= -1;
  }
  if (py < rad) {
    py = rad;
    vy *= -1;
  }
  score++;
}

void resetGame() {
  score = 0;
  aax = 512; aay= 512;
  ax = 0; ay = 0;
  vx = 0; vy = 0;
  px = width/2; py = height/2;
  for (int i=0; i<ROCK_COUNT; i++) {
    rocks[i].regenerate(random(30)-i*(height/10));
  }
}

void updateScores() {
  int i=4;
  while (i>0 && best5[i-1] < score/60) {
    best5[i] = best5[i-1];
    i--;
  }
  if (best5[i] < score/60) best5[i] = score/60;
  gameAvg = (gameAvg * gameCount + score/60) / (gameCount + 1);
  gameCount++;
  setScores();
}

float mapa(float t) {
  return map(t, 0, 1023, -1, 1);
}

void setScores() {
  int nums[] = {best5[0], best5[1], best5[2], best5[3], best5[4], gameAvg, gameCount};
  fd.saveScore(nums);
}

void getScores() {
  int nums[] = fd.loadScore();
  best5[0] = nums[0];
  best5[1] = nums[1];
  best5[2] = nums[2];
  best5[3] = nums[3];
  best5[4] = nums[4];
  gameAvg = nums[5];
  gameCount = nums[6];
}

void keyPressed() {
  if (key == ' ' && !playing) {
    resetGame();
    playing = true;
  }
  if (playing) {
    switch (key) {
      case 'w':
      case 'W':
      case '8':
        aay = aay > 0 ? aay-1 : aay;
        ay = mapa(aay);
        break;
      case 's':
      case 'S':
      case '2':
        aay = aay < 1023 ? aay+1 : aay;
        ay = mapa(aay);
        break;
      case 'a':
      case 'A':
      case '4':
        aax = aax > 0 ? aax-1 : aax;
        ax = mapa(aax);
        break;
      case 'd':
      case 'D':
      case '6':
        aax = aax < 1023 ? aax+1 : aax;
        ax = mapa(aax);
        break;
      default: break;
    }
    if (key == CODED) {
      if (keyCode == UP) {
        aay = aay > 0 ? aay-1 : aay;
        ay = mapa(aay);
      } else if (keyCode == DOWN) {
        aay = aay < 1023 ? aay+1 : aay;
        ay = mapa(aay);
      } else if (keyCode == LEFT) {
        aax = aax > 0 ? aax-1 : aax;
        ax = mapa(aax);
      } else if  (keyCode == RIGHT) {
        aax = aax < 1023 ? aax+1 : aax;
        ax = mapa(aax);
      }
    }
  }
}

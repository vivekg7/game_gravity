class Rock {
  float x, y;
  float r;
  
  Rock( float ty) {
    x = random(width);
    y = ty;
    r = 15;
  }
  
  void display() {
    noStroke();
    fill(0);
    circle(x, y, r*2);
  }
  
  boolean contains(float cx, float cy, float rad) {
    return dist(x, y, cx, cy) <= (rad+r);
  }
  
  boolean update(float v) {
    y += v;
    return y >= height;
  }
  
  void regenerate(float ty) {
    x = random(width);
    y = ty;
  }
}

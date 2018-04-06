/* @pjs preload="seabird.jpg"; */
PImage img;

KochFractal k;



void setup() {
  img = loadImage("seabird.png");
  size(800, 800);
  frameRate(4);  // Animate faster
  k = new KochFractal();
  //img = loadImage("seabird.png");
}

void draw() {
  
  background(240,230,140);
  
  fill(30,144,255);
  rect(0,600,800,800);
  noStroke();
  fill(178,34,34);
  ellipse(600,200,200,200);
  image(img, mouseX-100, mouseY-100);
  k.render();
  k.nextLevel();
  // do it more than 8 times
  if (k.getCount() > 8) {
    k.restart();
  }
  
  if(frameCount>300){
  exit();
}

saveFrame("frames/fib1-####.png");
println("frame"+ frameCount);

}





// Koch Curve
// A class to manage the list of line segments in the snowflake pattern

class KochFractal {
  PVector start;       // A PVector for the start
  PVector end;         // A PVector for the end
  ArrayList<KochLine> lines;   // A list to keep track of all the lines
  int count;
  
  KochFractal() {
    start = new PVector(0,height-200);
    end = new PVector(width,height-200);
    lines = new ArrayList<KochLine>();
    restart();
  }

  void nextLevel() {  
    // For every line that is in the arraylist
    // create 4 more lines in a new arraylist
    lines = iterate(lines);
    count++;
  }

  void restart() { 
    count = 0;      // Reset count
    lines.clear();  // Empty the array list
    lines.add(new KochLine(start,end));  // Add the initial line (from one end PVector to the other)
  }
  
  int getCount() {
    return count;
  }
  
  // This is easy, just draw all the lines
  void render() {
    for(KochLine l : lines) {
      l.display();
    }
  }


  // each line gets broken into 4 lines, which gets broken into 4 lines, and so on 
  ArrayList iterate(ArrayList<KochLine> before) {
    ArrayList now = new ArrayList<KochLine>();    // Create emtpy list
    for(KochLine l : before) {
      // Calculate 5 koch PVectors (done for us by the line object)
      PVector a = l.start();                 
      PVector b = l.kochleft();
      PVector c = l.kochmiddle();
      PVector d = l.kochright();
      PVector e = l.end();
      // Make line segments between all the PVectors and add them
      now.add(new KochLine(a,b));
      now.add(new KochLine(b,c));
      now.add(new KochLine(c,d));
      now.add(new KochLine(d,e));
    }
    return now;
  }

}




class KochLine {

  // Two PVectors,
  
  PVector a;
  PVector b;

  KochLine(PVector start, PVector end) {
    a = start.copy();
    b = end.copy();
  }

  void display() {
    stroke(30,144,255);
    strokeWeight(2);
    line(a.x, a.y, b.x, b.y);
  }

  PVector start() {
    return a.copy();
  }

  PVector end() {
    return b.copy();
  }

 
  PVector kochleft() {
    PVector v = PVector.sub(b, a);
    v.div(3); //1 triangle!!
    v.add(a);
    return v;
  }    

  
  PVector kochmiddle() {
    PVector v = PVector.sub(b, a);
    v.div(2);
    
    PVector p = a.copy();
    p.add(v);
    
    v.rotate(-radians(30)); //60 tree!
    p.add(v);
    
    return p;
  }    

  // Easy, just 2/3 of the way
  PVector kochright() {
    PVector v = PVector.sub(a, b);
    v.div(2);
    v.add(b);
    return v;
  }
}

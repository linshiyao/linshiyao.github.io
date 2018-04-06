/* @pjs preload="stickmen.png"; */
        
                    
                    PImage men;
                    String[] feels = {"I hope you are tired","because I'm tired","if you are tired","we can be tired together",
                                     "amazing"};
                    Men[] myMen; 
                              
                              
                              
                              
int nextTime;
int duration;
     
KochFractal k;

void setup() {
  size(800, 800);
 background(0);
                         men = loadImage("stickmen.png");
  frameRate(4);  // Animate slowly
  k = new KochFractal(); //Define KochFractal, class
 nextTime = millis();
 duration = 300; 
                            myMen = new Men[7]; // Create

              for (int i = 0;  i < myMen.length;i++) {

                  myMen[i] = new Men(feels[int(random(feels.length))],7);

  }
}

void draw() {
  
  background(0,76,153);
  
  k.render(); // make a class for Koch render

  k.nextLevel(); // make a class for Koch's next step
  
  if (k.getCount() > 7) {// do it until 7 times, ..
    k.restart(); //... then go back (restart not defined yet)
  }
  
    fill(0,5);
  rect(0,0,width,height); //rect that covers everything up
                                                                  
                        
 if ((millis()- nextTime) > duration){  
println("Circle!" + nextTime);
nextTime = millis();
fill(random(255),random(255),random(255));
noStroke();
ellipse(random(300,500), random(200,800),100,100);
}

                  for (int i = 0;  i<myMen.length;i++) {

                    myMen[i].move();
                    myMen[i].tremble(random(2));
                    myMen[i].update();

  }
  
 if(frameCount>300){
  exit();
}

saveFrame("frames/fib1-####.png");
println("frame"+ frameCount);

  
}


// so far 3 classes waiting to be called, "render", "nextLevel" and "restart"


// Koch Curve


class KochFractal {
  PVector start;       // A PVector for the start
  PVector end;         // A PVector for the end
  //PVector is just a convenient way to store two or three values.
  
  ArrayList<KochLine> lines;   // A list to keep track of all the lines
  int count; 
  
  KochFractal() { // calling for KochFractal 
    start = new PVector(-800,height); // calling for start position
    end = new PVector(800,height); // calling for end position
    lines = new ArrayList<KochLine>(); // calling for lines
    restart(); 
  }

  void nextLevel() {  // calling for nextLevel
    // For every line that is in the arraylist
    // create 7 more lines in a new arraylist
    lines = iterate(lines); //iterate = repeatative 
    count++;
  }

  void restart() { //calling for restart
    count = 0;      // Restart from begining when reach the 7 time
    lines.clear();  // Empty the array list (or lines)
    lines.add(new KochLine(start,end));  // Add the initial line (from one end PVector to the other)
  }
  
  int getCount() { 
    return count; //Since count was set to o above, means return to 0 and count over again
  }
  
  // This is easy, just draw all the lines
  void render() {
    for(KochLine l : lines) { 
      l.display(); //define display, waiting to be called
    }
  }

  // Step 1: Create an empty arraylist
  // Step 2: For every line currently in the arraylist
  //   - calculate 4 line segments based on Koch algorithm
  //   - add all 4 line segments into the new arraylist
  // Step 3: Return the new arraylist and it becomes the list of line segments for the structure
  
  //each line gets broken into 4 lines, which gets broken into 4 lines, and so on. . . 
  
  ArrayList iterate(ArrayList<KochLine> before) { //repeart the list of KochLine before
    ArrayList now = new ArrayList<KochLine>();    // Create an emtpy list, name it 'now' 
    for(KochLine l : before) {
      // Calculate 5 koch PVectors 
      PVector a = l.start();      //locate the 1st line segment, define as a          
      PVector b = l.kochleft(); //2nd one, b
      PVector c = l.kochmiddle(); //another one..., c
      PVector d = l.kochright(); //... , d
      PVector e = l.end(); //...till the end, e
      
      // Make line segments between all the PVectors and add them
      now.add(new KochLine(a,b)); //now do it over again, but create new segment between a&b
      now.add(new KochLine(b,c)); //now do it over again, but create new segment between b&c
      now.add(new KochLine(c,d)); //now do it over again, but create new segment between c&d
      now.add(new KochLine(d,e)); //now do it over again, but create new segment between d&e
    }
    return now; //After it's over 7 times, do it again from the beginning
  }

}

////////////////////////////////////////////////////////////////////

class KochLine { //now call the line 

  
  PVector a;
  PVector b;
// two PVectors


  KochLine(PVector start, PVector end) {
    a = start.copy(); //copy where it start
    b = end.copy(); //copy where it end
  }

  void display() { //calling display
    stroke(250);
    strokeWeight(3);
    line(a.x, a.y, b.x, b.y);
  }

  PVector start() {
    return a.copy(); //again
  }

  PVector end() {
    return b.copy(); //again
  }

  //  1/3 of the way
  PVector kochleft() {
    PVector v = PVector.sub(b, a);
    v.div(1); //ghghgh
    v.add(a);
    return v;
  }    


  PVector kochmiddle() {
    PVector v = PVector.sub(b, a);
    v.div(2); //bnbnbn
    
    PVector p = a.copy();
    p.add(v);
    
    v.rotate(-radians(60));
    p.add(v);
    
    return p;
  }    

  // Easy, just 2/3 of the way
  PVector kochright() {
    PVector v = PVector.sub(a, b);
    v.div(2); //fgfgfgf
    v.add(b);
    return v;
  }
}

/////////////////////////////////////////////////

class Men {

  float lox;
  float loy; 
  color rc;
  float acc;
  String people;




  Men (String cm, float sp)  {
    lox = int(random(20,600));
    loy = int(random(20,100));
    //loz = int(random(20,700));
    rc = color(random(255),random(255),random(255));
    acc = sp;
    people = cm;
  }

  void move() {
    lox+=acc;
    if (lox > width) {
      lox = 0;
    }
  }

  void tremble(float sa) {

    if (loy > height/2 || loy < 0 ) {
      loy = height/2;
    }
     loy+=random(-sa,sa);
  }


  void update() {
    //fill(255);
    //rect(lox,loy,40,40,12);
    //ellipse(lox,loy,80,80);
    //fill(0);
    image(men,lox,loy,80,80);
    fill(255);
    text(people,lox+50,loy+40);

  }


}

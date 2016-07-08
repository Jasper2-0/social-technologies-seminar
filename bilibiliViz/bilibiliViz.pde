import java.util.Date;
import java.util.Calendar;
import java.sql.Timestamp;

String commentFilename = "7682393.xml";
String commentCSVFilename = "test2.csv";

PFont chineseFont;
PFont westernFont;

/* 
 Bilibili comment format
 Arg0: Time when a comment appears
 Arg1: comment mode
 Arg2: Font size
 Arg3: Font Color (RGBA Integer)
 Arg4: Unix timestamp
 Arg5: Comment pool
 Arg6: sender user id
 Arg7: database rowID
 */

Table comments;

int minTimeStamp;
int maxTimeStamp;

int minCommentLength;
int maxCommentLength;

float minAppear;
float maxAppear;

float marginLeft = 110;
float marginRight = 50;

float minEllipseSize = 5;
float maxEllipseSize = 25;

float ellipseSize;

int commentIndex = 0;

float xRange;
float yRange;

color pink =   color(255, 95, 165);
color yellow = color(255, 255, 3);
color blue =   color(10,160,255);
color black = color (0,0,0);
color white = color(255,255,255);

Date firstComment;
Date lastComment;

void setup() {
  size(1280, 768,P3D);
  pixelDensity(2);

  chineseFont = createFont("草泥马体", 32);
  westernFont = createFont("Helvetica", 12);

  //comments = parseBilibiliXML(commentFilename);

  comments = parseBiliBiliCSV(commentCSVFilename);

  /*
  * All the comments are sorted by appeartime.
  */

  println(comments.getFloatList("appearTime"));

  comments.setColumnType("appearTime", Table.FLOAT); // otherwise we get an alphabetical sort, we want a _numerical_ sort.
  comments.sort("appearTime");

  maxTimeStamp = comments.getIntList("timeStamp").max();
  minTimeStamp = comments.getIntList("timeStamp").min();

  minAppear = comments.getFloatList("appearTime").min();
  maxAppear = comments.getFloatList("appearTime").max();

  minCommentLength = minCommentLength(comments);
  maxCommentLength = maxCommentLength(comments);

  xRange = width;
  yRange = -300;

  println(minAppear);
  println(maxAppear);

  println(comments.getUnique("userID").length);

  firstComment = new Date((long) minTimeStamp*1000);
  lastComment = new Date((long) maxTimeStamp*1000);

  println(firstComment);
  println(lastComment);

  println(minTimeStamp);
  println(maxTimeStamp);

  println(minCommentLength);
  println(maxCommentLength);
}

void draw() {

  background(0);
  pushMatrix();
  translate(0, height/2.0);
  stroke(255);
  line(marginLeft,150,width-marginRight,150);
  line(marginLeft,-150,marginLeft,150);

  for (int i = 0; i< comments.getRowCount(); i++) {
    TableRow tr = comments.getRow(i);

    float xPos = map(tr.getFloat("appearTime"), 0, maxAppear, 0+marginLeft, xRange-marginRight);
    float yPos = map(tr.getInt("timeStamp"), minTimeStamp, maxTimeStamp, 0, yRange);

    float ellipseSize = map(tr.getString("comment").length(), minCommentLength, maxCommentLength, minEllipseSize, maxEllipseSize);

    noStroke();

    if (i == commentIndex) {
      fill(255, 0, 0);
      ellipseSize = ellipseSize * 1.0;
    } else {
      //fill(255); - color mode
      if (tr.getInt("commentMode") == 5) {
        fill(255, 95, 165);//pink
      } else if (tr.getInt("commentMode") == 4) {
        fill(255, 255, 3);//yellow
      } else {
        int alpha = (5 - (tr.getInt("commentMode") % 10)) * 50;
        int colors = 160 + (tr.getInt("commentMode") % 10) * 30; 
        color c = color(10, colors, 255);//, alpha);
        fill(c);
      }
    }
    //stroke(0);
    ellipse(xPos, 150+yPos, ellipseSize, ellipseSize);
  }

  popMatrix();
  pushMatrix();
  translate(5, 15);
  fill(255);
  //text("number of Comments: "+comments.getRowCount(), 0, 0);
  popMatrix();

  text("comment timestamp", marginLeft, 200);
  text("time in video", 1200, 610);

  TableRow cc = comments.getRow(commentIndex);

  pushMatrix();
  translate(marginLeft, height*0.75);
  textFont(chineseFont);
  text(cc.getString("comment"), 0, 30);
  textFont(westernFont);
  text("intentionality: "+cc.getInt("intentionality"), 0, 50);
  text("commentMode: " + cc.getInt("commentMode"), 0, 70);
  text("commentType: " + cc.getString("commentType"), 0, 90);
  text("timeStamp: " + cc.getInt("timeStamp"), 0, 110);
  text("appearTime: " + cc.getFloat("appearTime"), 0, 130);


  popMatrix();

  float indicatorX = map(mouseX, 0+marginLeft, xRange-marginRight, 0, maxAppear);
  float indicatorY = map(mouseY, height/2-150, height/2+150, minTimeStamp, maxTimeStamp);


  stroke(255);

  if (mouseX > 0+marginLeft-1 && mouseX < xRange-marginRight) {
    line(mouseX, height/2+150, mouseX, height/2+160);
    textAlign(CENTER);

    int hours = (int) indicatorX / 3600;
    int minutes = (int) (indicatorX % 3600) / 60;
    int seconds = (int) indicatorX % 60;
    String timeString = String.format("%02d:%02d:%02d", hours, minutes, seconds);
    text(timeString, mouseX, height/2+180);


  }
  if (mouseY > height/2-150 && mouseY < height/2+150) {
    line(marginLeft-10, mouseY, 0+marginLeft, mouseY);
    textAlign(RIGHT, CENTER);    
    Date commentDate = new Date((long)indicatorY);
    text(String.format("%1$tm/%1$td %1$tH:%1$tM:%1$tS", commentDate), marginLeft-15, mouseY);
    
  }
  textAlign(LEFT,BOTTOM);
  pushMatrix();
  translate(1100,650);
  drawLegend();
  popMatrix();
}

void drawLegend() {
  fill(pink);
  noStroke();
  ellipse(5,5,10,10);
  text("emotion",15,11);
  
  fill(yellow);
  noStroke();
  ellipse(5,20,10,10);
  text("attention!",15,26);
  
  fill(blue);
  noStroke();
  ellipse(5,35,10,10);
  text("player action / reaction",15,41);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      commentIndex = max(0, --commentIndex);
    } 
    if (keyCode == RIGHT) {
      commentIndex = commentIndex + 1;
    }
  }

  if (key == 's') {
    println("save csv");
    saveTable(comments, "data/comments-"+timestamp()+".csv");
  }
  /*
  * this is for setting the intentionality level
   */

  if (key == '1') {
    setIntentionality(commentIndex, 1);
  }
  if (key == '2') {
    setIntentionality(commentIndex, 2);
  }
  if (key == '3') {
    setIntentionality(commentIndex, 3);
  }
  if (key == '4') {
    setIntentionality(commentIndex, 4);
  }
  if (key == '5') {
    setIntentionality(commentIndex, 5);
  }
  if (key == '0') {
    setIntentionality(commentIndex, 0);
  }

  if (key == 'e') {
    setCommentType(commentIndex, "emotion");
  }
}

void setIntentionality(int index, int level) {
  comments.setInt(index, "intentionality", level);
}

void setCommentType(int index, String commentType) {
  comments.setString(index, "commentType", commentType);
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
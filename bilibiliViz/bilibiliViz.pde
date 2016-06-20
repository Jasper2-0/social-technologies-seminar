import java.util.Date;
import java.util.Calendar;
import java.sql.Timestamp;

String commentFilename = "7747740.xml";

String commentCSVFilename = "test1.csv";

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

float marginLeft = 50;
float marginRight = 50;

float minEllipseSize = 1;
float maxEllipseSize = 20;

float ellipseSize;

int commentIndex = 0;

float xRange;
float yRange;

Date firstComment;
Date lastComment;

void setup() {
  size(1024, 768);
  pixelDensity(2);

  chineseFont = createFont("草泥马体", 32);
  westernFont = createFont("Helvetica", 12);

  //comments = parseBilibiliXML(commentFilename);

  comments = parseBiliBiliCSV(commentCSVFilename);

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

  firstComment = new Date(minTimeStamp*1000);
  lastComment = new Date(maxTimeStamp*1000);

  println(firstComment);
  println(lastComment);

  println(minTimeStamp);
  println(maxTimeStamp);

  println(minCommentLength);
  println(maxCommentLength);
}


void update() {
}

void draw() {

  background(0);
  pushMatrix();
  translate(0, height/2.0);

  for (int i = 0; i< comments.getRowCount(); i++) {
    TableRow tr = comments.getRow(i);

    float xPos = map(tr.getFloat("appearTime"), 0, maxAppear, 0+marginLeft, xRange-marginRight);
    float yPos = map(tr.getInt("timeStamp"), minTimeStamp, maxTimeStamp, 0, yRange);

    float ellipseSize = map(tr.getString("comment").length(), minCommentLength, maxCommentLength, minEllipseSize, maxEllipseSize);

    noStroke();

    if (i == commentIndex) {
      fill(255, 0, 0);
      ellipseSize = ellipseSize * 2.0;
    } else {
      fill(255);
    }
    ellipse(xPos, 150+yPos, ellipseSize, ellipseSize);
  }

  popMatrix();
  pushMatrix();
  translate(5, 15);
  text("number of Comments: "+comments.getRowCount(), 0, 0);
  popMatrix();

  text("comment timestamp", marginLeft, 200);
  text("time in video", 900, 550);

  TableRow cc = comments.getRow(commentIndex);

  pushMatrix();
  translate(marginLeft, height*0.75);
  textFont(chineseFont);
  text(cc.getString("comment"), 0, 0);
  textFont(westernFont);
  text("intentionality: "+cc.getInt("intentionality"), 0, 20);

  popMatrix();

  float indicatorX = map(mouseX, 0+marginLeft, xRange-marginRight, 0, maxAppear);

  if (mouseX > 0+marginLeft-1 && mouseX < xRange-marginRight) {
    stroke(255);
    line(mouseX, height/2-150, mouseX, height/2+150);
  }
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
    saveTable(comments, "comments-"+timestamp()+".csv");
  }
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
}

void setIntentionality(int index, int level) {
  comments.setInt(index, "intentionality", level);
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
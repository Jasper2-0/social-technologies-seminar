PFont myFont = createFont("草泥马体", 32);
String myStr = "中国字得这么显";

size(400, 400);
pixelDensity(2);

background(0);
fill(255);
textFont(myFont);
text(myStr, 30, 200);
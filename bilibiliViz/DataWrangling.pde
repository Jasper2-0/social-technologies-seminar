ArrayList<Comment> parseBilibiliXML(String filename) {

  xml = loadXML(filename);
  XML[] d = xml.getChildren("d");
  ArrayList<Comment> c = new ArrayList<Comment>();

  for (int i = 0; i < d.length; i++) {
    String data = d[i].getString("p");
    String comment = d[i].getContent();

    String[] dataList = split(data, ",");

    Comment cc = new Comment();

    cc.c = comment;
    cc.appearTime = parseFloat(dataList[0]);
    cc.commentMode = parseInt(dataList[1]);
    cc.fontSize = parseInt(dataList[2]);
    cc.fontColor = parseInt(dataList[3]);
    cc.timeStamp = parseInt(dataList[4]);
    cc.commentPool = parseInt(dataList[5]);
    cc.userID = dataList[6];
    cc.databaseRowID = parseInt(dataList[7]);

    c.add(cc);
  }
  return c;
}

int maxCommentLength(ArrayList<Comment> cc) {
  int commentLength = 0;
  
  for(Comment c : cc) {
    if (c.c.length() > commentLength ) {
      commentLength = c.c.length();      
    }
  }
  return commentLength;
}

int minCommentLength(ArrayList<Comment> cc) {
  int commentLength = 2147483647;
  
  for (Comment c : cc) {
    if(c.c.length() < commentLength) {
      commentLength = c.c.length();
    }
  }
  
  return commentLength;
  
}

int maxTimeStamp(ArrayList<Comment> cc) {

  int maxTimeStamp = 0;

  for (Comment c : cc) {
    if (c.timeStamp > maxTimeStamp) {
      maxTimeStamp = c.timeStamp;
    }
  }
  return maxTimeStamp;
}

int minTimeStamp(ArrayList<Comment> cc) {

  int minTimeStamp = 2147483647;
  for (Comment c : cc) {
    if (c.timeStamp < minTimeStamp) {
      minTimeStamp = c.timeStamp;
    }
  }
  return minTimeStamp;
}

float minAppear(ArrayList<Comment> cc) {
  float minAppear = 7200.0;

  for (Comment c : cc) {
    if (c.appearTime < minAppear) {
      minAppear = c.appearTime;
    }
  }
  return minAppear;
}

float maxAppear(ArrayList<Comment> cc) {
  float maxAppear = 0;

  for (Comment c : cc) { 
    if (c.appearTime > maxAppear) {
      maxAppear = c.appearTime;
    }
  }
  return maxAppear;
}

ArrayList<String> uniqueUsers(ArrayList<Comment> cc) {
  ArrayList<String> users = new ArrayList();
  for (Comment c : cc) {
    String uid = c.userID;     
    if (users.contains(uid)) {
    } else {
      users.add(uid);
    }
  }
  return users;
}

int getUniqueUserCount(ArrayList<Comment> cc) {
  return uniqueUsers(comments).size();
}
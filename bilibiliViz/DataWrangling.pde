Table parseBilibiliXML(String filename) {

  XML xml = loadXML(filename);
  XML[] d = xml.getChildren("d");

  Table t = createCommentTable();

  for (int i = 0; i < d.length; i++) {
    String data = d[i].getString("p");
    String comment = d[i].getContent();

    String[] dataList = split(data, ",");

    float appearTime    = parseFloat(dataList[0]);
    int commentMode     = parseInt(dataList[1]);
    int fontSize        = parseInt(dataList[2]);
    int fontColor       = parseInt(dataList[3]);
    int timeStamp       = parseInt(dataList[4]);
    int commentPool     = parseInt(dataList[5]);
    String userID       = dataList[6];
    int databaseRowID   = parseInt(dataList[7]);
    int intentionality  = 0;
    int commentType     = -1;

    TableRow newRow = t.addRow();     
    newRow.setString("comment", comment);
    newRow.setFloat("appearTime", appearTime);
    newRow.setInt("commentMode", commentMode);
    newRow.setInt("fontColor", fontColor);
    newRow.setInt("fontSize", fontSize);
    newRow.setInt("timeStamp", timeStamp);
    newRow.setInt("commentPool", commentPool);
    newRow.setString("userID", userID);
    newRow.setInt("databaseRowID", databaseRowID);
    newRow.setInt("intentionality", intentionality);
    newRow.setInt("commentType", commentType);
  }

  return t;
}

Table createCommentTable() {
  Table t = new Table();

  t.addColumn("comment");
  t.addColumn("appearTime");
  t.addColumn("commentMode");
  t.addColumn("fontColor");
  t.addColumn("fontSize");
  t.addColumn("timeStamp");
  t.addColumn("commentPool");
  t.addColumn("userID");
  t.addColumn("databaseRowID");
  t.addColumn("intentionality");
  t.addColumn("commentType");

  return t;
}

int maxCommentLength(Table t) {
  int commentLength = 0;

  for (int i = 0; i<t.getRowCount(); i++) {
    TableRow tr = t.getRow(i);
    String comment = tr.getString("comment");
    if (comment.length() > commentLength) {
      commentLength = comment.length();
    }
  }  
  return commentLength;
}

int minCommentLength(Table t) {
  int commentLength = 2147483647;
  for (int i = 0; i<t.getRowCount(); i++) {

    TableRow tr = t.getRow(i);
    String comment = tr.getString("comment");

    if (comment.length() < commentLength) {
      commentLength = comment.length();
    }
  }
  return commentLength;
}

class Comment {

  String c;
  
  float appearTime;
  int commentMode;
  color fontColor;
  int fontSize;
  
  int timeStamp;
  Date commentDate;
  
  int commentPool;
  String userID;
  int databaseRowID;
  
  int intentionality = 0;
  int commentType = -1;
  
  Comment () {
  
  }
  
  String toString() {
    return c;
  }
}
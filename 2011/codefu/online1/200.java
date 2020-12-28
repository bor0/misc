public class HighestArea {
  public int highest(String triangles) {
      int highest = 0, index = 0;
      String triangle[] = triangles.split(";");
      for (int i=0;i<triangle.length;i++) {
          int x1,y1,x2,y2,x3,y3;
          int sum;
          String points[] = triangle[i].split(",");
          x1 = Integer.parseInt(points[0]);y1 = Integer.parseInt(points[1]);
          x2 = Integer.parseInt(points[2]);y2 = Integer.parseInt(points[3]);
          x3 = Integer.parseInt(points[4]);y3 = Integer.parseInt(points[5]);
          sum = Math.abs((x2*y1-x1*y2)+(x3*y2-x2*y3)+(x1*y3-x3*y1))/2;
          if (sum > highest) {
              highest = sum;
              index = i;
          }
      }
          
      return index;
  }
}
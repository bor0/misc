public class TrainRoute {
  public String findActualSchedule(String plannedSchedule, String updates) {
      String q[] = plannedSchedule.split(" "), p[] = updates.split(" ");
      String result="";
      for (int i=0;i<q.length;i+=2) {
          boolean gotcha=false; int j;
          for (j=p.length-1;j>=0;j--) if (q[i].equals(p[j])) { gotcha = true; break; }
          if (gotcha) q[i+1] = p[j+1];
          result = result + " " + q[i] + " " + q[i+1];
      }
      //StringBuffer t = new StringBuffer();
      
      return result.trim();
  }
}
import java.util.List;
import java.util.Collections;

class Percentage{
  
  ArrayList<State> stateArray;
  List <StatePercent> percentArray;
  String commuteCategory;
  
  public Percentage(ArrayList<State> stateArray, String commuteCategory){
    this.stateArray = stateArray;
    this.commuteCategory = commuteCategory;
    
    //String = state, Integer = percentage
    percentArray = new ArrayList<StatePercent>();
    
    
      
    
  }
  
  //returns sorted ArrayList of percentages with states, List<StatePercent>
  public void calculatePercentage(){    
    
    if(commuteCategory.equals("DroveAlone")){
      int totalUS = stateArray.get(0).droveAlone;//in US total
      
      for(int i = 1; i < stateArray.size(); i++){
        int numberOfWorkers = stateArray.get(i).droveAlone;
        int timesPercent = numberOfWorkers * 100;
        int percent = timesPercent / totalUS;
        
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
      
    }
    else if(commuteCategory.equals("CarPooled")){
    
    }
    else if(commuteCategory.equals("PublicTrans")){
    
    }
    else if(commuteCategory.equals("Walked")){
    
    }
    else if(commuteCategory.equals("Other")){
    
    }
    else if(commuteCategory.equals("Home")){
    
    }
    
  }
  
}

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
  
  //returns sorted ArrayList of percentages with states
  public List<StatePercent> calculatePercentage(int p){    
    
    double percentage = p / 100.0;
    int totalInUs = stateArray.get(0).totalWorkers;

    if(commuteCategory.equals("DroveAlone")){
      
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).droveAlone * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
      
    }//end drove alone
    
    else if(commuteCategory.equals("CarPooled")){
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).carPooled * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
    }
    else if(commuteCategory.equals("PublicTrans")){
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).publicTransport * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
    }
    else if(commuteCategory.equals("Walked")){
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).walked * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
    }
    else if(commuteCategory.equals("Other")){
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).other * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
    }
    else if(commuteCategory.equals("Home")){
      for(int i = 1; i < stateArray.size(); i++){
        double numberOfWorkers = stateArray.get(i).workedAtHome * percentage;
        double timesPercent = numberOfWorkers * 100;
        double percent = (timesPercent * 1.0) / totalInUs;
        percentArray.add(new StatePercent(stateArray.get(i).abbreviation, percent));
      }
      
      
      Collections.sort(percentArray, new percentComparator());
      
      for(StatePercent s: percentArray){
        println("state: " + s.state + " percent: " + s.percent);
      }
      println("----------------------------");
    }
    
    return percentArray;
    
  }
  
}

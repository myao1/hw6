import controlP5.*;
import java.util.List;
import java.text.*;


ControlP5 cp5;
Table table;
ArrayList<State> stateArray;
int stateIndex = 0;
DropdownList stateMenu;
Slider filter;
String s;
String currentState;
int percent;
String selectedState = "";
RadioButton r;
boolean percentageMode = false;


void setup(){
  size(700, 680,P3D);
  cp5 = new ControlP5(this);
  s = "How\nPeople\nGet\nTo\nWork";
  
  stateMenu = cp5.addDropdownList("myList-d1").setPosition(500, 40);
  getData();
  numPerButtons();
  
  addMouseWheelListener();
  fill(0);
  textSize(40);
  
}

boolean overRect(int x, int y, int rwidth, int rheight) {
  if (mouseX >= x && mouseX <= x+rwidth && 
      mouseY >= y && mouseY <= y+rheight) {
    return true;
  } else {
    return false;
  }
}

void slider(int range){
  filter = cp5.addSlider("filter").setPosition(670, 400).setSize(20,250).setRange(0,range).setValue(range);
  cp5.getController("filter").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(0);
  cp5.getController("filter").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
}

void numPerButtons(){
  fill(0);
  r = cp5.addRadioButton("radioButton")
         .setPosition(450,620)
         .setSize(40,20)
         .setColorForeground(color(0))
         .setColorActive(color(20))
         .setColorLabel(color(255))
         .setItemsPerRow(5)
         .setSpacingColumn(60)
         .addItem("Percentage",1)
         .addItem("Numbers",2)
       
         ;
     
     for(Toggle t:r.getItems()) {
       t.captionLabel().setColorBackground(color(0,80));
       t.captionLabel().style().moveMargin(-7,0,0,-3);
       t.captionLabel().style().movePadding(7,0,0,3);
       t.captionLabel().style().backgroundWidth = 60;
       t.captionLabel().style().backgroundHeight = 13;
     }
     
     r.activate(0);
}


void makeTreeMap(int state){
  
  State USA = stateArray.get(state);  
  int commute = USA.droveAlone + USA.carPooled + USA.publicTransport;
  int noCar = USA.walked + USA.other + USA.workedAtHome;
  int total = USA.totalWorkers;
  double travelTime = USA.meanMinutesToWork;
  
  float commutePercent = (float)commute/total;
  float noCarPercent = (float)noCar/total;
  
  float driveAlone = (float)USA.droveAlone/commute;
  float carPool = (float)USA.carPooled/commute;
  float pub = (float)USA.publicTransport/commute;
  float walk = (float)USA.walked/noCar;
  float other = (float)USA.other/noCar;
  float home = (float)USA.workedAtHome/noCar;
  
  int parentWidth = 500;
  int parentHeight = 300;
  int parentX = 160;
  int parentY = 60;
  
  fill(255);
  rect(parentX, parentY, parentWidth, parentHeight);
  rect(parentX, parentY, commutePercent*parentWidth, parentHeight);
  rect(parentX + commutePercent*parentWidth, parentY, noCarPercent*parentWidth, parentHeight);
  
  fill(#FF0000);
  rect(parentX, parentY, commutePercent*parentWidth, driveAlone*parentHeight);
  if(insideBox(parentX, parentY, commutePercent*parentWidth, driveAlone*parentHeight)){
    fill(0);
  }
  fill(#CC0099);
  rect(parentX, parentY + driveAlone*parentHeight, commutePercent*parentWidth, carPool*parentHeight);
  fill(#FF9966);
  rect(parentX, parentY + driveAlone*parentHeight + carPool*parentHeight, commutePercent*parentWidth, pub*parentHeight);
  
  fill(#00FF99);
  rect(parentX + commutePercent*parentWidth, parentY, noCarPercent*parentWidth, walk*parentHeight);
  fill(#66FF33);
  rect(parentX + commutePercent*parentWidth, parentY + walk*parentHeight, noCarPercent*parentWidth, other*parentHeight);
  fill(#006600);
  rect(parentX + commutePercent*parentWidth, parentY + walk*parentHeight + other*parentHeight, noCarPercent*parentWidth, home*parentHeight);  
  
  fill(0);
  textSize(32);
  text(USA.state, 270, 40);
  textSize(12);
  text("Commuting", parentX, 55);
  text("No Car", parentX+ commutePercent*parentWidth, 55);
  
  text("Drive Alone", parentX+5, parentY + (driveAlone*parentHeight)/2);
  text("Carpool", parentX+5, parentY + driveAlone*parentHeight + (carPool*parentHeight)/1.5);
  text("Public Transit", parentX+5, parentY + driveAlone*parentHeight + carPool*parentHeight + (pub*parentHeight)/1.2);
  
  text("Walk", parentX + commutePercent*parentWidth, parentY + (walk*parentHeight)/2);
  text("Other", parentX + commutePercent*parentWidth, parentY + walk*parentHeight + (other*parentHeight)/2);
  text("Home", parentX + commutePercent*parentWidth, parentY + walk*parentHeight + other*parentHeight + (home*parentHeight)/2);
  
}

void createDetails(String statName, int value, int total){
  rect(mouseX, mouseY-30, 50, 30);
  System.out.println(statName+": " + value+"\nTotal: " + total);
}

boolean insideBox(int XCorner, int YCorner, float boxWidth, float boxHeight){
  
  if(mouseX > XCorner && mouseX < XCorner+boxWidth && 
     mouseY > YCorner && mouseY < YCorner+boxHeight){
       return true;
     }else{
       return false;
     }
}

//dropdown menu
void customize(DropdownList ddl, ArrayList<State> states) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(30, 150, 150));
  ddl.setWidth(160);
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("States");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;

  for(State st: states){
    ddl.addItem(st.state, states.indexOf(st));
  }
  //ddl.scroll(0);
  ddl.setColorBackground(color(40));
  ddl.setColorActive(color(0, 128));
}



void getData(){
  table = loadTable("CommuterData.csv", "header");
  stateArray = new ArrayList<State>();
  
  for(TableRow row : table.rows()){
    String state = row.getString("State");
    String abbreviation = row.getString("Abbreviation");
    int totalWorkers = row.getInt("Total Workers");
    int droveAlone = row.getInt("Drove Alone");
    int carPooled = row.getInt("Car-pooled");
    int publicTransport = row.getInt("Used Public Transportation");
    int walked = row.getInt("Walked");
    int other = row.getInt("Other");
    int workedAtHome = row.getInt("Worked at home");
    double meanMinutesToWork = row.getDouble("Mean travel time to work (minutes)");
    
    stateArray.add(new State(state,abbreviation, totalWorkers,droveAlone,carPooled,publicTransport,walked,other,workedAtHome,meanMinutesToWork));
  }
  
  customize(stateMenu, stateArray);
}


void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.
  
  if(theEvent.isFrom(r)) {
    percentageMode = !percentageMode;
    if(!percentageMode){
      slider(133091043);
    }
    else{
      slider(100);
    }
    println("percentage mode: " + Boolean.toString(percentageMode));
  }
  
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    stateIndex = (int)theEvent.getGroup().getValue();
    currentState = stateArray.get(stateIndex).state;
    //println(currentState);
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    percent = (int)theEvent.getController().getValue();
  }
}

void addMouseWheelListener(){
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e){
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  });
}



void doPercentage(){
  int rectWidth = 30;
  int rectDefaultHeight = 1;
  int currentX = 18; 
  int xIncrement = 15;
  int yRect = 440;
  int detailsY = 28;
  boolean hovering1 = false, hovering2 = false, hovering3 = false, hovering4 = false, hovering5 = false, hovering6 = false;
  boolean hasSelected = false;
  int count = 0;
  
  Percentage droveAlonePercent = new Percentage( stateArray ,"DroveAlone");
  
  Percentage CarPooledPercent = new Percentage( stateArray ,"CarPooled");
  
  Percentage PublicTransPercent = new Percentage( stateArray ,"PublicTrans");
  
  Percentage WalkedPercent = new Percentage( stateArray ,"Walked");
  
  Percentage HomePercent = new Percentage( stateArray ,"Other");
  
  Percentage OtherPercent = new Percentage( stateArray ,"Other");
  
  List <StatePercent> droveAloneList,CarPooledList, PublicTransList, WalkedList, HomeList, OtherList;
  
  if(percentageMode){
    droveAloneList = droveAlonePercent.calculatePercentage(percent);
    CarPooledList = CarPooledPercent.calculatePercentage(percent);
    PublicTransList = PublicTransPercent.calculatePercentage(percent);
    WalkedList = WalkedPercent.calculatePercentage(percent);
    HomeList = HomePercent.calculatePercentage(percent);
    OtherList = OtherPercent.calculatePercentage(percent);
    
    //Drove Alone
  String text1 = "Drove Alone";
  textSize(12);
  stroke(0);
  fill(0);
  text(text1, currentX, yRect - 22);
  for(int i = 0; i < droveAloneList.size(); i++){
      if(droveAloneList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = droveAloneList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering1 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + droveAloneList.get(i).percent*2));
          if(hovering1){
             hasSelected = true;
          }
          if(hovering1 || selectedState.equals(droveAloneList.get(i).state)){
            droveAloneList.get(i).selected = true;
            selectedState = droveAloneList.get(i).state;
            fill(0);
          }
          else{
            fill(255);
          }
          
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + droveAloneList.get(i).percent*2));
          
          
          if(droveAloneList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(droveAloneList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + droveAloneList.get(i).percent*2) + detailsY);
          }
          currentX += rectWidth;
      }
      
  } 
  println(currentX);
  currentX = 108;
  currentX += xIncrement;
  
  //Car pooled
  count = 0;
  String text2 = "Car Pooled";
  textSize(12);
  stroke(0);
  fill(0);
  text(text2, currentX, yRect - 22);
  
  for(int i = 0; i < 3; i++){
      if(CarPooledList.get(i).percent <= percent && count < 3){
        count++;
        fill(0);//for state initials
        String stateInitials = CarPooledList.get(i).state;
        text(stateInitials, currentX, yRect - 5);
              
        hovering2 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + CarPooledList.get(i).percent*2) );
        if(hovering2){
           hasSelected = true;
        }
        if(hovering2 || selectedState.equals(CarPooledList.get(i).state)){
          CarPooledList.get(i).selected = true;
          selectedState = CarPooledList.get(i).state;
          fill(0);
        }
        else{
          fill(255);       
  
        }
        
        rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + CarPooledList.get(i).percent*2));
        
        if(CarPooledList.get(i).selected){
          fill(0);
          DecimalFormat df = new DecimalFormat("#.##");
          text(df.format(CarPooledList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + CarPooledList.get(i).percent*2) + detailsY);
        }
        currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 213;
  currentX += xIncrement;
  
  //public trans
  count = 0;
  String text3 = "Public Trans";
  textSize(12);
  stroke(0);
  fill(0);
  text(text3, currentX, yRect - 22);
  
  for(int i = 0; i < 3; i++){
      if(PublicTransList.get(i).percent <= percent && count < 3){
         count++;
        fill(0);//for state initials
        String stateInitials = PublicTransList.get(i).state;
        text(stateInitials, currentX,yRect - 5);
              
        hovering3 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + PublicTransList.get(i).percent*2) );
        if(hovering3){
           hasSelected = true;
        }
        if(hovering3 || selectedState.equals(PublicTransList.get(i).state)){
          PublicTransList.get(i).selected = true;
          selectedState = PublicTransList.get(i).state;
          fill(0);
        }
        else{
          fill(255);       
        }
  
        rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + PublicTransList.get(i).percent*2));
        
        if(PublicTransList.get(i).selected){
          fill(0);
          DecimalFormat df = new DecimalFormat("#.##");
          text(df.format(PublicTransList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + PublicTransList.get(i).percent*2) + detailsY);
        }
        currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 318;
  currentX += xIncrement;
  
  //walked
  String text4 = "Walked";
  textSize(12);
  stroke(0);
  fill(0);
  text(text4, currentX, yRect - 22);
   count = 0; 
 
  
  for(int i = 0; i < 3; i++){
      if(WalkedList.get(i).percent <= percent && count < 3){
        count++;
          fill(0);//for state initials
          String stateInitials = WalkedList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering4 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + WalkedList.get(i).percent*2) );
          if(hovering4){
             hasSelected = true;
          }
          if(hovering4 || selectedState.equals(WalkedList.get(i).state)){
            WalkedList.get(i).selected = true;
            selectedState = WalkedList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + WalkedList.get(i).percent*2));
          
          if(WalkedList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(WalkedList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + WalkedList.get(i).percent*2) + detailsY);
          }
          currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 423;
  currentX += xIncrement;
  
  //other
  String text5 = "Other";
  textSize(12);
  stroke(0);
  fill(0);
  text(text5, currentX, yRect - 22);
  count = 0;
  
  
  for(int i = 0; i < 3; i++){
      if(OtherList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = OtherList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering5 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + OtherList.get(i).percent*2) );
          if(hovering5){
             hasSelected = true;
          }
          if(hovering5 || selectedState.equals(OtherList.get(i).state)){
            OtherList.get(i).selected = true;
            selectedState = OtherList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + OtherList.get(i).percent*2));
          
          if(OtherList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(OtherList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + OtherList.get(i).percent*2) + detailsY);
          }
          currentX += rectWidth;
          
      }
  } 
  println(currentX);
  currentX = 528;
  currentX += xIncrement;
  
  //Home
  String text6 = "Home";
  textSize(12);
  stroke(0);
  fill(0);
  text(text6, currentX, yRect - 22);
  count = 0;
 
  
  for(int i = 0; i < 3; i++){
      if(HomeList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = HomeList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering6 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + HomeList.get(i).percent*2) );
          if(hovering6){
             hasSelected = true;
          }
          if(hovering6 || selectedState.equals(HomeList.get(i).state)){
            HomeList.get(i).selected = true;
            selectedState = HomeList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + HomeList.get(i).percent*2));
          
          if(HomeList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(HomeList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + HomeList.get(i).percent*2) + detailsY);
          }
          currentX += rectWidth;
          
      }
  } 
  
  if(hasSelected == false){
    selectedState = "";
  }
  
  
  //println("----------------------------------");

  }
  
  
  
  //numbers mode
  else{
    droveAloneList = droveAlonePercent.calculateNumbers(percent);
    CarPooledList = CarPooledPercent.calculateNumbers(percent);
    PublicTransList = PublicTransPercent.calculateNumbers(percent);
    WalkedList = WalkedPercent.calculateNumbers(percent);
    HomeList = HomePercent.calculateNumbers(percent);
    OtherList = OtherPercent.calculateNumbers(percent);
    
    int divided = 60000;
    
    //Drove Alone
  String text1 = "Drove Alone";
  textSize(12);
  stroke(0);
  fill(0);
  text(text1, currentX, yRect - 22);
  for(int i = 0; i < droveAloneList.size(); i++){
      if(droveAloneList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = droveAloneList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering1 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + droveAloneList.get(i).percent / divided));
          if(hovering1){
             hasSelected = true;
          }
          if(hovering1 || selectedState.equals(droveAloneList.get(i).state)){
            droveAloneList.get(i).selected = true;
            selectedState = droveAloneList.get(i).state;
            fill(0);
          }
          else{
            fill(255);
          }
          
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + droveAloneList.get(i).percent/ divided));
          
          
          if(droveAloneList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(droveAloneList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + droveAloneList.get(i).percent/ divided) + detailsY);
          }
          currentX += rectWidth;
      }
      
  } 
  println(currentX);
  currentX = 108;
  currentX += xIncrement;
  
  //Car pooled
  count = 0;
  String text2 = "Car Pooled";
  textSize(12);
  stroke(0);
  fill(0);
  text(text2, currentX, yRect - 22);
  
  for(int i = 0; i < 3; i++){
      if(CarPooledList.get(i).percent <= percent && count < 3){
        count++;
        fill(0);//for state initials
        String stateInitials = CarPooledList.get(i).state;
        text(stateInitials, currentX, yRect - 5);
              
        hovering2 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + CarPooledList.get(i).percent/ divided) );
        if(hovering2){
           hasSelected = true;
        }
        if(hovering2 || selectedState.equals(CarPooledList.get(i).state)){
          CarPooledList.get(i).selected = true;
          selectedState = CarPooledList.get(i).state;
          fill(0);
        }
        else{
          fill(255);       
  
        }
        
        rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + CarPooledList.get(i).percent/ divided));
        
        if(CarPooledList.get(i).selected){
          fill(0);
          DecimalFormat df = new DecimalFormat("#.##");
          text(df.format(CarPooledList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + CarPooledList.get(i).percent/ divided) + detailsY);
        }
        currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 213;
  currentX += xIncrement;
  
  //public trans
  count = 0;
  String text3 = "Public Trans";
  textSize(12);
  stroke(0);
  fill(0);
  text(text3, currentX, yRect - 22);
  
  for(int i = 0; i < 3; i++){
      if(PublicTransList.get(i).percent <= percent && count < 3){
         count++;
        fill(0);//for state initials
        String stateInitials = PublicTransList.get(i).state;
        text(stateInitials, currentX,yRect - 5);
              
        hovering3 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + PublicTransList.get(i).percent/ divided) );
        if(hovering3){
           hasSelected = true;
        }
        if(hovering3 || selectedState.equals(PublicTransList.get(i).state)){
          PublicTransList.get(i).selected = true;
          selectedState = PublicTransList.get(i).state;
          fill(0);
        }
        else{
          fill(255);       
        }
  
        rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + PublicTransList.get(i).percent/ divided));
        
        if(PublicTransList.get(i).selected){
          fill(0);
          DecimalFormat df = new DecimalFormat("#.##");
          text(df.format(PublicTransList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + PublicTransList.get(i).percent/ divided) + detailsY);
        }
        currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 318;
  currentX += xIncrement;
  
  //walked
  String text4 = "Walked";
  textSize(12);
  stroke(0);
  fill(0);
  text(text4, currentX, yRect - 22);
   count = 0; 
 
  
  for(int i = 0; i < 3; i++){
      if(WalkedList.get(i).percent <= percent && count < 3){
        count++;
          fill(0);//for state initials
          String stateInitials = WalkedList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering4 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + WalkedList.get(i).percent/ divided) );
          if(hovering4){
             hasSelected = true;
          }
          if(hovering4 || selectedState.equals(WalkedList.get(i).state)){
            WalkedList.get(i).selected = true;
            selectedState = WalkedList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + WalkedList.get(i).percent/ divided));
          
          if(WalkedList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(WalkedList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + WalkedList.get(i).percent/ divided) + detailsY);
          }
          currentX += rectWidth;
      }
  } 
  println(currentX);
  currentX = 423;
  currentX += xIncrement;
  
  //other
  String text5 = "Other";
  textSize(12);
  stroke(0);
  fill(0);
  text(text5, currentX, yRect - 22);
  count = 0;
  
  
  for(int i = 0; i < 3; i++){
      if(OtherList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = OtherList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering5 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + OtherList.get(i).percent/ divided) );
          if(hovering5){
             hasSelected = true;
          }
          if(hovering5 || selectedState.equals(OtherList.get(i).state)){
            OtherList.get(i).selected = true;
            selectedState = OtherList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + OtherList.get(i).percent/ divided));
          
          if(OtherList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(OtherList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + OtherList.get(i).percent/ divided) + detailsY);
          }
          currentX += rectWidth;
          
      }
  } 
  println(currentX);
  currentX = 528;
  currentX += xIncrement;
  
  //Home
  String text6 = "Home";
  textSize(12);
  stroke(0);
  fill(0);
  text(text6, currentX, yRect - 22);
  count = 0;
 
  
  for(int i = 0; i < 3; i++){
      if(HomeList.get(i).percent <= percent && count < 3){
          count++;
          fill(0);//for state initials
          String stateInitials = HomeList.get(i).state;
          text(stateInitials, currentX,yRect - 5);
                
          hovering6 = overRect(currentX, yRect, rectWidth, (int)(rectDefaultHeight + HomeList.get(i).percent/ divided) );
          if(hovering6){
             hasSelected = true;
          }
          if(hovering6 || selectedState.equals(HomeList.get(i).state)){
            HomeList.get(i).selected = true;
            selectedState = HomeList.get(i).state;
            fill(0);
          }
          else{
            fill(255);       
          }
          rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight + HomeList.get(i).percent/ divided));
          
          if(HomeList.get(i).selected){
            fill(0);
            DecimalFormat df = new DecimalFormat("#.##");
            text(df.format(HomeList.get(i).percent) + "%",currentX,yRect +  (int)(rectDefaultHeight + HomeList.get(i).percent/ divided) + detailsY);
          }
          currentX += rectWidth;
          
      }
  } 
  
  if(hasSelected == false){
    selectedState = "";
  }
  //println("----------------------------------");
  }
}




void draw(){
  background(255);
  fill(0);
  textSize(40);
  text(s, 5,50); 
  
  doPercentage();
  makeTreeMap(stateIndex);
}

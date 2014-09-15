import controlP5.*;
import java.util.List;
import org.gicentre.treemappa.*;
import org.gicentre.utils.colour.*;


ControlP5 cp5;
Table table;
ArrayList<State> stateArray;
DropdownList stateMenu;
Slider filter;
String s;
String currentState;
int percent;




void setup(){
  size(700, 680,P3D);
  cp5 = new ControlP5(this);
  s = "How\nPeople\nGet\nTo\nWork";
  
  stateMenu = cp5.addDropdownList("myList-d1").setPosition(500, 40);
 
  filter = cp5.addSlider("filter").setPosition(670, 400).setSize(20,250).setRange(0,100).setValue(100);
  cp5.getController("filter").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(0);
  cp5.getController("filter").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  getData(); //<>//
  
  addMouseWheelListener();
  
  createTreemap();
  
  fill(0);
  textSize(40);
  
}

void createTreemap(){
  PTreeMappa totalTreeMap;
 
  totalTreeMap = new PTreeMappa(this);
  //totalTreeMap.readData("CommuterData.csv");
  
  State USA = stateArray.get(0);
  int commute = USA.droveAlone + USA.carPooled + USA.publicTransport;
  int noCar = USA.walked + USA.other + USA.workedAtHome;
  int total = USA.totalWorkers;
  double travelTime = USA.meanMinutesToWork; 
  
  TreeMapNode testUSA = new TreeMapNode(USA.abbreviation, 0.0, (float)total, (float)color(255,255,100));
  TreeMapNode cars = new TreeMapNode("Driving", 1.0, (float)commute, (float)color(100, 255, 255));
  TreeMapNode noCarNode = new TreeMapNode("Not Driving", 1.0, (float)noCar, (float)color(255, 100, 100));
  
  TreeMapNode droveAlone = new TreeMapNode("Drove Alone", 0.0, (float)USA.droveAlone, (float)color(30, 30, 30));
  TreeMapNode carPool = new TreeMapNode("Carpooled", 0.0, (float)USA.carPooled, (float)color(20, 20, 20));
  TreeMapNode publicTrans = new TreeMapNode("Public Transportation", 0.0, (float)USA.publicTransport, (float)color(30, 30, 30));
  
  TreeMapNode walk = new TreeMapNode("Walked", 0.0, (float)USA.walked, (float)color(70, 70, 70));
  TreeMapNode other = new TreeMapNode("Other", 0.0, (float)USA.other, (float)color(80, 80, 80));
  TreeMapNode home = new TreeMapNode("Worked at Home", 0.0, (float)USA.workedAtHome, (float)color(80, 80, 80));
  
  cars.add(droveAlone);
  cars.add(carPool);
  cars.add(publicTrans);
  
  noCarNode.add(walk);
  noCarNode.add(other);
  noCarNode.add(home);
  
  testUSA.add(cars);
  testUSA.add(noCarNode);
  
  TreeMapNode rootNode = testUSA;
  
  totalTreeMap.getTreeMapPanel().setBorders(4);
  totalTreeMap.getTreeMapPanel().setBorder(0,0);
  
  //totalTreeMap.draw(); 
  
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

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    int index = (int)theEvent.getGroup().getValue();
    currentState = stateArray.get(index).state;
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
  int rectDefaultHeight = 18;
  int currentX = 18; 
  int xIncrement = 15;
  int yRect = 440;
  
  //Drove Alone
  String text1 = "Drove Alone";
  textSize(12);
  stroke(0);
  fill(0);
  text(text1, currentX, yRect - 22);
  
  Percentage droveAlonePercent = new Percentage( stateArray ,"DroveAlone");
  List <StatePercent> droveAloneList = droveAlonePercent.calculatePercentage(percent);
  
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = droveAloneList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * droveAloneList.get(i).percent));
      currentX += rectWidth;
  } 
  
  
  currentX += xIncrement;
  
  //Car pooled
  String text2 = "Car Pooled";
  textSize(12);
  stroke(0);
  fill(0);
  text(text2, currentX, yRect - 22);
  
  Percentage CarPooledPercent = new Percentage( stateArray ,"CarPooled");
  List <StatePercent> CarPooledList = CarPooledPercent.calculatePercentage(percent);
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = CarPooledList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * CarPooledList.get(i).percent));
      currentX += rectWidth;
  }
  
  currentX += xIncrement;
  
  //public trans
  String text3 = "Public Trans";
  textSize(12);
  stroke(0);
  fill(0);
  text(text3, currentX, yRect - 22);
  
  Percentage PublicTransPercent = new Percentage( stateArray ,"PublicTrans");
  List <StatePercent> PublicTransList = PublicTransPercent.calculatePercentage(percent);
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = PublicTransList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * PublicTransList.get(i).percent));
      currentX += rectWidth;
  }
  
  currentX += xIncrement;
  
  //walked
  String text4 = "Walked";
  textSize(12);
  stroke(0);
  fill(0);
  text(text4, currentX, yRect - 22);
  
  Percentage WalkedPercent = new Percentage( stateArray ,"Walked");
  List <StatePercent> WalkedList = WalkedPercent.calculatePercentage(percent);
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = WalkedList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * WalkedList.get(i).percent));
      currentX += rectWidth;
  }
  
  currentX += xIncrement;
  
  //other
  String text5 = "Other";
  textSize(12);
  stroke(0);
  fill(0);
  text(text5, currentX, yRect - 22);
  
  Percentage OtherPercent = new Percentage( stateArray ,"Other");
  List <StatePercent> OtherList = OtherPercent.calculatePercentage(percent);
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = OtherList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * OtherList.get(i).percent));
      currentX += rectWidth;
  }
  
  currentX += xIncrement;
  
  //Home
  String text6 = "Home";
  textSize(12);
  stroke(0);
  fill(0);
  text(text6, currentX, yRect - 22);
  
  Percentage HomePercent = new Percentage( stateArray ,"Other");
  List <StatePercent> HomeList = HomePercent.calculatePercentage(percent);
  
  for(int i = 0; i < 3; i++){
      fill(0);
      String stateInitials = HomeList.get(i).state;
      text(stateInitials, currentX,yRect - 5);
      fill(255);
      rect(currentX, yRect, rectWidth, (float)(rectDefaultHeight * HomeList.get(i).percent));
      currentX += rectWidth;
  }
  
  

}

void draw(){
  background(255);
  fill(0);
  textSize(40);
  text(s, 5,50); 
  
  doPercentage();
}

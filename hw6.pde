import controlP5.*;
ControlP5 cp5;
Table table;
ArrayList<State> stateArray;
DropdownList stateMenu;
Slider filter;
String s;
String currentState;
int percent;

void setup(){
  size(700, 700,P3D);
  cp5 = new ControlP5(this);
  s = "How\nPeople\nGet\nTo\nWork";
  
  stateMenu = cp5.addDropdownList("myList-d1").setPosition(500, 350);
 
  filter = cp5.addSlider("filter").setPosition(670, 400).setSize(20,250).setRange(0,100).setValue(100);
  cp5.getController("filter").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(0);
  cp5.getController("filter").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  getData();
  
  addMouseWheelListener();
  
  fill(0);
  textSize(40);
  
}



//dropdown menu
void customize(DropdownList ddl, ArrayList<State> states) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(130));
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
  Percentage droveAlonePercent = new Percentage( stateArray ,"DroveAlone");
  droveAlonePercent.calculatePercentage(percent);
}

void draw(){
  background(255);
  text(s, 5,50); 
  
  doPercentage();
}



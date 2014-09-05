import controlP5.*;
ControlP5 cp5;
Table table;
ArrayList<State> stateArray;
DropdownList stateMenu;
Slider filter;

void setup(){
  size(700, 700,P3D);
  cp5 = new ControlP5(this);
  
  stateMenu = cp5.addDropdownList("myList-d1").setPosition(500, 350);
  filter = cp5.addSlider("filter").setPosition(670, 400).setSize(20,250).setRange(0,100).setValue(50);
  cp5.getController("filter").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(0);
  cp5.getController("filter").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  table = loadTable("CommuterData.csv", "header");
  stateArray = new ArrayList<State>();
  
  for(TableRow row : table.rows()){
    String state = row.getString("State");
    int totalWorkers = row.getInt("Total Workers");
    int droveAlone = row.getInt("Drove Alone");
    int carPooled = row.getInt("Car-pooled");
    int publicTransport = row.getInt("Used Public Transportation");
    int walked = row.getInt("Walked");
    int other = row.getInt("Other");
    int workedAtHome = row.getInt("Worked at home");
    double meanMinutesToWork = row.getDouble("Mean travel time to work (minutes)");
    
    stateArray.add(new State(state,totalWorkers,droveAlone,carPooled,publicTransport,walked,other,workedAtHome,meanMinutesToWork));
  }
  
  customize(stateMenu, stateArray);
  addMouseWheelListener();
  
  /*
  for(int i =0; i < stateArray.size(); i++){
    println("state: " + stateArray.get(i).state + " totalWorkers: " + stateArray.get(i).totalWorkers + " drove alone: " + 
    stateArray.get(i).droveAlone);
  }
  */
  
}

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


void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void addMouseWheelListener(){
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e){
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  });
}

void draw(){
  background(128);
}

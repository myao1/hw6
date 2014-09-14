class State{
  
  String state;
  String abbreviation;
  int totalWorkers;
  int droveAlone;
  int carPooled;
  int publicTransport;
  int walked;
  int other;
  int workedAtHome;
  double meanMinutesToWork;
  
  public State(String state, String abbreviation, int totalWorkers, int droveAlone, int carPooled, int publicTransport, int walked, int other, int workedAtHome, double meanMinutesToWork){
    this.state = state;
    this.abbreviation = abbreviation;
    this.totalWorkers = totalWorkers;
    this.droveAlone = droveAlone;
    this.carPooled = carPooled;
    this.publicTransport = publicTransport;
    this.walked = walked;
    this.other = other;
    this.workedAtHome = workedAtHome;
    this.meanMinutesToWork = meanMinutesToWork;
  }
  
  
}

import java.util.Comparator;

class percentComparator implements Comparator<StatePercent>{
 
    @Override
    public int compare(StatePercent p1, StatePercent p2) {
        if(p1.percent < p2.percent){
            return 1;
        } else {
            return -1;
        }
    }
}

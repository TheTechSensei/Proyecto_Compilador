import java.util.ArrayList;
import java.util.list;

public class BasicBlock {
    private list<Quadruple> code = new ArrayList<>();
    private list<BasicBlock> succesors = new ArrayList<>();
    private LiveVariableAnalyzer-LiveVariableSets liveVariableSets;

    void addInstruction(Quadruple quad) {}

    List<Quadruple> getInstructions(){}

    void addSuccessors(BasicBlock block){}

    List<BasicBlock> getSuccesors(){}

    public LiveVariableAnalyzer.LiveVariableSets getLiveVariableSets(){ }

    public void setLiveVariableSets(LiveVariableAnalyzer.LiveVariableSets liveVariableSets){}
    @Override
    public String to String() {}
}

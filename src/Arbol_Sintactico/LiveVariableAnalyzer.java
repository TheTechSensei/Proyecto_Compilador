import java.util.HashMap;
import java.util.HashSet;
import java.util.list;
import java.util.Map;
import java.util.Set;

public class LiveVariableAnalyzer{
    private ControlFlowGraph cfg;

    public LiveVariableAnalyzer(ControlFlowGraph cfg){
        this.cfg = cfg;
    }
    public Map<BasicBlock LiveVariableSets> analyze(){
        Map<BasicBlock LiveVariableSets> liveVarSets = initialSets();
        boolean changed = true;

        return liveVarSets;
    }

    private Map<BasicBlock LiveVariableSets> initializeSets(){
        Map<BasicBlock LiveVariableSets> liveVarSets = new HashMap<>();

        return liveVarSets;
    }

    private Set<String> computeOut(BasicBlock block, Map<BasicBlock>, LiveVariableSets> liveVarSets){
        Set<String> out = new HashSet<>();

        return out;
    }
}

import jason.architecture.AgArch;
import jason.asSemantics.ActionExec;
import jason.asSemantics.Agent;
import jason.asSemantics.TransitionSystem;

import jason.asSyntax.*;
import java.util.*;
import java.util.List;

public class BDIAgent extends AgArch {

    /** general delegations */
    private List<Condition> conditions;
    private String ExecutedActionStr;
    private Actions ExecutedAction;


    private long lastPerceptionTimestamp;
    protected long currentPerceptionTimestamp;
    private boolean firstPerception;
    private boolean running;

     public BDIAgent(int number) {
        try {
            Agent ag = new Agent();
            new TransitionSystem(ag, null, null, this);

            switch (number % 5) {
                case 0:
                    System.out.println("attacker is initialized");
                    ag.initAg("ag.asl");
                    break;
                case 1:
                    System.out.println("defender is initialized");
                    ag.initAg("defender.asl");
                    break;
                case 2:
                    System.out.println("goalie is initialized");
                    ag.initAg("goalie.asl");
                    break;
                case 3:
                    System.out.println("defender is initialized");
                    ag.initAg("defender.asl");
                    break;
                case 4:
                    System.out.println("attacker is initialized");
                    ag.initAg("ag.asl");
                    break;
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        firstPerception = true;
        running = false;
    }

    public void run() {
        try {
            running = true;

            while (isRunning()) {
                // calls the Jason engine to perform one reasoning cycle
                getTS().reasoningCycle();

                if (getTS().canSleep()) {
                    sleep();
                }else if(Thread.currentThread().getState() == Thread.State.TIMED_WAITING){
                    wake();
                }
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void setConditions(List<Condition> conditionsFromAgentBrain) {
        conditions = conditionsFromAgentBrain;
    }

    public Actions getExecutedAction() {
        if(ExecutedActionStr != null) {
            ExecutedAction = Actions.valueOf(ExecutedActionStr);
        }
         return ExecutedAction;
    }

    // this method just add some perception for the agent
    @Override
    public List<Literal> perceive() {
        System.out.println("conditions: " + conditions);

        List<Literal> l = new ArrayList<>();

        for (Condition condition: conditions) {
            Literal literal = ASSyntax.createLiteral(condition.name());
            l.add(literal);
        }

        return l;
    }

    @Override
    public void act(ActionExec action) {
         ExecutedActionStr = action.getActionTerm().getFunctor();
         System.out.println(" ExecutedAction : " +  ExecutedActionStr );
         // set that the execution was ok
         action.setResult(true);
         actionExecuted(action);

         running = false;
    }

    @Override
    public boolean canSleep() {
        if ((firstPerception) || (currentPerceptionTimestamp != lastPerceptionTimestamp)) {
            firstPerception = false;	// No longer the first perception
            this.lastPerceptionTimestamp = currentPerceptionTimestamp;	// Update the perception ID
            return false;
        } else
            return true;
    }

    @Override
    public boolean isRunning() {
        return running;
    }

    // a very simple implementation of sleep
    private void sleep() {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {}
    }

    // Not used methods
    // This simple agent does not need messages/control/...
    @Override
    public void sendMsg(jason.asSemantics.Message m) throws Exception {
    }

    @Override
    public void broadcast(jason.asSemantics.Message m) throws Exception {
    }

    @Override
    public void checkMail() {
    }
    	
}

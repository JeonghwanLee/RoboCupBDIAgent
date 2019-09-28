import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

public class SoccerEnvironment {

    public long timeStamp;
    private Vector<ObjectInfo> playerList;
    private String m_team;

    //Load environment knowledge base
    protected List<Condition> CheckConditions(Memory memory, char side){
        List<Condition> conditions = new ArrayList<>();
        ObjectInfo ball;
        ObjectInfo ownGoal;
        ObjectInfo oppositeGoal;
        PlayerInfo nearestPlayerToBall = new PlayerInfo();

        ball = memory.getObject("ball");
        if( side == 'l' ) {
            ownGoal = memory.getObject("goal l");
            oppositeGoal = memory.getObject("goal r");

        }else {
            oppositeGoal = memory.getObject("goal l");
            ownGoal = memory.getObject("goal r");
        }

        if( ball != null ){
            conditions.add(Condition.canSeeBall);
        }
        if( ownGoal != null ){
            conditions.add(Condition.canSeeOwnGoal);
        }
        if( ball != null && ball.m_distance <= 1.0 ){
            conditions.add(Condition.nextToBall);
        }
        if( ball != null &&  ball.m_distance > 1.0 && ball.m_distance <= 15 ){
            conditions.add(Condition.closeToBall);
        }
        if( ball != null &&  ball.m_distance > 15 && ball.m_distance < 25 ){
            conditions.add(Condition.awayFromBall);
        }
        if( ball != null &&  ball.m_distance >= 25 ){
            conditions.add(Condition.farAwayFromBall);
        }
        if(ownGoal != null && ownGoal.m_distance <= 16.8){
            conditions.add(Condition.nextToOwnGoal);
        }
        if(ownGoal != null && ownGoal.m_distance > 16.8){
            conditions.add(Condition.awayFromOwnGoal);
        }
        if(oppositeGoal != null && oppositeGoal.m_distance < 28.8){
            conditions.add(Condition.nextToOppositeGoal);
        }
        if((ownGoal != null && (ownGoal.m_distance < 52.8 && ownGoal.m_distance >= 28.8)) || (oppositeGoal != null && oppositeGoal.m_distance < 76.8 && oppositeGoal.m_distance > 52.8)){
            conditions.add(Condition.inDefenderArea);
        }
        if( (ownGoal != null && ownGoal.m_distance < 28.8) || (oppositeGoal != null && oppositeGoal.m_distance > 76.8)){

            conditions.add(Condition.beforeDefenderArea);
        }
        if(ball != null){
            if(nearestPlayerToBall != null){
                ball.getPosition();
                nearestPlayerToBall.getPosition();
                if(nearestPlayerToBall.getDistance(ball) < ball.m_distance){
                    conditions.add(Condition.notNearestPlayerToBall);
                }
            }
        }
        if(ball != null && ownGoal !=null){
            ball.getPosition();
            ownGoal.getPosition();
            double distance = ball.getDistance(ownGoal);
            if(distance < 28.8){
                conditions.add(Condition.ballInDefenderArea);
            }
        }

        timeStamp = System.currentTimeMillis();
        return conditions;
    }

    public PlayerInfo getNearestTeammate(ObjectInfo obj)
    {
        PlayerInfo nearest = null;
        double dist = -1;

        for(int c = 0 ; c < playerList.size() ; c ++)
        {
            PlayerInfo player = (PlayerInfo)playerList.elementAt(c);
            if(player.m_teamName.equalsIgnoreCase(m_team))
            {
                double d = player.getDistance(obj);
                if( nearest == null || d < dist )
                {
                    nearest = player;
                    dist = d;
                }
            }
        }

        return nearest;
    }
}

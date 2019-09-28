

public enum Condition {
    canSeeBall,
    canSeeOwnGoal,
    awayFromBall,		            //Ball in view and between 1 and 10 meters away
    farAwayFromBall,		        //Ball in view and more than 10 meters away
    nextToBall,         //Ball less than 1 meter away
    closeToBall,
    nextToOwnGoal,	            //Player next to his team goal
    awayFromOwnGoal,
    nextToOppositeGoal,         //Player next to opposite team goal
    notNearestPlayerToBall,
    inDefenderArea,
    ballInDefenderArea,
    beforeDefenderArea,
    CanKickBall,
    CanScore
}

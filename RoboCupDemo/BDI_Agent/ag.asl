/* Initial Goal */
!see.

/* Plans to achieve goals */

// Plan to find a ball
+!see
    :   not canSeeBall & not beforeDefenderArea
    <-  turn;
        !see.

+!see
    :   canSeeBall & not beforeDefenderArea
    <-  dash_to_ball;
        -canSeeBall;
        !move.

+!see
    :   (not canSeeBall | (awayFromBall | farAwayFromBall)) & beforeDefenderArea
    <-  dash_to_opposite_goal;
        -awayFromBall;
        -canSeeBall;
        -farAwayFromBall;
        -beforeDefenderArea;
        !backToAttackerArea.

+!see
    :   closeToBall & beforeDefenderArea
    <-  dash_to_ball;
        -closeToBall;
        -canSeeBall;
        -beforeDefenderArea;
        !move.

// if anything fails in an attempt to achieve the goal, the
// contingency plan (-!findBall) reintroduces the goal again at all
// circumstances (note the empty plan context); this is what causes the
// "blind commitment" behaviour mentioned above
-!see
    <-  turn;
        !see.

// Plan to be close enough to a ball to kick
+!move
    :   canSeeBall & not (nextToBall | closeToBall)
    <-  dash_to_ball;
        -canSeeBall;
        !move.

+!move
    :   closeToBall & notNearestPlayerToBall
    <-  jog_to_ball;
        -canSeeBall;
        -closeToBall;
        !move.

+!move
    :   closeToBall & not notNearestPlayerToBall
    <-  dash_to_ball;
        -canSeeBall;
        -closeToBall;
        -nearestPlayerToBall;
        !move.

+!move
    :   nextToBall
    <-  kick;
        -canSeeBall;
        -nextToBall;
        !move.

+!move
    :   (not canSeeBall | (awayFromBall | farAwayFromBall)) & beforeDefenderArea
    <-  dash_to_opposite_goal;
        -awayFromBall;
        -canSeeBall;
        -farAwayFromBall;
        -beforeDefenderArea;
        !backToAttackerArea.

+!move
    :   not canSeeBall
    <-  turn;
        !see.

-!move
    <-  turn;
        !move.

// Plan to be close enough to a ball to kick
+!backToAttackerArea
    :   (not canSeeBall | awayFromBall | farAwayFromBall) & beforeDefenderArea
    <-  dash_to_opposite_goal;
        -awayFromBall;
        -canSeeBall;
        -farAwayFromBall;
        -beforeDefenderArea;
        !backToAttackerArea.

+!backToAttackerArea
    :   closeToBall & beforeDefenderArea
    <-  dash_to_ball;
        -closeToBall;
        -canSeeBall;
        -beforeDefenderArea;
        !move.

+!backToAttackerArea
    :   canSeeBall & not beforeDefenderArea
    <-  dash_to_ball;
        -canSeeBall;
        !move.

+!backToAttackerArea
    :   not canSeeBall & not beforeDefenderArea
    <-  turn;
        !see.

-!backToAttackerArea
    <-  turn;
        !backToAttackerArea.

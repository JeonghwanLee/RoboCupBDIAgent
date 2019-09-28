/* Initial Goal */
!findBall.

/* Plans to achieve goals */

// ********* Plan to find a ball **********

//Turn if you can't see ball.
+!findBall
	:	not canSeeBall
	<-	turn;
        !findBall.

// If you found the ball and its away and you are not in the defender area, then go back to defender area.
+!findBall
	:	(awayFromBall | farAwayFromBall) & not inDefenderArea
	<-	observe;
	    -farAwayFromBall;
	    -awayFromBall;
	    -canSeeBall;
        !backToDefenderArea.

//if the ball is away and it's in the opposite side, then observe.
+!findBall
	:	(awayFromBall | farAwayFromBall) & inDefenderArea & not canSeeOwnGoal
	<-	observe;
	    -canSeeBall;
	    -farAwayFromBall;
	    -awayFromBall;
        !findBall.

//if the ball is away but it's in our side, then go defend and kick it.
+!findBall
	:	(awayFromBall | farAwayFromBall) & inDefenderArea & canSeeOwnGoal
	<-	dash_to_ball;
	    -canSeeOwnGoal;
	    -farAwayFromBall;
	    -awayFromBall;
	    -canSeeBall;
        !kickBall.

//if you found the ball next to you, then try to dash and kick it.
+!findBall
	:	 closeToBall | nextToBall
	<-	dash_to_ball;
	    -closeToBall;
	    -nextToBall;
	    -canSeeBall;
        !kickBall.

// if anything fails in an attempt to achieve the goal, the
// contingency plan (-!findBall) reintroduces the goal again at all
// circumstances (note the empty plan context); this is what causes the
// "blind commitment" behaviour mentioned above
-!findBall
    <-  observe;
        !findBall.


// ********* Plan to kick a ball ************

//If you can't see the ball, try to find it.
+!kickBall
	:	not canSeeBall
	<-	turn;
        !findBall.

//if you are next to the ball, try to kick it.
+!kickBall
	:	nextToBall
	<-	kick;
	    -nextToBall;
	    -canSeeBall;
        !kickBall.

//if you are close to ball, dash to it.
+!kickBall
	:	 closeToBall
	<-	dash_to_ball;
	    -closeToBall;
	    -canSeeBall;
        !kickBall.

//if you are away from the ball and the ball is in the opposite side and you're in the defender area, just observe.
+!kickBall
	:	(awayFromBall | farAwayFromBall) & inDefenderArea & not canSeeOwnGoal
	<-	observe;
	    -awayFromBall;
	    -canSeeBall;
	    -farAwayFromBall;
	    -inDefenderArea;
        !kickBall.

//if you are away from the ball and the ball is in our side , try to defend and dash to the ball.
+!kickBall
	:	(awayFromBall | farAwayFromBall) & inDefenderArea & canSeeOwnGoal
	<-	dash_to_ball;
	    -awayFromBall;
	    -canSeeBall;
	    -farAwayFromBall;
	    -inDefenderArea;
	    -canSeeOwnGoal;
        !kickBall.

//if you are away from the ball and in the goalie area, the go back to defender area.
+!kickBall
	:	(awayFromBall | farAwayFromBall)  & not inDefenderArea & beforeDefenderArea
	<-	dash_to_opposite_goal;
	    -awayFromBall;
	    -canSeeBall;
	    -farAwayFromBall;
	    -beforeDefenderArea;
        !backToDefenderArea.

//if you are away from the ball and beyond the defender area, the go back to defender area.
+!kickBall
	:	(awayFromBall | farAwayFromBall)  & not inDefenderArea & not beforeDefenderArea
	<-	dash_to_own_goal;
	    -canSeeBall;
	    -awayFromBall;
	    -farAwayFromBall;
        !backToDefenderArea.

// *********** Plan to back to own goal *****************

//if you can't see the ball and in the goalie area, dash to opposite goal and go back to defender area.
+!backToDefenderArea
	:	 not canSeeBall & beforeDefenderArea
	<-	dash_to_opposite_goal;
	    -beforeDefenderArea;
        !backToDefenderArea.

//if you can't see the ball and beyond the defender area, dash to own goal and go back to defender area.
+!backToDefenderArea
	:	 not canSeeBall & not beforeDefenderArea & not inDefenderArea
	<-	dash_to_own_goal;
        !backToDefenderArea.

//if you are in defender area and you can't see the ball, then turn around to see it.
+!backToDefenderArea
	: not canSeeBall & inDefenderArea
	<-	turn;
	    -inDefenderArea;
        !findBall.

//if you are in defender area and you can see the ball, just observe and transition to kickBall goal.
+!backToDefenderArea
	: canSeeBall & inDefenderArea
	<-	observe;
	    -canSeeBall;
	    -inDefenderArea;
        !kickBall.

//if you are in goalie area and away from ball, then go back to defender area by dashing to goal.
+!backToDefenderArea
	:	beforeDefenderArea  &  (awayFromBall | farAwayFromBall)
	<-	dash_to_ball;
	    -beforeDefenderArea;
	    -farAwayFromBall;
	    -awayFromBall;
	    -canSeeBall;
        !backToDefenderArea.

//if you area in goalie area and the ball is close, defend and dash to it.
+!backToDefenderArea
	:	beforeDefenderArea & (closeToBall | nextToBall)
	<-	dash_to_ball;
	    -beforeDefenderArea;
	    -canSeeBall;
        !kickBall.

//if you area outside goalie area and the ball is close, defend and dash to it.
+!backToDefenderArea
	:	not beforeDefenderArea  &  (closeToBall | nextToBall)
	<-	dash_to_ball;
	    -closeToBall;
	    -nextToBall;
	    -canSeeBall;
        !kickBall.

//if you are beyond defender area and away from ball,go back to defender area by dashing to own goal.
+!backToDefenderArea
	:	not beforeDefenderArea  &  (awayFromBall | farAwayFromBall)
	<-	dash_to_own_goal;
	    -farAwayFromBall;
	    -awayFromBall;
	    -canSeeBall;
        !backToDefenderArea.

//fail-safe plan
-!backToDefenderArea
    <-  turn;
        !backToDefenderArea.
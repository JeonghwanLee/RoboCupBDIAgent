/* Initial Belief */
atOwnGoal.

/* Initial Goal */
!findBall.

/* Plans to achieve goals */

// ********* Plan to find a ball **************

//Turn if you can't see ball.
+!findBall
	:	not canSeeBall
	<-	turn;
        !findBall.

// If you found the ball and its in medium range, dash and try to kick it.
+!findBall
	:	awayFromBall | closeToBall
	<-	dash_to_ball;
	    -awayFromBall;
	    - closeToBall;
	    -canSeeBall;
        !kickBall.

//If you're next to bal, kick it.
+!findBall
	:	nextToBall
	<-	kick;
	    -nextToBall;
	    -canSeeBall;
        !kickBall.

//if you're next to own goal and the ball is far away, just observe.
+!findBall
	:	farAwayFromBall & not awayFromOwnGoal
	<-	observe;
	    -farAwayFromBall;
	    -canSeeBall;
        !observeBall.

//if you're away from own goal and the ball is far away, return to own goal.
// Also add personal belief to remind you you are going to own goal.
+!findBall
	:	awayFromOwnGoal & farAwayFromBall
	<-	dash_to_own_goal;
	    -farAwayFromBall;
	    -awayFromOwnGoal;
	    -canSeeBall;
	    +goingToOwnGoal;
        !backToOwnGoal.

//if you're away from own goal and can't see  ball, return to own goal.
//Also add personal belief to remind you you are going to own goal.
+!findBall
	:	awayFromOwnGoal & not canSeeBall
	<-	dash_to_own_goal;
	    -awayFromOwnGoal;
	    +goingToOwnGoal;
        !backToOwnGoal.

// if anything fails in an attempt to achieve the goal, the
// contingency plan (-!findBall) reintroduces the goal again at all
// circumstances (note the empty plan context); this is what causes the
// "blind commitment" behaviour mentioned above
-!findBall
    <-  observe;
        !findBall.

// ************ Plan to observe the ball *******************

//If you can't see the ball, turn ro see it.
+!observeBall
	:	not canSeeBall
	<-	turn;
        !observeBall.

//if you're far away from ball, just observe.
+!observeBall
	:	farAwayFromBall
	<-	observe;
	    -canSeeBall;
	    -farAwayFromBall;
        !observeBall.

//if you're away but not too far, dash to ball and defend.
+!observeBall
	:	awayFromBall
	<-	dash_to_ball;
	    -canSeeBall;
	    -awayFromBall;
        !kickBall.

//fail-safe plan
-!observeBall
    <-  observe;
        !observeBall.

// ************ Plan to kick a ball ****************

//If you can't see the ball, turn  and go to own goal.
// Also add personal belief to remind you you are going to own goal.
+!kickBall
	:	not canSeeBall
	<-	turn;
	    +goingToOwnGoal;
        !backToOwnGoal.

//If you're next to bal, kick it.
+!kickBall
	:	nextToBall
	<-	kick;
	    +kickedBefore;
	    -nextToBall;
	    -canSeeBall;
        !kickBall.

//if you're away from ball, dash to own goal and return.
//Also add personal belief to remind you you are going to own goal.
+!kickBall
	:	awayFromBall
	<-	dash_to_own_goal;
	    -awayFromBall;
	    -canSeeBall;
	    +goingToOwnGoal;
       !backToOwnGoal.

//if you're close to ball, dash  and try to kick it.
+!kickBall
	:	closeToBall
	<-	dash_to_ball;
	    -closeToBall;
	    -canSeeBall;
        !kickBall.

//this is to check if the goalie already defended and kicked the ball, then he shouldn't keep pursuing the ball.
+!kickBall
	:	kickedBefore & not nextToBall & awayFromBall
	<-	observe;
	    -kickedBefore;
	    -awayFromBall;
	    -canSeeBall;
        !kickBall.

//if the ball is far away, then go back to own goal.
//Also add personal belief to remind you you are going to own goal.
+!kickBall
	:	kickedBefore & farAwayFromBall
	<-	turn;
	    -kickedBefore;
	    -farAwayFromBall;
	    -canSeeBall;
	    +goingToOwnGoal;
        !backToOwnGoal.

//if the ball is away and you are next to opposite goal, the go to own goal.
//Also add personal belief to remind you you are going to own goal.
+!kickBall
	:	kickedBefore & awayFromBall & nextToOppositeGoal
	<-	turn;
	    -atOwnGoal;
	    -kickedBefore;
	    -nextToOppositeGoal;
	    -canSeeBall;
	    +goingToOwnGoal;
        !backToOwnGoal.

//fail-safe plan
-!kickBall
    <-  observe;
        !kickBall.

// ********* Plan to back to own goal ********************

//If away from your own goal and not close to the ball, dash to own goal.
+!backToOwnGoal
	:	awayFromOwnGoal & not closeToBall
	<-	dash_to_own_goal;
	    -awayFromOwnGoal;
	    -atOwnGoal;
        !backToOwnGoal.

//If away from your own goal and close to the ball, dash to the ball and try to kick it.
+!backToOwnGoal
	:	awayFromOwnGoal & closeToBall
	<-	dash_to_ball;
    	-awayFromOwnGoal;
	    -atOwnGoal;
	    -closeToBall;
	    -canSeeBall;
	    -goingToOwnGoal;
        !kickBall.

//if you are in the goalie  area and can't see the ball, try to find it.
+!backToOwnGoal
	:	nextToOwnGoal & not canSeeBall
	<-	turn;
	    +atOwnGoal;
	    -nextToOwnGoal;
	    -goingToOwnGoal;
        !findBall.

//if you are in the goalie  area and can see the ball, just observe.
+!backToOwnGoal
	:	nextToOwnGoal & canSeeBall
	<-	observe;
	    +atOwnGoal;
	    -nextToOwnGoal;
	    -canSeeBall;
	    -goingToOwnGoal;
        !kickBall.

//if you you can't see your own goal or opposite goal and you know from own beliefs you wre trying to go to own goal,
//keep turning until you find it.
+!backToOwnGoal
    :   not nextToOwnGoal & not awayFromOwnGoal & goingToOwnGoal
    <-	turn;
            !backToOwnGoal.

//fail-safe plan
-!backToOwnGoal
    <-  observe;
        !backToOwnGoal.
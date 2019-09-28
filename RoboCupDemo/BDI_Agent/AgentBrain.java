import java.util.List;
import java.util.regex.*;

class AgentBrain extends Thread implements SensorInput
{

	private SendCommand m_agent;			// robot which is controled by this brain
	private Memory			m_memory;		// place where all information is stored
	private char			m_side;
	volatile private boolean		m_timeOver;
	private String                      m_playMode;
	private int m_number;
	private String m_team;

	//---------------------------------------------------------------------------
    // This constructor:
    // - stores connection to krislet
    // - starts thread for this object
    public AgentBrain(SendCommand krislet, 
		 String team, 
		 char side, 
		 int number, 
		 String playMode)
    {
		m_timeOver = false;
		m_agent = krislet;
		m_memory = new Memory();
		m_team = team;
		m_side = side;
		m_number = number;
		m_playMode = playMode;
		start();
    }

    public void run()
    {
	// first put it somewhere on my side
	if(Pattern.matches("^before_kick_off.*",m_playMode)){

		switch(m_number%5){
			case 0: m_agent.move( - 20 , -20 );
			case 1: m_agent.move(  - 25, -10 );
			case 2: m_agent.move(  - 37 , 0 );
			case 3: m_agent.move(  - 25 , 10 );
			case 4: m_agent.move( - 20 , 20 );
		}
	}
        BDIAgent agent = new BDIAgent(m_number);
        SoccerEnvironment env = new SoccerEnvironment();

        while( !m_timeOver )
            {
            	//Get environment current conditions
                List<Condition>  conditions = env.CheckConditions(m_memory, m_side);
                //Pass conditions to the BDI agent to be added as perceptions
                agent.setConditions(conditions);
                //Set the perception time to prevent the agent from performing multiple reasoning cycles on the same environment
				agent.currentPerceptionTimestamp = env.timeStamp;
				agent.run();

                Actions action = agent.getExecutedAction();
                if(action != null){
					System.out.println("action:" + action);
					doAction(action);
                } else {
					System.out.println("No action.");
                }

				// sleep one step to ensure that we will not send
				// two commands in one cycle.
				try{
					Thread.sleep(2*SoccerParams.simulator_step);
				}catch(Exception e){
					System.out.println(e.getMessage());
				}

            }
        m_agent.bye();
    }

	private void doAction(Actions action) {
		try {
			ObjectInfo ball;
			ObjectInfo ownGoal;
			ObjectInfo oppositeGoal;

			ball = m_memory.getObject("ball");

			if( m_side == 'l' ) {
				ownGoal = m_memory.getObject("goal l");
				oppositeGoal = m_memory.getObject("goal r");

			}else {
				oppositeGoal = m_memory.getObject("goal l");
				ownGoal = m_memory.getObject("goal r");
			}

			switch (action) {
				case turn:
					m_agent.turn(45);
					break;
				case observe:
					m_memory.waitForNewInfo();
					break;
				case dash_to_ball:
					if( ball.m_direction < -5 || ball.m_direction > 5) {
						m_agent.turn(ball.m_direction);
					}
					else {
						m_agent.dash(100);
					}
					break;
				case jog_to_ball:
					if( ball.m_direction < -5 || ball.m_direction > 5) {
						m_agent.turn(ball.m_direction);
					}
					else {
						m_agent.dash(60);
					}
					break;
				case dash_to_own_goal:
					if( ownGoal == null ){
						if(oppositeGoal!= null){
							if(oppositeGoal.m_direction > 0)
								m_agent.turn(oppositeGoal.m_direction - 180);
							else{
								m_agent.turn(180 +  oppositeGoal.m_direction);
							}
						}else {
							m_agent.turn(45);
						}
					}else if( ownGoal.m_direction < -5 || ownGoal.m_direction > 5)
						m_agent.turn(ownGoal.m_direction);
					else
						m_agent.dash(100);
					break;
				case dash_to_opposite_goal:
					if(oppositeGoal == null){
						if(ownGoal!= null){
							if(ownGoal.m_direction > 0)
								m_agent.turn(ownGoal.m_direction - 180);
							else{
								m_agent.turn(180 +  ownGoal.m_direction);
							}
						}else {
							m_agent.turn(45);
						}
					}else if( oppositeGoal.m_direction < -5 || oppositeGoal.m_direction > 5)
						m_agent.turn(oppositeGoal.m_direction);
					else
						m_agent.dash(100);
					break;
				case kick:

					if( oppositeGoal == null ) {
						if(ownGoal!= null){
							if(ownGoal.m_direction > 0)
								m_agent.kick(100,ownGoal.m_direction - 180);
							else{
								m_agent.kick(100,180 +  ownGoal.m_direction);
							}
						}else {
							m_agent.turn(45);
						}
					}else {
						m_agent.kick(100, oppositeGoal.m_direction);
					}
					break;
				case weak_kick:
					if( oppositeGoal == null ) {
						m_agent.turn(40);
					}else {
						m_agent.kick(50, oppositeGoal.m_direction);
					}
					break;
				default:
					m_memory.waitForNewInfo();
					break;
			}
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}
	}


    //===========================================================================
    // Here are suporting functions for implement logic


    //===========================================================================
    // Implementation of SensorInput Interface

    //---------------------------------------------------------------------------
    // This function sends see information
    public void see(VisualInfo info)
    {
	m_memory.store(info);
    }


    //---------------------------------------------------------------------------
    // This function receives hear information from player
    public void hear(int time, int direction, String message)
    {
    }

    //---------------------------------------------------------------------------
    // This function receives hear information from referee
    public void hear(int time, String message)
    {						 
	if(message.compareTo("time_over") == 0)
	    m_timeOver = true;

    }
}

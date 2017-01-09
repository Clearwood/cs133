/* 
 * File:    DumboController.java
 * Created: 17 September 2002, 00:34
 * Author:  Stephen Jarvis
 */

import uk.ac.warwick.dcs.maze.logic.IRobot;

public class Ex1
{
    
    public void controlRobot(IRobot robot) {

	int randno;
	int direction;
	int lookahead; 
	//System.out.println(walls);
	// Select a random number
	// changed the called method to Math.floor to have the same propability for each direction
	do{
	randno = (int) Math.floor(Math.random()*4);
	// Convert this to a direction
	switch(randno){
		case 0:
		direction = IRobot.LEFT;
		break;
		case 1:
		direction = IRobot.RIGHT;
		break;
		case 2:
		direction = IRobot.BEHIND;
		break;
		default:
		direction = IRobot.AHEAD;
	}
	lookahead = robot.look(direction);
		/* Face the robot in this direction */   
        }while(lookahead == IRobot.WALL); // the program should repeat randomly choosing a direction when the way for the current direction is blocked 
	robot.face(direction);
	// prints out the current relative direction
	System.out.print("I'm going ");
	switch(direction){
		case IRobot.LEFT:
			System.out.println("left.");
			break;
		case IRobot.RIGHT:
			System.out.println("right.");
			break;
		case IRobot.AHEAD:
			System.out.println("forward.");
			break;
		case IRobot.BEHIND:
			System.out.println("backwards.");
			break;

	}
	}
        
}

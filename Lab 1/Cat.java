import mayflower.Actor;
import mayflower.Keyboard;

public class Cat extends Actor{
	public Cat(){
		setPicture("/Users/aadhi0319/Downloads/Lab1StarterCode/img/Cat.png");
	}
	
	public void update(){
		int x = getX();
		int y = getY();
		int w = getWidth();
		int h = getHeight();
		
		h = 600;//delete this after check
		w = 800;
		
		Keyboard kb =  getKeyboard();
		if(kb.isKeyPressed("w")){
			if(y>2)
				move(1, "North");
		}
		if(kb.isKeyPressed("s")){
			if(y<h-2)
				move(1, "South");
		}
		if(kb.isKeyPressed("d")){
			if(x<w-2)
				move(1, "East");
		}
		if(kb.isKeyPressed("a")){
			if(x>2)
				move(1, "West");
		}
	}
}

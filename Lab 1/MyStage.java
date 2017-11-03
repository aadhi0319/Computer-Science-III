import mayflower.Stage;

public class MyStage extends Stage{
	public MyStage(){
		setBackground("/Users/aadhi0319/Downloads/Lab1StarterCode/img/bluebonnets.jpg");
		Cat a = new Cat();
		addActor(a, 300, 400);
		Dog d = new Dog();
		addActor(d, 200, 150);
		Yarn y1 = new Yarn();
		addActor(y1, 600, 150);
		Yarn y2 = new Yarn();
		addActor(y2, 200, 450);
		Yarn y3 = new Yarn();
		addActor(y3, 600, 450);
	}
	
	public void update(){
		
	}
}


public class Position {
	private int x;
	private int y;
	public int getX() {
		return x;
	}
	public Position(int x, int y) {
		super();
		this.x = x;
		this.y = y;
	}
	public int getY() {
		return y;
	}
	@Override
	public String toString() {
		return "Position [x=" + x + ", y=" + y + "]";
	}
	
	
}

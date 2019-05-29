import java.util.ArrayList;
import java.util.Collections;

public class Node {
	private int[][] board;
	private boolean toggled;
	private boolean visited;
	private double heuristicF;
	private double heuristicG;
	private double heuristicH;
	private Node parent;
	
	public Node(int[][] board) {
		super();
		this.board = board;
		this.toggled = false;
		this.visited = false;
		this.heuristicF = 0;
		this.heuristicG = 0;
		this.heuristicH = 0;
		this.parent = null;
	}
	
	public int computeSum() {
		int sum = 0;
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board[i].length; j++) {
				sum += board[i][j];
			}
		}
		return 4 + sum;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return String.format("Node: { board: [  %d %d %d %d %d\n\t          %d %d %d %d %d\n\t          %d %d %d %d %d\n\t          %d %d %d %d %d\n\t          %d %d %d %d %d  ]\n        heuristic_f: %.2f\n        heuristic_g: %.2f\n        heuristic_h: %.2f\n        parent: "+parent+"\n }", board[0],board[1],board[2],board[3],board[4],board[5],board[6],board[7],board[8],board[9],board[10],board[11],board[12],board[13],board[14],board[15],board[16],board[17],board[18],board[19],board[20],board[21],board[22],board[23],board[24],heuristicF,heuristicG,heuristicH);
	}
	
	public String boardInfo() {
		return String.format("[  %d %d %d %d %d\n"
				             +"   %d %d %d %d %d\n"
				             +"   %d %d %d %d %d\n"
				             +"   %d %d %d %d %d\n"
				             +"   %d %d %d %d %d  ]\n", 
				              board[0][0],board[0][1],board[0][2],board[0][3],board[0][4],
				              board[1][0],board[1][1],board[1][2],board[1][3],board[1][4],
				              board[2][0],board[2][1],board[2][2],board[2][3],board[2][4],
				              board[3][0],board[3][1],board[3][2],board[3][3],board[3][4],
				              board[4][0],board[4][1],board[4][2],board[4][3],board[4][4]);
		
	}
	
	


	public double computeHeuristicH() {
		return computeSum();
		
	}

	public int[][] getBoard() {
		return board;
	}

	public void setBoard(int[][] board) {
		this.board = board;
	}

	public boolean isToggled() {
		return toggled;
	}

	public void setToggled(boolean toggled) {
		this.toggled = toggled;
	}

	public boolean isVisited() {
		return visited;
	}

	public void setVisited(boolean visited) {
		this.visited = visited;
	}

	public double getHeuristicF() {
		return heuristicF;
	}

	public void setHeuristicF(double heuristicF) {
		this.heuristicF = heuristicF;
	}

	public double getHeuristicG() {
		return heuristicG;
	}

	public void setHeuristicG(double heuristicG) {
		this.heuristicG = heuristicG;
	}

	public double getHeuristicH() {
		return heuristicH;
	}

	public void setHeuristicH(double heuristicH) {
		this.heuristicH = heuristicH;
	}

	public Node getParent() {
		return parent;
	}

	public void setParent(Node parent) {
		this.parent = parent;
	}
	
	public ArrayList<Node> getAdjacentNodes() {
		ArrayList<Node> adjacentNodes = new ArrayList<Node>();
		for(int i = 0; i< board.length;i++)
			for(int j = 0; j < board[i].length;j++) {
				
				int[][] b = this.getBoard().clone();
				Node n = new Node(b);
				n.toggleLights(i,j);
				n.setParent(this);
				adjacentNodes.add(n);
			}
		return adjacentNodes;
	}
	
	public void toggleLights(int i, int j) {
		ArrayList<Position> lightPositions = new ArrayList<Position>();
		lightPositions.add(new Position(-1,0));
		lightPositions.add(new Position(0,0));
		lightPositions.add(new Position(1,0));
		lightPositions.add(new Position(0,-1));
		lightPositions.add(new Position(0,1));
		for (Position position : lightPositions) {
			int newRow = i + position.getX();
			int newCol = j + position.getY();
			if (newRow >= 0 && newRow <= 4 && newCol >= 0 && newCol <= 4) {
				if (this.board[newRow][newCol] == 0) {
					this.board[newRow][newCol] = 1;
				} else {
					this.board[newRow][newCol] = 0;
				}
			}
		}
		this.toggled = true;
	}
	
}

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Random;

public class Main {
	/*
	private int[][] board;
	private int boardHeigth = 5;
	private int boardWidth = 5;
	private int moves = 0;
	private int targetMoves = 7;
	private List<Node> solution = null;
	*/
	
	public static void main(String[] args) throws InterruptedException {
		
		 int[][] board = {{0, 1, 0, 1, 0},    {1, 1, 0, 0, 0},   {1, 0 ,0, 0, 0},   
				 {1, 1, 1, 0, 0},    {1, 0, 1, 1, 1}}; 
		 int[][] end_board = {{0, 0, 0, 0, 0},    {0, 0, 0, 0, 0},   {0, 0 ,0, 0, 0},   
				 {0, 0, 0, 0, 0},    {0, 0, 0, 0, 0}}; 
		 
		/* int[][] board = {{0, 0, 0, 0, 0},    {0, 0, 0, 0, 0},  { 0, 0 ,0, 0, 0},   
				 {0, 0, 0, 0, 0},    {0, 0, 0, 0, 1}}; */
		 int boardHeigth = 5;
		 int boardWidth = 5;
		 int moves = 0;
		 int targetMoves = 7;
		 ArrayList<Node> solution = null;
		 
		 ArrayList<Node> openList = new ArrayList<Node>();
		 ArrayList<Node> closedList = new ArrayList<Node>();
		 
		 Node startNode = new Node(board);
		 openList.add(startNode);
		 Node endNode = new Node(end_board);
		 Comparator<Node> compareByHeuristicF = new Comparator<Node>() {

			public int compare(Node arg0, Node arg1) {
				// TODO Auto-generated method stub
				if (arg0.getHeuristicF() <= arg1.getHeuristicF()) {
					return -1;
				} else {
					return 1;
				}
				
			}
			 
		 
		 };
		 
		 while(openList.size() > 0) {
			 ArrayList<Position> moveList = new ArrayList<Position>();
			 System.out.println("inizio while loop generale");
			 Collections.sort(openList, compareByHeuristicF);
			 //System.out.println("openList No.: "+openList.size());
			 moves++;
			 Node currentNode = openList.remove(0);
			 System.out.println("node H: "+currentNode.getHeuristicH());
			 System.out.println(currentNode.boardInfo());
			 
			 
			 System.out.println("moves: "+moves);
			 Thread.sleep(1000);
			 // current index serve solo per rimuovere il nodo ma gia lo faccio sopra
			
			 currentNode.setVisited(true);
			 
			 if (currentNode.getBoard() == endNode.getBoard()) {
				System.out.println("solution found");
				ArrayList<Node> path = new ArrayList<Node>();
				Node current = currentNode;
				while(current != null) {
					path.add(current.getParent());
					current = current.getParent();
				}
				Collections.reverse(path);
				solution = path;
				break;
			}
			 
			 ArrayList<Node> children = new ArrayList<Node>();
			 children.addAll(currentNode.getAdjacentNodes());
			 //System.out.println("children No.: "+children.size());
			 for (Node child : children) {
				if(!openList.contains(child) && !child.isVisited()) {
					child.setHeuristicG(child.getHeuristicG() + 1);
					child.setHeuristicH(child.computeHeuristicH());
					child.setHeuristicF(child.getHeuristicG() + child.getHeuristicH());
					openList.add(child);
				}
			}
		 }
		 System.out.println("fine while loop generale");
		 System.out.println("la soluzione è " + solution);
	}

}

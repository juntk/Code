import java.util.Scanner;

public class java3_27 {
	private Scanner s;
	public java3_27(Scanner s) {
		this.s = s;
	}
	public void filter(String d) {
		s.useDelimiter(d);
		while(s.hasNext()) {
			if(s.hasNextBoolean()) {
				System.out.print(s.nextBoolean());
			} else {
				s.next();
			}
		}
	}
	public static void main(String[] args) {
		Scanner s = new Scanner("X:true:B:false:F:false");
		new java3_27(s).filter(":");
	}
}
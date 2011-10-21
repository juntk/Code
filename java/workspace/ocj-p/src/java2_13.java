
public class java2_13 {
	public static void main(String[] args) {
		loop: for (int i=0; i<5; i++) {
			System.out.println(i);
			
			switch (i) {
			case 0:
				i++;
				break;
			case 1:
				System.out.print("*");
				break loop;
			case 2:
				System.out.print("*");
				break;
			case 3:
				i = i - 3;
				continue loop;
			case 4:
				System.out.print("*");
				break;
			}
		}
	}
}

class MyException extends RuntimeException {}

public class java2_16 {
	public static void main(String[] args) {
		try {
			hello();
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	public static void hello() {
		throw new MyException();
	}
}

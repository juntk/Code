class MyException extends Exception {}

public class java2_15 {
	public static void main(String[] args) {
		try {
			hello();
		} catch (MyException e) {
			System.out.println("MyException");
		}
	}
	public static void hello() throws MyException {
		System.out.println("Hello");
		throw new MyException();
	}
}

public class java1_20 {
	public static void main(String[] args) {
		Outer20 outer = new Outer20();
		Outer20.Inner inner = outer.new Inner();
		// or
		// Outer.Inner inner = new Outer().new Inner();
		inner.hello();
	}
}

class Outer20 {
	public class Inner {
		public void hello() {
			System.out.println("inner");
		}
	}
}

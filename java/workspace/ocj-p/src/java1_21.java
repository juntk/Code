
public class java1_21 {
	public static void main(String[] args) {
		Outer21 outer = new Outer21();
		Outer21.Inner inner = outer.getInner();
		inner.hello();
	}
}

class Outer21 {
	public String toString() {
		return "Outer";
	}
	public Inner getInner() {
		return new Inner();
	}
	public class Inner {
		public String toString() {
			return "Inner";
		}
		public void hello() {
			System.out.println(Outer21.this);
		}
	}
}

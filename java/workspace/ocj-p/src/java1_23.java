
public class java1_23 {
	public static void main(String[] args) {
		Outer23 outer = new Outer23();
		Outer23.Inner i1 = outer.getInner();
		Outer23.Inner i2 = outer.getInner();
		Outer23.Inner i3 = outer.getInner();
	}
}

class Outer23 {
	public Inner getInner() {
		return new Inner();
	}
	class Inner {
		// インナークラスでstaticメンバは使えない。
		// なぜならインナークラスはアウタークラスがあって初めて存在が許されるから。
		public static int num = 0;
		public Inner() {
			num++;
		}
	}
}
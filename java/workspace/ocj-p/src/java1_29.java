
public class java1_29 {
	public static void main(String[] args) {
		Outer29.Inner i1 = new Outer29.Inner();
		Outer29.Inner i2 = new Outer29.Inner();
		Outer29.Inner i3 = new Outer29.Inner();
		System.out.println(i3.getCount());
	}
}
class Outer29 {
	static class Inner {
		private int count = 0;
		public Inner() {
			count++;
		}
		public int getCount() {
			return this.count;
		}
	}
	
}

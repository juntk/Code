
public class java1_27 {
	public static void main(String[] args) {
		Module27 module = new Outer27().create();
		module.method(30);
	}
}

interface Module27 {
	void method(int n);
}

class Outer27 {
	private Module27 module = new Module27() {
		private int num;
		{
			this.num = 2;
		}
		public void method(int n) {
			System.out.println(num * n);
		}
	};
	public Module27 create() {
		return this.module;
	}
}
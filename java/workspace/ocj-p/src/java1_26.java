
public class java1_26 {
	public static void main(String[] args) {
		Outer26.method(3);
	}
}

class Outer26 {
	private static int num = 2;
	// ローカルインナークラス内でメソッドのローカル変数を使うときには
	// final修飾子をつけて定数化してやる。
	// ローカル変数はメソッドの終了と同時に開放されるため。
	public static void method(final int n) {
		class Inner {
			public void calc() {
				System.out.println(num * n);
			}
		}
		new Inner().calc();
	}
}
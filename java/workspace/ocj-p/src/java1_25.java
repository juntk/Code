
public class java1_25 {
	public static void main(String[] args) {
		Factory factory = new Factory();
		Module module = factory.create();
		module.hello();
	}
}

interface Module {
	void hello();
}

class Factory {
	public Module create() {
		// メソッド内に定義したインナークラス（ローカルインナークラス）は
		// 定義された後でないと利用できない。
		// 普通の変数を利用する場合などと同様。
		Inner inner = new Inner();
		class Inner implements Module {
			public void hello() {
				System.out.println("hello");
			}
		}
		// 正しい位置
		// Inner inner = new Inner();
		return inner;
	}
}
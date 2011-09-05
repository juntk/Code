
public class java1_24 {
	public static void main(String[] args) {
		Outer.Inner inner = new Outer().getInner();
		inner.hello();
		inner.bye();
	}
}

class Outer {
	interface Inner {
		public void hello();
		public void bye();
	}
	protected abstract class AbstractInner implements Inner {
		public void bye() {
			System.out.println("bye");
		}
	}
	private class InnerImpl extends AbstractInner {
		public void hello() {
			System.out.println("hello");
		}
	}
	public Inner getInner() {
		return new InnerImpl();
	}
}
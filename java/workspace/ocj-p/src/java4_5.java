
public class java4_5 {
	public static void main(String[] args) {
		Thread task = new Thread() {
			public void run() {
				System.out.print(this.getId());
			}
			public void start() {
				System.out.print(this.getId());
				super.start();
			}
		};
		task.start();
		System.out.print(Thread.currentThread().getId());
	}
}

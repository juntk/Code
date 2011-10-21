
public class java4_4 {
	public static void main(String[] args) {
		Runnable task = new Runnable() {
			public void run() {
				System.out.println("run");
			}
		};
		Thread thread = new Thread(task) {
			public synchronized void start() {
				System.out.println("start");
			}
		};
		thread.start();
	}
}

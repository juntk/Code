
public class java4_8 {
	public static void main(String[] args) {
		Runnable task = new Runnable() {
			public void run() {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					System.out.println("InterruptedException"	);
					e.printStackTrace();
				}
			}
		};
		new Thread(task).start();
		System.out.println("A");
	}
}

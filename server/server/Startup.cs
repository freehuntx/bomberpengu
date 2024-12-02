using System;

namespace DevServer {
	public static class Startup {
		[STAThread]
		static void Main() {
			PlayerIO.DevelopmentServer.Server.StartWithDebugging();
		}
	}
}

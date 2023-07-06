import sys.FileSystem;
import sys.io.File;
import haxe.Http;
import sys.process.*;
import haxe.io.Bytes;

class AutoUpdater {
  public static function main() {
    // Check for updates
    if (hasUpdatesAvailable()) {
      downloadLatestVersion();
      installLatestVersion();
    }

    // Run the application
    runApp();
  }

  private static function hasUpdatesAvailable(): Bool {
    // TODO: Implement your logic to check for updates
    // You can compare the current version of your app with the latest version available on GitHub
    // Return true if updates are available, otherwise false
    return false;
  }

  private static function downloadLatestVersion() {
    // TODO: Replace with your GitHub repository URL
    var repositoryUrl = "https://github.com/M3llySlayz/Amazing-Engine/releases/download/0.3/AE-0.3.zip";
    var targetZipPath = "0.3.zip";

    var http = new Http(repositoryUrl);
    var file = new File(targetZipPath, "write");

    http.onData = function(data: Bytes) file.write(data);
    http.onError = function(error: Dynamic) {
      trace("Error downloading latest version:", error);
      sys.exit(1);
    };

    http.onStatus = function(status: Int) {
      if (status != 200) {
        trace("Download failed with status:", status);
        sys.exit(1);
      }
    };

    http.request();
    while (http.status == 0) {
      // Wait for the download to complete
    }

    file.close();
  }

  private static function installLatestVersion() {
    // TODO: Implement your logic to install the latest version
    // Extract the downloaded ZIP file and copy the necessary files to the appropriate location
    // You can use PowerShell commands to extract the files and copy them

    // Example PowerShell commands:
    var extractCmd = 'Expand-Archive -Path "latest_version.zip" -DestinationPath "temp_extracted"';
    var copyCmd = 'Copy-Item -Recurse -Force -Path "temp_extracted/your_repository-main/*" -Destination "your_app_directory"';

    var process = new Process("powershell");
    process.execute(extractCmd);
    process.execute(copyCmd);

    while (process.status == 0) {
      // Wait for the extraction and copy processes to complete
    }

    // Cleanup temporary files
    FileSystem.deleteDirectory("temp_extracted");
    FileSystem.deleteFile("latest_version.zip");
  }

  private static function runApp() {
    // TODO: Implement your logic to run the application
    // Execute your application's main executable or launch the entry point
    // You can use Haxe's sys API or external commands like 'cmd.exe' to run the application

    // Example command:
    var runAppCmd = 'cmd.exe /c start AmazingEngine.exe';
    sys.process.Process.run(runAppCmd, []);
  }
}
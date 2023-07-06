package;

//barebones requirements
import sys.io.File;
import sys.net.Http;
import haxe.io.Bytes;
import haxe.zip.Uncompress;
import lime.utils.Assets;

//fancy flair
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;

class AutoUpdater {
  static var repoUrl:String = "https://github.com/M3llySlayz/Amazing-Engine/releases/download/0.3/AE-0.3.zip";
  static var appPath:String = "Amazing Engine";

  static function main() {
    downloadLatestVersion();
  }

  static function downloadLatestVersion() {
    var http = new Http(repoUrl);
    var response = http.request(false);

    if (response.isOk()) {
      var data = response.getData();
      var zipPath = "latest.zip";

      File.saveContent(zipPath, data);

      // Extract the zip file to the desired app path
      extractZip(zipPath, appPath);

      // Clean up the downloaded zip file
      File.deleteFile(zipPath);

      trace("Update complete!");
    } else {
      trace("Failed to download the latest version.");
    }
  }

  static function extractZip(zipPath:String, destination:String) {
    // Use your preferred method to extract the zip file, e.g., a library or a command line tool
    // Here's an example using the "zip" command line tool on Unix-based systems
    //var cmd = "unzip -o " + zipPath + " -d " + destination;
    //var exitCode = sys.io.Process.run(cmd);

    //nah, imma do my own thing. - melly morales
    try
    {
    var uncompressingFile:Bytes = new Uncompress().run(File.getBytes(zipPath));
			if (uncompressingFile.done)
			{
				trace('test');
				return;
			}
    } catch(e:Any)
    {
      trace ("Couldn't uncompress the zip, sucks to suck");
      var errorText:FlxText = new FlxText(-70, FlxG.height - 50, 0, "Oops! We can't seem to finish the installation. Is there enough space on your device?");
      errorText.alpha = 0;
      add(errorText);
      FlxTween.tween(errorText, {x: 50, alpha: 1}, 0.4, {ease: FlxEase.quadOut});
      new FlxTimer().start(3, function (tmr:FlxTimer) {
        FlxTween.tween(errorText, {x: -50, alpha: 0}, 2, {ease: FlxEase.quadOut});
      });
    }

    if (exitCode == 0) {
      trace("Zip extraction complete.");
    } else {
      trace("Failed to extract the zip file.");
    }
  }

  public static function getCurrentVersion(path:String):String
  {
    var daVer:String = '';
    #if sys
    if(FileSystem.exists(path)) daList = File.getContent(path).trim();
    #else
    if(Assets.exists(path)) daList = Assets.getText(path).trim();
    #end
  
    return daVer;
  }
}
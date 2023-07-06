package;

//barebones requirements
//import sys.Http;
import sys.io.File;
import sys.FileSystem;
import sys.net.Http;
import haxe.io.Bytes;
import haxe.zip.Uncompress;
import lime.utils.Assets;
import flixel.addons.ui.FlxUIState;

//fancy flair
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class AutoUpdater extends FlxUIState {
  static var repoUrl:String = "https://github.com/M3llySlayz/Amazing-Engine/releases/download/0.3/AE-0.3.zip";
  static var appPath:String = "Amazing Engine";

  override function create() {
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
      FileSystem.deleteFile(zipPath);

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
    try{
      var uncompressingFile:Bytes = new Uncompress().run(File.getBytes(zipPath));
			if (uncompressingFile.done)
			{
				trace('test');
				return;
			}
    } catch(e:Any) {
      trace ("Couldn't uncompress the zip, sucks to suck");
      var errorText:FlxText = new FlxText(-70, FlxG.height - 50, 0, "Oops! We can't seem to finish the installation. Is there enough space on your device?");
      errorText.alpha = 0;
      add(errorText);
      FlxTween.tween(errorText, {x: 50, alpha: 1}, 0.4, {ease: FlxEase.quadOut});
      new FlxTimer().start(3, function (tmr:FlxTimer) {
        FlxTween.tween(errorText, {x: -50, alpha: 0}, 2, {ease: FlxEase.quadOut});
      });
    }
  }

  static function getCurrentVersion(path:String):String
  {
    var daVer:String = '';
    #if sys
    if(FileSystem.exists(path)) daVer = File.getContent(path).trim();
    #else
    if(Assets.exists(path)) daVer = Assets.getText(path).trim();
    #end
  
    return daVer;
  }
  public function add(Object:T):T
	{
		if (Object == null)
		{
			FlxG.log.warn("Cannot add a `null` object to a FlxGroup.");
			return null;
		}

		// Don't bother adding an object twice.
		if (members.indexOf(Object) >= 0)
			return Object;

		// First, look for a null entry where we can add the object.
		var index:Int = getFirstNull();
		if (index != -1)
		{
			members[index] = Object;

			if (index >= length)
			{
				length = index + 1;
			}

			if (_memberAdded != null)
				_memberAdded.dispatch(Object);

			return Object;
		}

		// If the group is full, return the Object
		if (maxSize > 0 && length >= maxSize)
			return Object;

		// If we made it this far, we need to add the object to the group.
		members.push(Object);
		length++;

		if (_memberAdded != null)
			_memberAdded.dispatch(Object);

		return Object;
	}
}
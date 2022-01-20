//! --class-path src
import Sys.*;
import Tools;
import akismet.Version.*;

/** Runs the script. **/
function main() {
	compress(["CHANGELOG.md", "LICENSE.md", "README.md", "haxelib.json", "src"], "var/haxelib.zip");
	command("haxelib submit var/haxelib.zip");
	for (action in ["tag", "push origin"]) command('git $action v$packageVersion');
}

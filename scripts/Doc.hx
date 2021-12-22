//! --class-path src
import Sys.*;
import Tools.removeDirectory;
import akismet.Version.*;
import sys.FileSystem.*;
import sys.io.File.*;

/** Runs the script. **/
function main() {
	if (exists("docs")) removeDirectory("docs");

	command("haxe --define doc-gen --no-output --xml var/api.xml build.hxml");
	command("lix", [
		"run", "dox",
		"--define", "description", "Prevent comment spam using the Akismet service, in Haxe.",
		"--define", "source-path", "https://bitbucket.org/cedx/akismet.hx/src/main/src",
		"--define", "themeColor", "0xffc105",
		"--define", "version", packageVersion,
		"--define", "website", "https://bitbucket.org/cedx/akismet.hx",
		"--input-path", "var",
		"--output-path", "docs",
		"--title", "Akismet for Haxe",
		"--toplevel-package", "akismet"
	]);

	copy("www/favicon.ico", "docs/favicon.ico");
}

//! --class-path src --library tink_core
import akismet.Platform;
import sys.FileSystem;
import sys.io.File;

/** Builds the documentation. **/
function main() {
	if (FileSystem.exists("docs")) Tools.removeDirectory("docs");

	Sys.command("haxe --define doc-gen --no-output --xml var/api.xml build.hxml");
	Sys.command("lix", ["run", "dox",
		"--define", "description", "Prevent comment spam using the Akismet service, in Haxe.",
		"--define", "source-path", "https://github.com/cedx/akismet.hx/blob/main/src",
		"--define", "themeColor", "0xea8220",
		"--define", "version", Platform.packageVersion,
		"--define", "website", "https://docs.belin.io/akismet.hx",
		"--input-path", "var",
		"--output-path", "docs",
		"--title", "Akismet for Haxe",
		"--toplevel-package", "akismet"
	]);

	File.copy("www/favicon.ico", "docs/favicon.ico");
}

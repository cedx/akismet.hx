//! --class-path src --library tink_core
import akismet.Version;
import sys.FileSystem;
import sys.io.File;

/** Runs the script. **/
function main() {
	if (FileSystem.exists("docs")) Tools.removeDirectory("docs");

	Sys.command("haxe", ["--define", "doc-gen", "--no-output", "--xml", "var/api.xml", "build.hxml"]);
	Sys.command("lix", [
		"run", "dox",
		"--define", "description", "Prevent comment spam using the Akismet service, in Haxe.",
		"--define", "source-path", "https://github.com/cedx/akismet.hx/blob/main/src",
		"--define", "themeColor", "0xffc105",
		"--define", "version", Version.packageVersion,
		"--define", "website", "https://github.com/cedx/akismet.hx",
		"--input-path", "var",
		"--output-path", "docs",
		"--title", "Akismet for Haxe",
		"--toplevel-package", "akismet"
	]);

	File.copy("www/favicon.ico", "docs/favicon.ico");
}

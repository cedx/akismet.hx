package akismet;

#if macro
import haxe.Json;
import haxe.macro.Context;
import sys.io.File;
import sys.io.Process;
#end

/** Provides information about the program version. **/
@:noDoc abstract class Version {

	/** Gets the hash of the current Git commit. **/
	macro public static function getGitCommitHash() {
		#if display
			return macro $v{""};
		#else
			final process = new Process("git", ["rev-parse", "HEAD"]);
			final hash = process.exitCode() == 0 ? process.stdout.readLine() : process.stderr.readLine();
			process.close();
			return macro $v{hash};
		#end
	}

	/** Gets the name of the Haxe target. **/
	macro public static function getHaxeTarget() return macro $v{Context.definedValue("target.name")};

	/** Gets the version of the Haxe compiler. **/
	macro public static function getHaxeVersion() return macro $v{Context.definedValue("haxe")};

	/** Gets the package version of this program. **/
	macro public static function getPackageVersion()
		#if display
			return macro $v{"0.0.0"};
		#else
			return macro $v{Json.parse(File.getContent("haxelib.json")).version};
		#end
}

package akismet;

import haxe.extern.EitherType;
import coconut.data.Model;

/** TODO **/
@:jsonParse(json -> akismet.Usage.fromJson(json))
class Usage implements Model {

	/** TODO **/
	@:constant var limit: Int = @byDefault -1;

	/** TODO **/
	@:constant var percentage: Float = @byDefault 0;

	/** TODO **/
	@:constant var throttled: Bool = @byDefault false;

	/** TODO **/
	@:constant var usage: Int = @byDefault -1;

	/** Creates a new usage from the specified JSON object. **/
	public static function fromJson(json: UsageData) return new Usage({
		limit: json.limit == "none" ? -1 : json.limit,
		percentage: json.percentage,
		throttled: json.throttled,
		usage: json.usage
	});
}

/** Defines the data of an author. **/
typedef UsageData = {

	/** TODO **/
	final limit: EitherType<Int, String>;

	/** TODO **/
	final percentage: Float;

	/** TODO **/
	final throttled: Bool;

	/** TODO **/
	final usage: Int;
}

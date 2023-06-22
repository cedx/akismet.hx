package akismet;

import haxe.extern.EitherType;
import coconut.data.Model;

/** Provides API usage for a given month. **/
@:jsonParse(json -> akismet.Usage.fromJson(json))
class Usage implements Model {

	/** The number of monthly API calls your plan entitles you to. **/
	@:constant var limit: Int = @byDefault -1;

	/** The percentage of the limit used since the beginning of the month. **/
	@:constant var percentage: Float = @byDefault 0;

	/** Value indicating whether the requests are being throttled for having consistently gone over the limit. **/
	@:constant var throttled: Bool = @byDefault false;

	/** The number of calls (spam + ham) since the beginning of the month. **/
	@:constant var usage: Int = @byDefault 0;

	/** Creates a new usage from the specified JSON object. **/
	public static function fromJson(json: UsageData) return new Usage({
		limit: json.limit is String ? -1 : json.limit,
		percentage: json.percentage,
		throttled: json.throttled,
		usage: json.usage
	});
}

/** Defines the data of an author. **/
typedef UsageData = {

	/** The number of monthly API calls your plan entitles you to. **/
	final limit: EitherType<Int, String>;

	/** The percentage of the limit used since the beginning of the month. **/
	final percentage: Float;

	/** Value indicating whether the requests are being throttled for having consistently gone over the limit. **/
	final throttled: Bool;

	/** The number of calls (spam + ham) since the beginning of the month. **/
	final usage: Int;
}

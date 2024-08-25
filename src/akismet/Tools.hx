package akismet;

using DateTools;

/** Converts the specified `date` to an ISO 8601 string, using the UTC time zone. **/
function toIsoString(date: Date)
	return date.delta(date.getTimezoneOffset().minutes()).format("%FT%TZ");

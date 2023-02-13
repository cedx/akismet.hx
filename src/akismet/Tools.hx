package akismet;

using DateTools;

/** Converts the specified date to an ISO 8601 string, using the UTC time zone. **/
@:noDoc function toIsoString(dateTime: Date)
	return Date.fromTime(dateTime.getTime() + dateTime.getTimezoneOffset().minutes()).format("%FT%TZ");

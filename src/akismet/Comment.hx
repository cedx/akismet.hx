package akismet;

import akismet.Author.AuthorFormData;
import coconut.data.Model;
import tink.Anon;
import tink.Url;
using DateTools;

/** Represents a comment submitted by an author. **/
#if tink_json
@:jsonParse(json -> new akismet.Comment(json))
@:jsonStringify(comment -> {
	author: comment.author,
	content: comment.content,
	date: comment.date,
	permalink: comment.permalink,
	postModified: comment.postModified,
	recheckReason: comment.recheckReason,
	referrer: comment.referrer,
	type: comment.type
})
#end
class Comment implements Model {

	/** The comment's author. **/
	@:editable var author: Author;

	/** The comment's content. **/
	@:editable var content: String = @byDefault "";

	/** The UTC timestamp of the creation of the comment. **/
	@:editable var date: Null<Date> = @byDefault null;

	/** The permanent location of the entry the comment is submitted to. **/
	@:editable var permalink: Null<Url> = @byDefault null;

	/** The UTC timestamp of the publication time for the post, page or thread on which the comment was posted. **/
	@:editable var postModified: Null<Date> = @byDefault null;

	/** A string describing why the content is being rechecked. **/
	@:editable var recheckReason: String = @byDefault "";

	/** The URL of the webpage that linked to the entry being requested. **/
	@:editable var referrer: Null<Url> = @byDefault null;

	/** The comment's type. **/
	@:editable var type: CommentType = @byDefault "";

	/** Converts this object to form data. **/
	public function toFormData() {
		final data: CommentFormData = Anon.merge(author.toFormData(), {});
		if (content.length > 0) data.comment_content = content;
		if (date != null) data.comment_date_gmt = toIsoString(date);
		if (permalink != null) data.permalink = permalink;
		if (postModified != null) data.comment_post_modified_gmt = toIsoString(postModified);
		if (recheckReason.length > 0) data.recheck_reason = recheckReason;
		if (referrer != null) data.referrer = referrer;
		if ((type: String).length > 0) data.comment_type = type;
		return data;
	}

	/** Converts this object to a map. **/
	public function toMap() {
		final map = author.toMap();
		if (content.length > 0) map["comment_content"] = content;
		if (date != null) map["comment_date_gmt"] = toIsoString(date);
		if (permalink != null) map["permalink"] = permalink;
		if (postModified != null) map["comment_post_modified_gmt"] = toIsoString(postModified);
		if (recheckReason.length > 0) map["recheck_reason"] = recheckReason;
		if (referrer != null) map["referrer"] = referrer;
		if ((type: String).length > 0) map["comment_type"] = type;
		return map;
	}

	/** Converts a date to an ISO 8601 string, using the UTC time zone. **/
	static function toIsoString(dateTime: Date)
		return Date.fromTime(dateTime.getTime() + dateTime.getTimezoneOffset().minutes()).format("%FT%TZ");
}

/** Defines the form data of a comment. **/
typedef CommentFormData = AuthorFormData & {

	/** The comment's content. **/
	var ?comment_content: String;

	/** The UTC timestamp of the creation of the comment. **/
	var ?comment_date_gmt: String;

	/** The UTC timestamp of the publication time for the post, page or thread on which the comment was posted. **/
	var ?comment_post_modified_gmt: String;

	/** The comment's type. **/
	var ?comment_type: String;

	/** The permanent location of the entry the comment is submitted to. **/
	var ?permalink: String;

	/** A string describing why the content is being rechecked. **/
	var ?recheck_reason: String;

	/** The URL of the webpage that linked to the entry being requested. **/
	var ?referrer: String;
}

/** Specifies the type of a comment. **/
enum abstract CommentType(String) from String to String {

	/** A blog post. **/
	var BlogPost = "blog-post";

	/** A blog comment. **/
	var Comment = "comment";

	/** A contact form or feedback form submission. **/
	var ContactForm = "contact-form";

	/** A top-level forum post. **/
	var ForumPost = "forum-post";

	/** A message sent between just a few users. **/
	var Message = "message";

	/** A reply to a top-level forum post. **/
	var Reply = "reply";

	/** A new user account. **/
	var Signup = "signup";
}

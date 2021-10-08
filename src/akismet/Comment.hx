package akismet;

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

	/** Converts this object to a map. **/
	public function toMap() {
		final map = author.toMap();
		if (content.length > 0) map["comment_content"] = content;
		if (date != null) map["comment_date_gmt"] = date.format("%FT%TZ"); // TODO ??? UTC !!! Date.fromTime(comment.date.getTime()).format("%FT%TZ")
		if (permalink != null) map["permalink"] = permalink;
		if (postModified != null) map["comment_post_modified_gmt"] = postModified.format("%FT%TZ");
		if (recheckReason.length > 0) map["recheck_reason"] = recheckReason;
		if (referrer != null) map["referrer"] = referrer;
		if ((type: String).length > 0) map["comment_type"] = type;
		return map;
	}
}

/** Specifies the type of a comment. **/
enum abstract CommentType(String) from String to String {

	/** A comment post. **/
	var BlogPost = "comment-post";

	/** A comment comment. **/
	var Comment = "comment";

	/** A contact form or feedback form submission. **/
	var ContactForm = "contact-form";

	/** A top-level forum post. **/
	var ForumPost = "forum-post";

	/** A [pingback](https://en.wikipedia.org/wiki/Pingback) post. **/
	var Pingback = "pingback";

	/** A [trackback](https://en.wikipedia.org/wiki/Trackback) post. **/
	var Trackback = "trackback";

	/** A [Twitter](https://twitter.com) message. **/
	var Tweet = "tweet";
}

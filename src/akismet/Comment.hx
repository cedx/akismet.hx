package akismet;

import akismet.Author.AuthorData;
import coconut.data.Model;
import tink.Anon;
import tink.Stringly;
import tink.Url;

/** Represents a comment submitted by an author. **/
@:jsonParse(json -> akismet.Comment.fromJson(json))
@:jsonStringify(comment -> comment.formData)
class Comment implements Model {

	/** The comment's author. **/
	@:editable var author: Author;

	/** The comment's content. **/
	@:editable var content: String = @byDefault "";

	/** The UTC timestamp of the creation of the comment. **/
	@:editable var date: Null<Date> = @byDefault null;

	/** The form data corresponding to this object. **/
	@:computed var formData: CommentData = Anon.merge(author.formData, {
		comment_content: content.length > 0 ? content : null,
		comment_date_gmt: date != null ? Tools.toIsoString(date) : null,
		comment_post_modified_gmt: postModified != null ? Tools.toIsoString(postModified) : null,
		comment_type: (type: String).length > 0 ? type : null,
		permalink: permalink != null ? permalink : null,
		recheck_reason: recheckReason.length > 0 ? recheckReason : null,
		referrer: referrer != null ? referrer : null
	});

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

	/** Creates a new comment from the specified JSON object. **/
	public static function fromJson(json: CommentData) return new Comment({
		author: Author.fromJson(json),
		content: json.comment_content ?? "",
		date: json.comment_date_gmt != null ? (json.comment_date_gmt: Stringly) : null,
		permalink: json.permalink,
		postModified: json.comment_post_modified_gmt != null ? (json.comment_post_modified_gmt: Stringly) : null,
		recheckReason: json.recheck_reason ?? "",
		referrer: json.referrer,
		type: json.comment_type ?? ""
	});
}

/** Defines the data of a comment. **/
typedef CommentData = AuthorData & {

	/** The comment's content. **/
	final ?comment_content: String;

	/** The UTC timestamp of the creation of the comment. **/
	final ?comment_date_gmt: String;

	/** The UTC timestamp of the publication time for the post, page or thread on which the comment was posted. **/
	final ?comment_post_modified_gmt: String;

	/** The comment's type. **/
	final ?comment_type: String;

	/** The permanent location of the entry the comment is submitted to. **/
	final ?permalink: String;

	/** A string describing why the content is being rechecked. **/
	final ?recheck_reason: String;

	/** The URL of the webpage that linked to the entry being requested. **/
	final ?referrer: String;
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

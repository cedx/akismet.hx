package akismet;

using DateTools;

/** Represents a comment submitted by an author. **/
@:expose class Comment #if php implements JsonSerializable<DynamicAccess<Any>> #end {

	/** The comment's author. **/
	public var author: Author;

	/** The comment's content. **/
	public var content = "";

	/** The UTC timestamp of the creation of the comment. **/
	public var date: Null<Date> = null;

	/** The permanent location of the entry the comment is submitted to. **/
	public var permalink = "";

	/** The UTC timestamp of the publication time for the post, page or thread on which the comment was posted. **/
	public var postModified: Null<Date> = null;

	/** A string describing why the content is being rechecked. **/
	public var recheckReason = "";

	/** The URL of the webpage that linked to the entry being requested. **/
	public var referrer = "";

	/** The comment's type. **/
	public var type = "";

	/** Creates a new comment. **/
	public function new(author: Author, ?options: #if php NativeStructArray<CommentOptions> #else CommentOptions #end) {
		this.author = author;

		if (options != null) {
			#if php
				if (isset(options["content"])) content = options["content"];
				if (isset(options["date"])) date = options["date"];
				if (isset(options["permalink"])) permalink = options["permalink"];
				if (isset(options["postModified"])) postModified = options["postModified"];
				if (isset(options["recheckReason"])) recheckReason = options["recheckReason"];
				if (isset(options["referrer"])) referrer = options["referrer"];
				if (isset(options["type"])) type = options["type"];
			#else
				if (options.content != null) content = options.content;
				if (options.date != null) date = options.date;
				if (options.permalink != null) permalink = options.permalink;
				if (options.postModified != null) postModified = options.postModified;
				if (options.recheckReason != null) recheckReason = options.recheckReason;
				if (options.referrer != null) referrer = options.referrer;
				if (options.type != null) type = options.type;
			#end
		}
	}

	/** Converts this object to a map in JSON format. **/
	public function toJson() {
		final map = author.toJson();
		if (content.length > 0) map["comment_content"] = content;
		if (date != null) map["comment_date_gmt"] = date.format("%FT%TZ");
		if (permalink.length > 0) map["permalink"] = permalink;
		if (postModified != null) map["comment_post_modified_gmt"] = postModified.format("%FT%TZ");
		if (recheckReason.length > 0) map["recheck_reason"] = recheckReason;
		if (referrer.length > 0) map["referrer"] = referrer;
		if (type.length > 0) map["comment_type"] = type;
		return map;
	}

	#if js
		/** Converts this object to a map in JSON format. **/
		public function toJSON() return toJson();
	#elseif php
		/** Converts this object to a map in JSON format. **/
		public function jsonSerialize() return toJson();
	#end
}

/** Defines the options of a `Comment` instance. **/
typedef CommentOptions = {

	/** The comment's content. **/
	var ?content: String;

	/** The UTC timestamp of the creation of the comment. **/
	var ?date: Date;

	/** The permanent location of the entry the comment is submitted to. **/
	var ?permalink: String;

	/** The UTC timestamp of the publication time for the post, page or thread on which the comment was posted. **/
	var ?postModified: Date;

	/** A string describing why the content is being rechecked. **/
	var ?recheckReason: String;

	/** The URL of the webpage that linked to the entry being requested. **/
	var ?referrer: String;

	/** The comment's type. **/
	var ?type: String;
}

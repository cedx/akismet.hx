package akismet;

import coconut.data.List;
import coconut.data.Model;
import tink.Url;

/** Represents the front page or home URL transmitted when making requests. **/
@:jsonParse(json -> akismet.Blog.fromJson(json))
@:jsonStringify(blog -> blog.toJson())
class Blog implements Model {

	/** The character encoding for the values included in comments. **/
	@:editable var charset: String = @byDefault "";

	/** The languages in use on the blog or site, in ISO 639-1 format. **/
	@:editable var languages: List<String> = @byDefault new List();

	/** The blog or site URL. **/
	@:editable var url: Url;

	/** Creates a new blog from the specified JSON object. **/
	public static function fromJson(json: BlogData) return new Blog({
		charset: json.blog_charset,
		languages: json.blog_lang != null ? json.blog_lang.split(",").map(StringTools.trim) : [],
		url: json.blog
	});

	/** Converts this object to a map in JSON format. **/
	public function toJson(): BlogData return {
		blog: url,
		blog_charset: charset.length > 0 ? charset : null,
		blog_lang: languages.length > 0 ? languages.toArray().join(",") : null
	};
}

/** Defines the data of a blog. **/
typedef BlogData = {

	/** The blog or site URL. **/
	var blog: String;

	/** The character encoding for the values included in comments. **/
	var ?blog_charset: String;

	/** The languages in use on the blog or site. **/
	var ?blog_lang: String;
}

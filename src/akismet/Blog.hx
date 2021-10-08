package akismet;

import tink.Url;

/** Represents the front page or home URL transmitted when making requests. **/
#if tink_json
@:jsonParse(json -> new akismet.Blog(json))
@:jsonStringify(blog -> {
	charset: blog.charset,
	languages: blog.languages,
	url: blog.url
})
#end
class Blog implements Model {

	/** The character encoding for the values included in comments. **/
	@:editable var charset: String = @byDefault "";

	/** The languages in use on the blog or site, in ISO 639-1 format. **/
	@:editable var languages: List<String> = @byDefault [];

	/** The blog or site URL. **/
	@:editable var url: Url;

	/** Converts this object to a map. **/
	public function toMap() {
		final map: Map<String, String> = ["blog" => url];
		if (charset.length > 0) map["blog_charset"] = charset;
		if (languages.length > 0) map["blog_lang"] = languages.toArray().join(",");
		return map;
	}
}

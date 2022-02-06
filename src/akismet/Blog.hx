package akismet;

import coconut.data.List;
import coconut.data.Model;
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
	@:editable var languages: List<String> = @byDefault new List();

	/** The blog or site URL. **/
	@:editable var url: Url;

	/** Converts this object to form data. **/
	public function toFormData() {
		final data: BlogFormData = {blog: url};
		if (charset.length > 0) data.blog_charset = charset;
		if (languages.length > 0) data.blog_lang = languages.toArray().join(",");
		return data;
	}
}

/** Defines the form data of a blog. **/
typedef BlogFormData = {

	/** The blog or site URL. **/
	var blog: String;

	/** The character encoding for the values included in comments. **/
	var ?blog_charset: String;

	/** The languages in use on the blog or site. **/
	var ?blog_lang: String;
}

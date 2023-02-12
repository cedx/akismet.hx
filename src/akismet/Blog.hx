package akismet;

import coconut.data.List;
import coconut.data.Model;
import tink.Url;

/** Represents the front page or home URL transmitted when making requests. **/
@:jsonParse(json -> new akismet.Blog(json))
@:jsonStringify(blog -> {
	charset: blog.charset,
	languages: blog.languages,
	url: blog.url
})
class Blog implements Model {

	/** The character encoding for the values included in comments. **/
	@:editable var charset: String = @byDefault "";

	/** The form data corresponding to this object. **/
	@:computed var formData: BlogFormData = {
		blog: url,
		blog_charset: charset.length > 0 ? charset : null,
		blog_lang: languages.length > 0 ? languages.toArray().join(",") : null
	};

	/** The languages in use on the blog or site, in ISO 639-1 format. **/
	@:editable var languages: List<String> = @byDefault new List();

	/** The blog or site URL. **/
	@:editable var url: Url;
}

/** Defines the form data of a blog. **/
typedef BlogFormData = {

	/** The blog or site URL. **/
	final blog: String;

	/** The character encoding for the values included in comments. **/
	final ?blog_charset: String;

	/** The languages in use on the blog or site. **/
	final ?blog_lang: String;
}

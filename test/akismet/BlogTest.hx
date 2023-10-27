package akismet;

import akismet.Blog.BlogData;
import tink.Json;
import tink.QueryString;
import tink.url.Query;

/** Tests the features of the `Blog` class. **/
@:asserts final class BlogTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `fromJson()` method. **/
	public function fromJson() {
		var blog: Blog;

		blog = Json.parse('{"blog": "https://github.com/cedx/akismet.hx"}');
		asserts.assert(blog.charset == "");
		asserts.assert(blog.languages.length == 0);
		asserts.assert(blog.url == "https://github.com/cedx/akismet.hx");

		blog = Json.parse('{"blog": "https://github.com/cedx/akismet.hx", "blog_charset": "UTF-8", "blog_lang": "en, fr"}');
		asserts.assert(blog.charset == "UTF-8");
		asserts.compare(["en", "fr"], blog.languages.toArray());
		asserts.assert(blog.url == "https://github.com/cedx/akismet.hx");

		return asserts.done();
	}

	/** Tests the `toJson()` method. **/
	public function toJson() {
		var json: BlogData;

		json = new Blog({url: "https://github.com/cedx/akismet.hx"}).toJson();
		asserts.assert(getFields(json).length == 1);
		asserts.assert(json.blog == "https://github.com/cedx/akismet.hx");

		json = new Blog({charset: "UTF-8", languages: ["en", "fr"], url: "https://github.com/cedx/akismet.hx"}).toJson();
		asserts.assert(getFields(json).length == 3);
		asserts.assert(json.blog == "https://github.com/cedx/akismet.hx");
		asserts.assert(json.blog_charset == "UTF-8");
		asserts.assert(json.blog_lang == "en,fr");

		return asserts.done();
	}

	/** Gets the fields of the specified form data. **/
	function getFields(formData: BlogData)
		return [for (param in Query.parseString(QueryString.build(formData))) param.name];
}

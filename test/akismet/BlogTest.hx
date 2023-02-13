package akismet;

import akismet.Blog.BlogFormData;
import tink.Json;
import tink.QueryString;
import tink.url.Query;

/** Tests the features of the `Blog` class. **/
@:asserts final class BlogTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `formData` property. **/
	public function testFormData() {
		var formData: BlogFormData;

		formData = new Blog({url: "https://github.com/cedx/akismet.hx"}).formData;
		asserts.assert(getFields(formData).length == 1);
		asserts.assert(formData.blog == "https://github.com/cedx/akismet.hx");

		formData = new Blog({charset: "UTF-8", languages: ["en", "fr"], url: "https://github.com/cedx/akismet.hx"}).formData;
		asserts.assert(getFields(formData).length == 3);
		asserts.assert(formData.blog == "https://github.com/cedx/akismet.hx");
		asserts.assert(formData.blog_charset == "UTF-8");
		asserts.assert(formData.blog_lang == "en,fr");

		return asserts.done();
	}

	/** Tests the JSON parsing. **/
	public function testFromJson() {
		var blog: Blog;

		blog = Json.parse('{"blog": "https://github.com/cedx/akismet.hx"}');
		asserts.assert(blog.charset == "");
		asserts.assert(blog.languages.length == 0);
		asserts.assert(blog.url == "https://github.com/cedx/akismet.hx");

		blog = Json.parse('{"blog": "https://github.com/cedx/akismet.hx", "blog_charset": "UTF-8", "blog_lang": "en, fr"}');
		asserts.assert(blog.charset == "UTF-8");
		asserts.compare(blog.languages.toArray(), ["en", "fr"]);
		asserts.assert(blog.url == "https://github.com/cedx/akismet.hx");

		return asserts.done();
	}

	/** Gets the fields of the specified form data. **/
	function getFields(formData: BlogFormData)
		return [for (param in Query.parseString(QueryString.build(formData))) param.name];
}

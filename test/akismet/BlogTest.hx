package akismet;

import haxe.DynamicAccess;

/** Tests the features of the `Blog` class. **/
@:asserts class BlogTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toFormData()` method. **/
	public function testToFormData() {
		var data: DynamicAccess<String>;

		// It should return only the blog URL with a newly created instance.
		data = new Blog({url: "https://bitbucket.org/cedx/akismet.hx"}).toFormData();
		asserts.assert(data.keys().length == 1);
		asserts.assert(data["blog"] == "https://bitbucket.org/cedx/akismet.hx");

		// It should return a non-empty map with an initialized instance.
		data = new Blog({charset: "UTF-8", languages: ["en", "fr"], url: "https://bitbucket.org/cedx/akismet.hx"}).toFormData();
		asserts.assert(data.keys().length == 3);
		asserts.assert(data["blog"] == "https://bitbucket.org/cedx/akismet.hx");
		asserts.assert(data["blog_charset"] == "UTF-8");
		asserts.assert(data["blog_lang"] == "en,fr");

		return asserts.done();
	}
}

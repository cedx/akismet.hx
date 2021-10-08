package akismet;

using Lambda;

/** Tests the features of the `Blog` class. **/
@:asserts class BlogTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toMap()` method. **/
	public function testToMap() {
		// It should return only the blog URL with a newly created instance.
		var map = new Blog({url: "https://cedx.github.io/akismet.hx"}).toMap();
		asserts.assert(map.count() == 1);
		asserts.assert(map["blog"] == "https://cedx.github.io/akismet.hx");

		// It should return a non-empty map with an initialized instance.
		map = new Blog({charset: "UTF-8", languages: ["en", "fr"], url: "https://cedx.github.io/akismet.hx"}).toMap();
		asserts.assert(map.count() == 3);
		asserts.assert(map["blog"] == "https://cedx.github.io/akismet.hx");
		asserts.assert(map["blog_charset"] == "UTF-8");
		asserts.assert(map["blog_lang"] == "en,fr");

		return asserts.done();
	}
}

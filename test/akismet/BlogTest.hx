package akismet;

/** Tests the features of the `Blog` class. **/
class BlogTest extends Test {

	/** Tests the `toJson()` method. **/
	function testToJson() {
		// It should return only the blog URL with a newly created instance.
		var data = new Blog("https://docs.belin.io/akismet.hx").toJson();
		Assert.equals(1, data.keys().length);
		Assert.equals("https://docs.belin.io/akismet.hx", data["blog"]);

		// It should return a non-empty map with an initialized instance.
		data = new Blog("https://docs.belin.io/akismet.hx", {charset: "UTF-8", languages: ["en", "fr"]}).toJson();
		Assert.equals(3, data.keys().length);
		Assert.equals("https://docs.belin.io/akismet.hx", data["blog"]);
		Assert.equals("UTF-8", data["blog_charset"]);
		Assert.equals("en,fr", data["blog_lang"]);
	}
}

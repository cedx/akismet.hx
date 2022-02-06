package akismet;

import haxe.DynamicAccess;

/** Tests the features of the `Comment` class. **/
@:asserts class CommentTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toFormData()` method. **/
	public function testToFormData() {
		var data: DynamicAccess<String>;

		// It should return only the author info with a newly created instance.
		data = new Comment({author: new Author({ipAddress: "127.0.0.1", userAgent: "Doom/6.6.6"})}).toFormData();
		asserts.assert(data.keys().length == 2);
		asserts.assert(data["user_agent"] == "Doom/6.6.6");
		asserts.assert(data["user_ip"] == "127.0.0.1");

		// It should return a non-empty map with an initialized instance.
		data = new Comment({
			author: new Author({ipAddress: "127.0.0.1", name: "Cédric Belin", userAgent: "Doom/6.6.6"}),
			content: "A user comment.",
			date: Date.fromString("2000-01-01 00:00:00"),
			referrer: "https://belin.io",
			type: BlogPost
		}).toFormData();

		asserts.assert(data.keys().length == 7);
		asserts.assert(data["comment_author"] == "Cédric Belin");
		asserts.assert(data["comment_content"] == "A user comment.");
		asserts.assert(~/^\d{4}(-\d{2}){2}T\d{2}(:\d{2}){2}Z$/.match(data["comment_date_gmt"]));
		asserts.assert(data["comment_type"] == "blog-post");
		asserts.assert(data["referrer"] == "https://belin.io");
		asserts.assert(data["user_agent"] == "Doom/6.6.6");
		asserts.assert(data["user_ip"] == "127.0.0.1");

		return asserts.done();
	}
}

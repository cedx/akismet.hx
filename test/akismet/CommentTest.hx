package akismet;

using Lambda;

/** Tests the features of the `Comment` class. **/
@:asserts class CommentTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toMap()` method. **/
	public function testToMap() {
		// It should return only the author info with a newly created instance.
		var map = new Comment({
			author: new Author({ipAddress: "127.0.0.1", userAgent: "Doom/6.6.6"})
		}).toMap();

		asserts.assert(map.count() == 2);
		asserts.assert(map["user_agent"] == "Doom/6.6.6");
		asserts.assert(map["user_ip"] == "127.0.0.1");

		// It should return a non-empty map with an initialized instance.
		map = new Comment({
			author: new Author({ipAddress: "127.0.0.1", name: "Cédric Belin", userAgent: "Doom/6.6.6"}),
			content: "A user comment.",
			date: Date.fromString("2000-01-01 00:00:00"),
			referrer: "https://belin.io",
			type: Pingback
		}).toMap();

		asserts.assert(map.count() == 7);
		asserts.assert(map["comment_author"] == "Cédric Belin");
		asserts.assert(map["comment_content"] == "A user comment.");
		asserts.assert(map["comment_date_gmt"] == "2000-01-01T00:00:00Z");
		asserts.assert(map["comment_type"] == "pingback");
		asserts.assert(map["referrer"] == "https://belin.io");
		asserts.assert(map["user_agent"] == "Doom/6.6.6");
		asserts.assert(map["user_ip"] == "127.0.0.1");

		return asserts.done();
	}
}

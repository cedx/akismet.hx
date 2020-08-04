package akismet;

/** Tests the features of the `Comment` class. **/
class CommentTest extends Test {

	/** Tests the `toJson()` method. **/
	function testToJson() {
		// It should return only the author info with a newly created instance.
		var data = new Comment(new Author("127.0.0.1", "Doom/6.6.6")).toJson();
		Assert.equals(2, data.keys().length);
		Assert.equals("Doom/6.6.6", data["user_agent"]);
		Assert.equals("127.0.0.1", data["user_ip"]);

		// It should return a non-empty map with an initialized instance.
		data = new Comment(new Author("127.0.0.1", "Doom/6.6.6", {name: "Cédric Belin"}), {
			content: "A user comment.",
			date: Date.fromString("2000-01-01 00:00:00"),
			referrer: "https://belin.io",
			type: CommentType.Pingback
		}).toJson();

		Assert.equals(7, data.keys().length);
		Assert.equals("Cédric Belin", data["comment_author"]);
		Assert.equals("A user comment.", data["comment_content"]);
		Assert.equals("2000-01-01T00:00:00Z", data["comment_date_gmt"]);
		Assert.equals("pingback", data["comment_type"]);
		Assert.equals("https://belin.io", data["referrer"]);
		Assert.equals("Doom/6.6.6", data["user_agent"]);
		Assert.equals("127.0.0.1", data["user_ip"]);
	}
}

package akismet;

/** Tests the features of the `Author` class. **/
class AuthorTest extends Test {

	/** Tests the `toJson()` method. **/
	function testToJson() {
		// It should return only the IP address and user agent with a newly created instance.
		var data = new Author("127.0.0.1", "Doom/6.6.6").toJson();
		Assert.equals(2, data.keys().length);
		Assert.equals("Doom/6.6.6", data.get("user_agent"));
		Assert.equals("127.0.0.1", data.get("user_ip"));

		// It should return a non-empty map with an initialized instance.
		data = new Author("192.168.0.1", "Mozilla/5.0", {
			email: "cedric@belin.io",
			name: "Cédric Belin",
			url: "https://belin.io"
		}).toJson();

		Assert.equals(5, data.keys().length);
		Assert.equals("Cédric Belin", data.get("comment_author"));
		Assert.equals("cedric@belin.io", data.get("comment_author_email"));
		Assert.equals("https://belin.io", data.get("comment_author_url"));
		Assert.equals("Mozilla/5.0", data.get("user_agent"));
		Assert.equals("192.168.0.1", data.get("user_ip"));
	}
}

package akismet;

import akismet.Author.AuthorFormData;
import tink.QueryString;
import tink.url.Query;

/** Tests the features of the `Author` class. **/
@:asserts class AuthorTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `formData` property. **/
	public function testFormData() {
		var formData: AuthorFormData;

		formData = new Author({ipAddress: "127.0.0.1"}).formData;
		asserts.assert(getFields(formData).length == 1);
		asserts.assert(formData.user_ip == "127.0.0.1");

		formData = new Author({
			email: "cedric@belin.io",
			ipAddress: "192.168.0.1",
			name: "Cédric Belin",
			url: "https://belin.io",
			userAgent: "Mozilla/5.0"
		}).formData;

		asserts.assert(getFields(formData).length == 5);
		asserts.assert(formData.comment_author == "Cédric Belin");
		asserts.assert(formData.comment_author_email == "cedric@belin.io");
		asserts.assert(formData.comment_author_url == "https://belin.io");
		asserts.assert(formData.user_agent == "Mozilla/5.0");
		asserts.assert(formData.user_ip == "192.168.0.1");

		return asserts.done();
	}

	/** Gets the fields of the specified form data. **/
	function getFields(formData: AuthorFormData)
		return [for (param in Query.parseString(QueryString.build(formData))) param.name];
}

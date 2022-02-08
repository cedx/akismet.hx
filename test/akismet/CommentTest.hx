package akismet;

import akismet.Comment.CommentFormData;
import tink.QueryString;
import tink.url.Query;

/** Tests the features of the `Comment` class. **/
@:asserts class CommentTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `formData` property. **/
	public function testFormData() {
		var formData: CommentFormData;

		// It should return only the author info with a newly created instance.
		formData = new Comment({author: new Author({ipAddress: "127.0.0.1"})}).formData;
		asserts.assert(getFields(formData).length == 1);
		asserts.assert(formData.user_ip == "127.0.0.1");

		// It should return a non-empty map with an initialized instance.
		formData = new Comment({
			author: new Author({ipAddress: "127.0.0.1", name: "Cédric Belin", userAgent: "Doom/6.6.6"}),
			content: "A user comment.",
			date: Date.fromString("2000-01-01 00:00:00"),
			referrer: "https://belin.io",
			type: BlogPost
		}).formData;

		asserts.assert(getFields(formData).length == 7);
		asserts.assert(formData.comment_author == "Cédric Belin");
		asserts.assert(formData.comment_content == "A user comment.");
		asserts.assert(~/^\d{4}(-\d{2}){2}T\d{2}(:\d{2}){2}Z$/.match(formData.comment_date_gmt));
		asserts.assert(formData.comment_type == "blog-post");
		asserts.assert(formData.referrer == "https://belin.io");
		asserts.assert(formData.user_agent == "Doom/6.6.6");
		asserts.assert(formData.user_ip == "127.0.0.1");

		return asserts.done();
	}

	/** Gets the fields of the specified form data. **/
	function getFields(formData: CommentFormData)
		return [for (param in Query.parseString(QueryString.build(formData))) param.name];
}

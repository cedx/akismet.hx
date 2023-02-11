package akismet;

import coconut.data.Model;
import tink.Url;

/** Represents the author of a comment. **/
@:jsonParse(json -> new akismet.Author(json))
@:jsonStringify(author -> author.formData)
class Author implements Model {

	/** The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `true`. **/
	@:editable var email: String = @byDefault "";

	/** The form data corresponding to this object. **/
	@:computed var formData: AuthorFormData = {
		comment_author: name.length > 0 ? name : null,
		comment_author_email: email.length > 0 ? email : null,
		comment_author_url: url != null ? url : null,
		user_agent: userAgent.length > 0 ? userAgent : null,
		user_ip: ipAddress,
		user_role: (role: String).length > 0 ? role : null
	};

	/** The author's IP address. **/
	@:editable var ipAddress: String;

	/** The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `true`. **/
	@:editable var name: String = @byDefault "";

	/** The author's role. If you set it to `"administrator"`, Akismet will always return `false`. **/
	@:editable var role: AuthorRole = @byDefault "";

	/** The URL of the author's website. **/
	@:editable var url: Null<Url> = @byDefault null;

	/** The author's user agent, that is the string identifying the Web browser used to submit comments. **/
	@:editable var userAgent: String = @byDefault "";
}

/** Defines the form data of an author. **/
typedef AuthorFormData = {

	/** The author's name. **/
	final ?comment_author: String;

	/** The author's mail address. **/
	final ?comment_author_email: String;

	/** The URL of the author's website. **/
	final ?comment_author_url: String;

	/** The author's user agent. **/
	final ?user_agent: String;

	/** The author's IP address. **/
	final user_ip: String;

	/** The author's role. **/
	final ?user_role: String;
}

/** Specifies the role of an author. **/
enum abstract AuthorRole(String) from String to String {

	/** The author is an administrator. **/
	var Administrator = "administrator";
}

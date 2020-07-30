package akismet;

/** Specifies the type of a comment. **/
enum abstract CommentType(String) from String to String {

	/** A blog post. **/
	var BlogPost = "blog-post";

	/** A blog comment. **/
	var Comment = "comment";

	/** A contact form or feedback form submission. **/
	var ContactForm = "contact-form";

	/** A top-level forum post. **/
	var ForumPost = "forum-post";

	/** A [pingback](https://en.wikipedia.org/wiki/Pingback) post. **/
	var Pingback = "pingback";

	/** A [trackback](https://en.wikipedia.org/wiki/Trackback) post. **/
	var Trackback = "trackback";

	/** A [Twitter](https://twitter.com) message. **/
	var Tweet = "tweet";
}

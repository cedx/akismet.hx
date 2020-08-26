package akismet;

/** Represents the front page or home URL transmitted when making requests. **/
@:expose class Blog #if php implements JsonSerializable<DynamicAccess<String>> #end {

	/** The character encoding for the values included in comments. **/
	public var charset = "";

	/** The languages in use on the blog or site, in ISO 639-1 format. **/
	public var languages: Array<String> = [];

	/** The blog or site URL. **/
	public var url: String;

	/** Creates a new blog. **/
	public function new(url: String, ?options: #if php NativeStructArray<BlogOptions> #else BlogOptions #end) {
		this.url = url;

		if (options != null) {
			#if php
				if (isset(options["charset"])) charset = options["charset"];
				if (isset(options["languages"])) languages = options["languages"];
			#else
				if (options.charset != null) charset = options.charset;
				if (options.languages != null) languages = options.languages;
			#end
		}
	}

	/** Converts this object to a map in JSON format. **/
	public function toJson() {
		final map: DynamicAccess<String> = {blog: url};
		if (charset.length > 0) map["blog_charset"] = charset;
		if (languages.length > 0) map["blog_lang"] = languages.join(",");
		return map;
	}

	#if js
		/** Converts this object to a map in JSON format. **/
		public final function toJSON() return toJson();
	#elseif php
		/** Converts this object to a map in JSON format. **/
		public final function jsonSerialize() return toJson();
	#end
}

/** Defines the options of a `Blog` instance. **/
typedef BlogOptions = {

	/** The character encoding for the values included in comments. **/
	var ?charset: String;

	/** The languages in use on the blog or site, in ISO 639-1 format. **/
	var ?languages: Array<String>;
}

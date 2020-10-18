<?php
/**
 * Generated by Haxe 4.1.4
 */

namespace akismet;

use \php\Boot;

/**
 * Represents a comment submitted by an author.
 */
class Comment implements \JsonSerializable {
	/**
	 * @var Author
	 * The comment's author.
	 */
	public $author;
	/**
	 * @var string
	 * The comment's content.
	 */
	public $content;
	/**
	 * @var \Date
	 * The UTC timestamp of the creation of the comment.
	 */
	public $date;
	/**
	 * @var string
	 * The permanent location of the entry the comment is submitted to.
	 */
	public $permalink;
	/**
	 * @var \Date
	 * The UTC timestamp of the publication time for the post, page or thread on which the comment was posted.
	 */
	public $postModified;
	/**
	 * @var string
	 * A string describing why the content is being rechecked.
	 */
	public $recheckReason;
	/**
	 * @var string
	 * The URL of the webpage that linked to the entry being requested.
	 */
	public $referrer;
	/**
	 * @var string
	 * The comment's type.
	 */
	public $type;

	/**
	 * Creates a new comment.
	 * 
	 * @param Author $author
	 * @param mixed $options
	 * 
	 * @return void
	 */
	public function __construct ($author, $options = null) {
		$this->type = "";
		$this->referrer = "";
		$this->recheckReason = "";
		$this->postModified = null;
		$this->permalink = "";
		$this->date = null;
		$this->content = "";
		$this->author = $author;
		if ($options !== null) {
			if (isset($options["content"])) {
				$this->content = $options["content"];
			}
			if (isset($options["date"])) {
				$this->date = $options["date"];
			}
			if (isset($options["permalink"])) {
				$this->permalink = $options["permalink"];
			}
			if (isset($options["postModified"])) {
				$this->postModified = $options["postModified"];
			}
			if (isset($options["recheckReason"])) {
				$this->recheckReason = $options["recheckReason"];
			}
			if (isset($options["referrer"])) {
				$this->referrer = $options["referrer"];
			}
			if (isset($options["type"])) {
				$this->type = $options["type"];
			}
		}
	}

	/**
	 * Converts this object to a map in JSON format.
	 * 
	 * @return mixed
	 */
	final public function jsonSerialize () {
		return $this->toJson();
	}

	/**
	 * Converts this object to a map in JSON format.
	 * 
	 * @return mixed
	 */
	public function toJson () {
		$map = $this->author->toJson();
		if (mb_strlen($this->content) > 0) {
			\Reflect::setField($map, "comment_content", $this->content);
		}
		if ($this->date !== null) {
			\Reflect::setField($map, "comment_date_gmt", \DateTools::format($this->date, "%FT%TZ"));
		}
		if (mb_strlen($this->permalink) > 0) {
			\Reflect::setField($map, "permalink", $this->permalink);
		}
		if ($this->postModified !== null) {
			\Reflect::setField($map, "comment_post_modified_gmt", \DateTools::format($this->postModified, "%FT%TZ"));
		}
		if (mb_strlen($this->recheckReason) > 0) {
			\Reflect::setField($map, "recheck_reason", $this->recheckReason);
		}
		if (mb_strlen($this->referrer) > 0) {
			\Reflect::setField($map, "referrer", $this->referrer);
		}
		if (mb_strlen($this->type) > 0) {
			\Reflect::setField($map, "comment_type", $this->type);
		}
		return $map;
	}
}

Boot::registerClass(Comment::class, 'akismet.Comment');

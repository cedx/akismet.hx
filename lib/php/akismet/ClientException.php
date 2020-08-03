<?php
/**
 * Generated by Haxe 4.1.3
 */

namespace akismet;

use \php\Boot;
use \haxe\Exception;

/**
 * An exception caused by an error in a `Client` request.
 */
class ClientException extends Exception {
	/**
	 * @var string
	 * The URL of the HTTP request that failed.
	 */
	public $url;

	/**
	 * Creates a new LCOV exception.
	 * 
	 * @param string $message
	 * @param string $url
	 * @param Exception $previous
	 * 
	 * @return void
	 */
	public function __construct ($message = "", $url = "", $previous = null) {
		if ($message === null) {
			$message = "";
		}
		if ($url === null) {
			$url = "";
		}
		parent::__construct($message, $previous);
		$this->url = $url;
	}
}

Boot::registerClass(ClientException::class, 'akismet.ClientException');
package kpaas.msa.common;

@SuppressWarnings("serial")
public class RedirectException extends Exception {

	public int statusCode;
	public String url;
	
	public RedirectException() {
		super();
	}

	public RedirectException(int statusCode, String url) {
		this.statusCode = statusCode;
		this.url = url;
	}
}

# CLARIN error and maintenance pages

Get a distribution file or build them yourself by calling `sh build.sh`.

Then configure your web server to serve these files, for example in nginx:

```
	error_page 403 /error/403.html;
	error_page 404 /error/404.html;
	error_page 500 501 502 503 504 /error/5xx.html;

	location ^~ /error/ {
		internal;
		root /var/www/error-maintenance-pages/dist;
	}
```
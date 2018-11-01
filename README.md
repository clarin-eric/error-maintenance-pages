# CLARIN error and maintenance pages

Get a distribution file from the 'releases' page, or build them yourself by calling
```sh
sh ./build.sh
```

## Custom error pages

Configure your web server to serve the files in case of supported error response.
For example in nginx:

```nginx
	error_page 403 /error/403.html;
	error_page 404 /error/404.html;
	error_page 500 501 502 504 /error/5xx.html;
	error_page 503 /error/maintenance.html;

	location ^~ /error/ {
		internal;
		alias /srv/error-maintenance-pages/dist/;
	}
	
	location ^~ /error_inc/style {
		alias /srv/error-maintenance-pages/dist/style/;
	}
```

## Maintenance

The special `maintenance.html` page can be used to replace proxied content that is
made temporarily unavailable, for example during maintenance. It can be used in 
combination with a 'semaphore' file that allows for quick enabling/disabling of 
maintenance mode - a specific approach is described with examples in the blog post
["How to configure Nginx so you can quickly put your website into maintenance mode"](https://www.calazan.com/how-to-configure-nginx-so-you-can-quickly-put-your-website-into-maintenance-mode/).

For example, for the vlo.clarin.eu vhost configuration:
```nginx

    location / {
        if (-f /srv/www_state/maintenance/vlo_on) {
            return 503;
        }

        ...
    }
```

Make the file `/srv/www_state/maintenance/vlo_on` available to put the application in
maintenance mode without having to make any changes to the configuration.

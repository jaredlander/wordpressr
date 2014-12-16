This package has high level functions for working with the WordPress API and wrapper functions for working with RMarkdown.

Until WordPress version 4.1 is released you need to install and activate the JSON REST API pluging available at https://wordpress.org/plugins/json-rest-api/.

You also need to manually install and activate the oauth-server plugging by either cloning the GitHub repository or manually uploading the folders to the `wp-contetns/plugins` folder on your server.  The repository is at https://github.com/WP-API/OAuth1.

Then you need to create a user by running `wp oauth1 add` from the server command line and make note of the `Key` and `Secret`.

After this step you need to go through the process of getting a token as described in https://github.com/WP-API/OAuth1/blob/master/docs/spec.md.

Save this token to options or use it in function calls.

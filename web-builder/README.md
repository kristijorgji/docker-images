# web-builder

Used to build php + js projects.

Alpine image containing the following:

1. Composer from `kristijorgji/php-fpm-8-nginx:0.0.9` (PHP 8.5.12)
2. `nodejs`, `npm`, and `yarn` from Alpine 3.24
3. global `gulp`

Tag `0.0.2` and earlier were based on `php-fpm-8-nginx:0.02` and pinned Node 8.14 from Alpine 3.8. Tag `0.0.3` moves to the patched PHP image. Node 8.14 is not available on that base.

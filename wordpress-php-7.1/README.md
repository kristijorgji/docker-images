# kristijorgji/wordpress-php-7.1

To use this image, you only need to volume mount or COPY during extended image build the code files of wordpress

Example with docker-compose mounting the volume
```
version: "3.7"
services:
  wordpress:
    image: kristijorgji/wordpress-php-7.1:0.0.0
    volumes:
      - ./kristijorgji.com:/var/www/html/app
    ports:
      - "80:80"
    restart: always
```

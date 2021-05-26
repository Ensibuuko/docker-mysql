FROM alpine:latest

# Create users and group that our app will run as since
# there is not sudo and mariaDB doesn't recommned running
# mariaDB as root
RUN addgroup -S mysql && adduser -S mysql -G mysql
# install mysql
RUN apk add mysql mysql-client

# Install bash coz our entrypoint is a bash script and 
# apline doesn't have bash
RUN apk add bash

# Create MySQL dirs
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 1777 /var/lib/mysql /var/run/mysqld

# Create volume
VOLUME /var/lib/mysql

# Run every other command as user created above
USER mysql

# Expose the mysql port
EXPOSE 3306

# Run mysql
COPY entrypoint.sh .
ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "mysqld" ]
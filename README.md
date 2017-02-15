# Groovlets

A [Groovlet](http://docs.groovy-lang.org/latest/html/documentation/servlet-userguide.html) is a Groovy script that can be served as a web service.  Currently calls to http://api.lappsgrid.org will forward to a Jetty server (see server.groovy) that serves these scripts as web services.

## http://api.lappsgrid.org/pull

The **webhook** that GitHub will POST messages to when code is pushed.  After doing some error and sanity checking the service calls the bash script /var/lib/downloads/scripts/pull.sh 

## http://api.lappsgrid.org/password

The password service uses a cryptographically secure random number generator to produce a random sequence of characters.  Use the password service any time a secure password and/or security key is required.

### Parameters

- **type** one of **default**, **safe**, or **hex**
- **chars** the set of characters used to generate the password
- **length** the number of characters to produce.

The password service will always produce at least 16 characters of output.


### Examples

http://api.lappsgrid.org/password<br/>
Returns a 16 character random string.

http://api.lappsgrid.org/password?length=32<br/>
Returns a 32 character random string.

http://api.lappsgrid.org/password?chars=01&length=64<br/>
Generates a string of 64 zeros or ones






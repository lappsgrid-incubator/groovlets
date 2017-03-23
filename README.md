# Groovlets

A [Groovlet](http://docs.groovy-lang.org/latest/html/documentation/servlet-userguide.html) is a Groovy script that is run in a Java Servlet container and served as a web service.  Currently calls to http://api.lappsgrid.org will forward to a Jetty server (see server.groovy) that serves these scripts as web services.

- [pull](#pull)
- [password](#password)
- [lookup](#lookup)
- [producers](#producers)
- [soap-proxy](#soap-proxy)

<a name="pull/>
## http://api.lappsgrid.org/pull

The **webhook** that GitHub will POST messages to when code is pushed.  After doing some error and sanity checking the service calls the bash script /var/lib/downloads/scripts/pull.sh 

## http://api.lappsgrid.org/password

The password service uses a cryptographically secure random number generator to produce a random sequence of characters.  Use the password service any time a secure password and/or security key is required.

### Parameters

- **type** one of *default*, *safe*, or *hex*
- **chars** the set of characters used to generate the password
- **length** the number of characters to produce.

#### Types

- **default** the set of most printable ASCII characters (minus quotes).
- **safe** letters (upper and lower case), digits, and the characters _-=,.<br/>
The *safe* type is intended to be used to generate passwords or keys that can be safely included in scripts.
- **hex** the hexadecimal digits 0123456789abcde


The password service will always produce at least 16 characters of output.

<a name="lookup"/>
## http://api.lappsgrid.org/lookup

The LAPPS Grid Peristent Identifier Registry. Use this service to lookup the PID assigned to any 

### Examples

http://api.lappsgrid.org/password<br/>
Returns a 16 character random string.

http://api.lappsgrid.org/password?length=32<br/>
Returns a 32 character random string.

http://api.lappsgrid.org/password?chars=01&length=64<br/>
Generates a string of 64 zeros or ones





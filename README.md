# hexagonlabbcat

[Hexagon CMS](https://sourceforge.net/projects/hexagoncms/) module for allowing Hexagon to
access LaBB-CAT transcript/participant meta-data.

## Building the module

Ensure you have Apache `ant` installed. Then run the following commands:

```
cd META-INF
ant
```

This will create a file in the parent directory called `labbcat.jar`, which is a module
you can install in your Hexagon CMS system.

## Configuration

The module needs direct access to the LaBB-CAT MySQL database in order to work, so you
will need to set the database URL, username, and password in the module configuration.

These details can be found in your LaBB-CAT web-app installation, in the file:
`META-INF/context.xml`



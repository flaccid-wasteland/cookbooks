maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Simple Hello World! demonstration cookbook."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "hello_world::default", "Prints Hello World! to Chef log."

attribute "hello_world/text",
  :display_name => "Hello world text",
  :description => "The text to use for the 'hello, world' program.",
  :required => "optional",
  :default => "Hello, world!",
  :recipes => [ "hello_world::default" ]
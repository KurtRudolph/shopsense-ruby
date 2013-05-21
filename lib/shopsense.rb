require 'net/http'
require 'cgi'
=begin rdoc
Shopsense is an easy to use Ruby interface for the {Shopstyle API}[https://shopsense.shopstyle.com/page/ShopSenseHome],
also known a ShopSense.  The ShopStyle API is a free service from ShopStyle that pays you for sending traffic
to online retailers from your blog, website, or application.

The ShopStyle API allows client applications to retrieve the underlying data for all the basic elements of the
ShopStyle websites, including products, brands, retailers, categories, and looks. For ease of development,
the API is a REST-style web service, composed of simple HTTP GET requests. Data is returned to the client in
either XML or JSON formats. The API is client-language independent and easy to use from PHP, Java, JavaScript,
or any other modern development context.

Shopsense provides a number of helpful classes and methods for integrating data aquired from the ShopStyle API into
your application.

== Roadmap
* If you think you found a bug in Shopsense see DEVELOPERS@Bugs
* If you want to use Shopsense to interface with the ShopStyle API
  see Shopsense::API
=end

require 'shopsense/api'

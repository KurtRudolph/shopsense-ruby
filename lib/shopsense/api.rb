module Shopsense

  class API < Client

    # Searches the shopsense API
    # @param [String] search_string
    #   The string to be in the query.
    # @param  [Integer] index
    #   The start index of results returned.
    # @param  [Integer] num_results
    #   The number of results to be returned.
    # @return  A list of Product objects. Each Product has an id, name, 
    #   description, price, retailer, brand name, categories, images in small/medium/large, 
    #   and a URL that forwards to the retailer's site.
    def search( search_string = nil, index = 0, num_results = 10)
      raise "no search string provieded!" if( search_string === nil)

      fts   = "fts="    + search_string.split().join( '+').to_s
      min   = "min="    + index.to_s
      count = "count="  + num_results.to_s
      args  = [fts, min, count].join( '&')

      return call_api( __method__, args)
    end


    # This method returns a list of categories and product counts that describe the results 
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Category objects. Each Category has an id, name, and count 
    #   of the number of query results in that category.
    def get_category_histogram( search_string = nil)
      raise "no search string provieded!" if( search_string === nil)

      fts = "fts=" + search_string.split().join( '+').to_s

      return call_api( __method__, fts)
    end

    # This method returns a list of categories and product counts that describe the results 
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  filter_type
    #   The type of filter data to return. Possible values are 
    #   Brand, Retailer, Price, Discount, Size and Color.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Category objects. Each Category has an id, name, and count 
    #   of the number of query results in that category.
    def get_filter_histogram( filter_type = nil, search_string = nil)
      raise "no search string provieded!" if( search_string === nil)
      raise "invalid filter type" if( !self.filter_types.include?( filter_type))

      filterType = "filterType=" + filter_type.to_s
      fts = "fts=" + search_string.split().join( '+').to_s
      args  = [filterType, fts].join( '&')

      return call_api( __method__, args)
    end

    # This method returns a list of brands that have live products. Brands that have 
    # very few products will be omitted.
    # @return [String] A list of all Brands, with id, name, url, and synonyms of each.
    def get_brands
      return call_api( __method__)
    end

    # This method returns information about a particular look and its products.
    # @param [Integer] look_id 
    #   The ID number of the look. An easy way to get a look's ID is 
    #   to go to the Stylebook page that contains the look at the ShopStyle website and 
    #   right-click on the button that you use to edit the look. From the popup menu, select 
    #   "Copy Link" and paste that into any text editor. The "lookId" query parameter of that 
    #   URL is the value to use for this API method.
    # @return [String]  single look, with title, description, a set of tags, and a list of products. 
    #   The products have the fields listed (see #search)
    def get_look( look_id = nil)
      raise "no look_id provieded!" if( look_id === nil)

      look = "look=" + look_id.to_s

      return call_api( __method__, look)
    end

    # This method returns a list of retailers that have live products.
    # @return [Sting] A list of all Retailers, with id, name, and url of each.
    def get_retailers
      return call_api( __method__)
    end

    # This method returns information about a particular user's Stylebook, the 
    # looks within that Stylebook, and the title and description associated with each look.
    # @param [String] username
    #   The username of the Stylebook owner.
    # @param  [Integer] index
    #   The start index of results returned.
    # @param  [Integer] num_results
    #   The number of results to be returned.
    # @return [String] 
    #   A look id of the user's Stylebook, the look id of each individual look within that Stylebook, 
    #   and the title and description associated with each look.
    def get_stylebook(  user_name = nil, index = 0, num_results = 10)
      raise "no user_name provieded!" if( user_name === nil)
      
      handle  = "handle=" + user_name.to_s
      min     = "min="    + index.to_s
      count   = "count="  + num_results.to_s
      args    = [handle, min, count].join( '&')

      return call_api( __method__, args)
    end

    # This method returns information about looks that match different kinds of searches.
    # @param [Integer] look_type
    #   The type of search to perform. Supported values are:
    #   New - Recently created looks.
    #   TopRated - Recently created looks that are highly rated.
    #   Celebrities - Looks owned by celebrity users.
    #   Featured - Looks from featured stylebooks.
    # @param [String] username
    #   The username of the Stylebook owner.
    # @param  [Integer] index
    #   The start index of results returned.
    # @param  [Integer] num_results
    #   The number of results to be returned.
    # @return [String] 
    #   A list of looks of the given type.
    def get_looks( look_type = nil, index = 0, num_results = 10)
      raise "invalid filter type must be one of the following: #{self.look_types}" if( !self.look_types.include?( look_type))

      type    = "type="   + look_type.to_s
      min     = "min="    + index.to_s
      count   = "count="  + num_results.to_s
      args    = [type, min, count].join( '&')

      return call_api( __method__, args)
    end

    # TODO:
    # This method does not return a reponse of XML or JSON data like the other elements of the API. 
    # Instead, it forwards the user to the retailer's product page for a given product. It is the 
    # typical behavior to offer when the user clicks on a product. The apiSearch method returns URLs 
    # that call this method for each of the products it returns.
    # @param [Integer]
    #   The ID number of the product. An easy way to get a product's ID is to find the product somewhere 
    #   in the ShopStyle UI and right-click on the product image. From the popup menu, select "Copy Link" 
    #   ("Copy link location" or "Copy shortcut" depending on your browser) and paste that into any text 
    #   editor. The "id" query parameter of that URL is the value to use for this API method.
    # @return [String]
    #   A web link to the retailer. $1 of the $0
    def visit_retailer( id)

    end

    # This method returns the popular brands for a given category along with a sample product for the 
    # brand-category combination.
    # @param [String] category 
    #   Category you want to restrict the popularity search for. This is an optional 
    #   parameter. If category is not supplied, all the popular brands regardless of category will be returned.
    # @return [String] A list of trends in the given category. Each trend has a brand, category, url, and 
    #   optionally the top-ranked product for each brand/category.
    def get_trends( category = "", products = 0)
      cat = "cat=" + category.to_s
      products = "products=" + products.to_s
      args    = [cat, products].join( '&')

      return call_api( __method__, args)
    end
    private

      # This method is used for making the http calls building off the DSL of this module.
      # @param [String] method
      #   The method which is to be used in the call to Shopsense
      # @param [String] args
      #   A concatenated group of arguments seperated by a an & symbol and spces substitued with a + symbol.
      # @return [String] A list of the data returned
      def call_api( method, args = nil)
        method_url  = self.api_url  + self.send( "#{method}_path")
        pid         = "pid="        + self.partner_id
        format      = "format="     + self.format
        site        = "site="       + self.site

        if( args === nil) then
          uri   = URI.parse( method_url.to_s + [pid, format, site].join('&').to_s) 
        else
          uri   = URI.parse( method_url.to_s + [pid, format, site, args].join('&').to_s) 
        end

        return Net::HTTP.get( uri)
      end
  end
end

    # @macro [new] api.index
    #   @param [Integer] index
    #     The start index of results returned.
    # @macro [new] api.num_results
    #   @param [Integer] num_results
    #     The number of results to be returned.
    # @macro [new] api.search_string
    #   @param [String] search_string
    #     The string to be in the query.

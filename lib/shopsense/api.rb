module Shopsense

  API_ENDPOINT = 'http://api.shopstyle.com/api/v2'
  FILTER_TYPES = ['Brands', 'Retailer', 'Price', 'Discount', 'Size', 'Color'].freeze
  LOOK_TYPES = ['New', 'TopRated', 'Celebrities', 'Featured'].freeze

  class API

    attr_reader :configuration

    def initialize(args = {})
      @partner_id = args['partner_id']
      @unserialize = args['unserialize']
      @site = args['site'] || 'www.shopstyle.com'
    end

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
    def search(search_string, opts = {})
      opts = {:offset => 0, :limit => 10}.merge(opts)
      raise "no search string provided!" if search_string.nil?
      args = {
        :fts => search_string,
        :offset => opts[:offset],
        :limit => opts[:limit]
      }
      call_api('/products', args)
    end

    # This method returns a list of categories and product counts that describe the results
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Category objects. Each Category has an id, name, and count
    #   of the number of query results in that category.
    def category_histogram(search_string)
      raise "no search string provided!" if search_string.nil?
      args = {
        :fts => search_string,
        :filters => 'Category'
      }
      call_api('/histogram', args)
    end

    # This method returns a list of categories and product counts that describe the results
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  filter_type
    #   The type of filter data to return. Possible values are
    #   Brand, Retailer, Price, Discount, Size and Color.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Category objects. Each Category has an id, name, and count
    #   of the number of query results in that category.
    def filter_histogram(filter_type, search_string)
      raise "invalid filter type" unless FILTER_TYPES.include?(filter_type)
      raise "no search string provided!" if search_string.nil?
      args = {
        :fts => search_string,
        :filters => filter_type
      }
      call_api('/histogram', args)
    end

    # This method returns a list of brands that have live products. Brands that have
    # very few products will be omitted.
    # @return [String] A list of all Brands, with id, name, url, and synonyms of each.
    def brands
      call_api('/brands')
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
    def look(look_id)
      raise "TODO"
    end

    # This method returns a list of retailers that have live products.
    # @return [Sting] A list of all Retailers, with id, name, and url of each.
    def retailers
      call_api('/retailers')
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
    def stylebook(user_name, opts = {})
      raise "TODO"
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
    def looks(look_type, opts = {})
      raise "TODO"
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
    def visit_retailer(id)
      raise "TODO"
    end

    # This method returns the popular brands for a given category along with a sample product for the
    # brand-category combination.
    # @param [String] category
    #   Category you want to restrict the popularity search for. This is an optional
    #   parameter. If category is not supplied, all the popular brands regardless of category will be returned.
    # @return [String] A list of trends in the given category. Each trend has a brand, category, url, and
    #   optionally the top-ranked product for each brand/category.
    def trends(category = "", products = 0)
      args = {
        :cat => category,
        :products => products
      }
      call_api('/trends', args)
    end

    # Deprecated - Kept here for BC
    alias_method :get_category_histogram, :category_histogram
    alias_method :get_filter_histogram, :filter_histogram
    alias_method :get_brands, :brands
    alias_method :get_look, :look
    alias_method :get_retailers, :retailers
    alias_method :get_stylebook, :stylebook
    alias_method :get_looks, :looks
    alias_method :get_trends, :trends

    private

      # This method is used for making the http calls building off the DSL of this module.
      # @param [String] method
      #   The method which is to be used in the call to Shopsense
      # @param [String] args
      #   A concatenated group of arguments seperated by a an & symbol and spces substitued with a + symbol.
      # @return [String] A list of the data returned
      def call_api(relative_url, args = {})
        base_url = API_ENDPOINT + relative_url
        args[:pid] = @partner_id
        args[:format] = 'json'
        args[:site] = @site
        if base_url.include?("?")
          base_url.chomp!("&")
          base_url << "&"
        else
          base_url << "?"
        end
        base_url << args.map {|(k,v)| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join("&")
        uri = URI.parse(base_url)
        data = Net::HTTP.get(uri)
        if @unserialize
          require 'multi_json'
          MultiJson.load(data, :symbolize_keys => true)
        else
          data
        end
      end
  end
end

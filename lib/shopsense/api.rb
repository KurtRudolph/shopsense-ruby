module Shopsense

  API_ENDPOINTS = {1 => 'http://api.shopstyle.com/action', 2 => 'http://api.shopstyle.com/api/v2'}
  FILTER_TYPES = ['Category', 'Brand', 'Retailer', 'Price', 'Discount', 'Size', 'Color'].freeze
  LOOK_TYPES = ['New', 'TopRated', 'Celebrities', 'Featured'].freeze

  class API

    def initialize(args = {})
      @partner_id = args['partner_id']
      @unserialize = args['unserialize'].nil? ? true : args['unserialize']
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
    def products(opts = {})
      raise "Interface changed. Use as :query => 'search'" if opts.kind_of? String
      call_api('/products', build_product_query(opts))
    end

    def product_by_id(product_id)
      call_api('/products/' + CGI::escape(product_id.to_s))
    end

    # This method returns a list of categories and product counts that describe the results
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Category objects. Each Category has an id, name, and count
    #   of the number of query results in that category.
    def category_histogram(opts)
      filter_histogram('Category', opts)
    end

    # This method returns a list of categories and product counts that describe the results
    # of a given product query. The query is specified using the product query parameters.
    # @param  [String]  filter_type
    #   The type of filter data to return. Possible values are
    #   Brand, Retailer, Price, Discount, Size and Color.
    # @param  [String]  search_string The string to be in the query.
    # @return [String]  A list of Filter objects of the given type. Each Filter has an id,
    #                   name, and count of the number of results that apply to that filter.
    def filter_histogram(filter_type, opts = {})
      raise "Interface changed. Use as :query => 'search'" if opts.kind_of? String
      filter_types = [*filter_type]
      filter_types.each do |f|
        raise "invalid filter type" unless FILTER_TYPES.include?(f)
      end
      args = build_product_query(opts)
      args[:filters] = filter_types.join(",")
      args[:floor] = opts[:floor]
      call_api('/products/histogram', args)
    end

    # This method returns a list of the categories available to the API.
    # @return A list of all categories, with id, name, and parent id.
    def categories
      call_api('/categories')
    end

    # This method returns the list of canonical colors available.
    # @return A list of all Colors, with id, name, and url of each.
    def colors
      call_api('/colors')
    end

    # This method returns a list of brands that have live products. Brands that have
    # very few products will be omitted.
    # @return A list of all Brands, with id, name, url, and synonyms of each.
    def brands
      call_api('/brands')
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
    def stylebook(opts = {})
      opts = {:offset => 0, :limit => 10}.merge(opts)
      args = {
        :handle => opts[:username],
        :min => opts[:offset],
        :count => opts[:limit],
      }
      call_api('/apiGetStylebook', args, 1)
    end

    # @deprecated
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
      call_api('/apiGetLook', {:look => look_id}, 1)
    end

    # @deprecated
    # This method returns information about looks that match different kinds of searches.
    # @param [Integer] look_type
    #   The type of search to perform. Supported values are:
    #   New - Recently created looks.
    #   TopRated - Recently created looks that are highly rated.
    #   Celebrities - Looks owned by celebrity users.
    #   Featured - Looks from featured stylebooks.
    # @param  [Integer] index
    #   The start index of results returned.
    # @param  [Integer] num_results
    #   The number of results to be returned.
    # @return [String]
    #   A list of looks of the given type.
    def looks(look_type, opts = {})
      opts = {:offset => 0, :limit => 10}.merge(opts)
      args = {
        :type => look_type,
        :min => opts[:offset],
        :count => opts[:limit],
      }
      call_api('/apiGetLooks', args, 1)
    end

    # @deprecated
    # This method provides a link that will redirect to the retailer product page.
    # You probably won't need this as the link is also included with the product structs.
    #
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
    def visit_retailer_href(product_id)
      API_ENDPOINTS[1] + "/apiVisitRetailer?pid=#{CGI::escape(@partner_id.to_s)}&id=#{CGI::escape(product_id.to_s)}"
    end

    # @deprecated
    # This method returns the popular brands for a given category along with a sample product for the
    # brand-category combination.
    # @param [String] category
    #   Category you want to restrict the popularity search for. This is an optional
    #   parameter. If category is not supplied, all the popular brands regardless of category will be returned.
    # @return [String] A list of trends in the given category. Each trend has a brand, category, url, and
    #   optionally the top-ranked product for each brand/category.
    def trends(opts = {})
      opts = {:include_products => true}.merge(opts)
      args = {
        :cat => opts[:category],
        :products => opts[:include_products] ? nil : "0"
      }
      call_api('/apiGetTrends', args, 1)
    end

    private

      def build_product_query(opts = {})
        opts = {:offset => 0, :limit => 10}.merge(opts)
        args = {
          :fts => opts[:query],
          :offset => opts[:offset],
          :limit => opts[:limit],
          :cat => opts[:category_id]
        }
        filters = []
        {:brand_id => "b", :retailer_id => "r", :price => "p", :sale => "d", :size => "s", :color => "c"}.each do |key,prefix|
          if opts[key]
            [*opts[key]].each do |value|
              filters << "#{prefix}#{value}"
            end
          end
        end
        if filters.any?
          args[:fl] = filters
        end
        if opts[:price_dropped_since]
          d = opts[:price_dropped_since]
          args[:pdd] = d.kind_of?(DateTime) ? d.to_time.to_i : d.to_i
        end
        args[:sort] = case opts[:sort_by]
                      when :price_lo_hi
                        'PriceLoHi'
                      when :price_hi_lo
                        'PriceHiLo'
                      when :recency
                        'Recency'
                      when :popular
                        'Popular'
                      end
        args
      end

      # This method is used for making the http calls building off the DSL of this module.
      # @param [String] method
      #   The method which is to be used in the call to Shopsense
      # @param [String] args
      #   A concatenated group of arguments seperated by a an & symbol and spces substitued with a + symbol.
      # @return [String] A list of the data returned
      def call_api(relative_url, args = {}, api_version = 2)
        args[:pid] = @partner_id
        args[:format] = 'json'
        args[:site] = @site
        compiled_args = args.delete_if {|k,v| v.nil? }.map {|(k,v)|
          if v.kind_of? Array
            v.map {|vv| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join("&")
          else
            "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"
          end
        }.join("&")
        href = API_ENDPOINTS[api_version] + relative_url + "?" + compiled_args
        uri = URI.parse(href)
        response = Net::HTTP.get_response(uri)
        data = response.body
        if response.code.to_i > 299 || response.code.to_i < 200
          raise data
        end
        if @unserialize
          require 'multi_json'
          MultiJson.load(data, :symbolize_keys => true)
        else
          data
        end
      end
  end
end

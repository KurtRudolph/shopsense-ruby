module Shopsense
  class Client
    def initialize( args = { })
      raise "No partner_id" if( !args.has_key?( 'partner_id'))

      attr_accessors = {
                #:
                'format'  => 'json', 
                'site'    => 'us'}
      attr_accessors.each_key{ |key| (class << self; self; end).send( :attr_accessor, key.to_sym)}

      attr_readers = {
                'partner_id'                  => nil, 
                'api_url'                     => 'http://api.shopstyle.com',
                'search_path'                 => '/action/apiSearch?',
                'get_brands_path'             => '/action/apiGetBrands?',
                'get_look_path'               => '/action/apiGetLook?',
                'get_looks_path'              => '/action/apiGetLooks?',
                'get_retailers_path'          => '/action/apiGetRetailers?',
                'get_stylebook_path'          => '/action/apiGetStylebook?',
                'visit_retailers_path'        => '/action/apiVisitRetailer?',
                'get_trends_path'             => '/action/apiGetTrends?',
                'get_category_histogram_path' => '/action/apiGetCategoryHistogram?',
                'get_filter_histogram_path'   => '/action/apiGetFilterHistogram?',
                'filter_types'                => ['Brands', 'Retailer', 'Price', 'Discount', 'Size', 'Color'],
                'look_types'                  => ['New', 'TopRated', 'Celebrities', 'Featured'],
                'formats'                     => ['xml', 'json', 'json2', 'jsonvar', 'jsonvar2', 'jsonp', 'rss'],
                'sites'                       => ['www.shopstyle.com', 'www.shopstyle.co.uk']}
      attr_readers.each_key{ |key| (class << self; self; end).send( :attr_reader, key.to_sym)}

      attr_writers = {}
      attr_writers.each_key{ |key| (class << self; self; end).send( :attr_writer, key.to_sym)}

      attrs = attr_accessors.merge( attr_readers).merge( attr_writers)
      attrs.each_key do |key| 
        attrs[ key] = args[ key] if( args.has_key?( key))
      end

      attrs.each {|key, value| instance_variable_set( "@#{key}", value)}
    end
  end

end

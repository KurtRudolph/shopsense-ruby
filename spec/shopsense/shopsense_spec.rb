require './spec/spec_helper'
require 'yaml'

describe Shopsense do
  let(:test_input) { YAML.load_file('test/shopsense_test_config.yml') }
  let(:partner_id) {
    test_input['partner_id']
  }

  describe Shopsense::API do
    let(:api) { Shopsense::API.new(test_input) }
    describe "search" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        min = 10
        count = 20
        api.search(fts, :offset => min, :limit => count).should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/products?pid=#{partner_id}&format=json&site=us&fts=#{fts}&offset=#{min}&limit=#{count}"))
      end
    end
    describe "get_category_histogram" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        api.category_histogram(fts).should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/histogram?pid=#{partner_id}&format=json&site=us&filters=Category&fts=#{fts}"))
      end
    end
    describe "get_filter_histogram" do
      it "it passes if the proper data is returned" do
        filter_type = 'Brands'
        fts = 'something'
        api.filter_histogram(filter_type, fts).should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/histogram?pid=#{partner_id}&format=json&site=us&filterType=#{filter_type}&fts=#{fts}"))
      end
    end
    describe "get_brands" do
      it "it passes if the proper data is returned" do
        api.brands.should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/brands?pid=#{partner_id}&format=json&site=us"))
      end
    end
    # describe "get_look" do
    #   it "it passes if the proper data is returned" do
    #     look_id = 548347
    #     api.look( look_id).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_look_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&look=#{look_id}"))
    #   end
    # end
    describe "get_retailers" do
      it "it passes if the proper data is returned" do
        api.retailers.should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/retailers?pid=#{partner_id}&format=json&site=us"))
      end
    end
    # describe "get_stylebook" do
    #   it "it passes if the proper data is returned" do
    #     handle = 'KalvinTestone'
    #     min = 0
    #     count = 10
    #     api.stylebook(handle, :offset => min, :limit => count).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_stylebook_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&handle=#{handle}&min=#{min}&count=#{count}"))
    #   end
    # end
=begin
    describe "get_looks" do
      it "it passes if the proper data is returned" do
        look_type = 'New'
        min = 0
        count = 10
        api.looks(look_type, :offset => min, :limit => count).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_looks_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&type=#{look_type}&min=#{min}&count=#{count}"))
      end
    end
=end
    describe "get_trends" do
      it "it passes if the proper data is returned" do
        category = 0
        products = 0
        api.trends(category, products).should == Net::HTTP.get(URI.parse("http://api.shopstyle.com/api/v2/trends?pid=#{partner_id}&format=json&site=us&cat=#{category}&products=#{products}"))
      end
    end

    describe "With native unserialization" do
      let(:api) { Shopsense::API.new(test_input.merge("unserialize" => true)) }
      describe "search" do
        it "it passes if the proper data is returned" do
          fts = 'something'
          min = 10
          count = 20
          api.search(fts, :offset => min, :limit => count).should have_key(:metadata)
        end
      end
    end
  end
end

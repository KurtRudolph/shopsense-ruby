require './spec/spec_helper'
require 'json'

def rubify_string some_string
  return some_string.gsub(/[A-Z]+/){ |s| '_' + s.downcase}
end

describe Shopsense do
  let( :test_input) {YAML.load_file( 'test/shopsense_test_config.yml')}
  describe Shopsense::Client do
    let( :client) {Shopsense::Client.new( test_input)}
    describe "initialization of 'Client' object" do
      it "passes if 'partner_id' is defined properly" do
        client.partner_id.should == test_input['partner_id']
      end
      it "passes if 'format' is defined properly" do
        client.format.should == test_input['format']
      end
      it "passes with a valid 'site'" do
        client.site.should == test_input['site']
      end
      it "passes if 'format' is able to be updated" do
        new_format = 'xml'
        client.format = new_format
        client.format.should == new_format
      end
    end
  end


  describe Shopsense::API do
    let( :api) {Shopsense::API.new( test_input)}
    describe "search" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        min = 10
        count = 20
        api.search( fts, min, count).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.search_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&fts=#{fts}&offset=#{min}&limit=#{count}"))
      end
    end
    describe "get_category_histogram" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        api.get_category_histogram( fts).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_category_histogram_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&fts=#{fts}"))
      end
    end
    describe "get_filter_histogram" do
      it "it passes if the proper data is returned" do
        filter_type = 'Brands'
        fts = 'something'
        api.get_filter_histogram( filter_type, fts).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_filter_histogram_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&filterType=#{filter_type}&fts=#{fts}"))
      end
    end
    describe "get_brands" do
      it "it passes if the proper data is returned" do
        api.get_brands.should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_brands_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}"))
      end
    end
    # describe "get_look" do
    #   it "it passes if the proper data is returned" do
    #     look_id = 548347
    #     api.get_look( look_id).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_look_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&look=#{look_id}"))
    #   end
    # end
    describe "get_retailers" do
      it "it passes if the proper data is returned" do
        api.get_retailers.should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_retailers_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}"))
      end
    end
    # describe "get_stylebook" do
    #   it "it passes if the proper data is returned" do
    #     handle = 'KalvinTestone'
    #     min = 0
    #     count = 10
    #     api.get_stylebook( handle, min, count).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_stylebook_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&handle=#{handle}&min=#{min}&count=#{count}"))
    #   end
    # end
    # describe "get_looks" do
    #   it "it passes if the proper data is returned" do
    #     look_type = 'New'
    #     min = 0
    #     count = 10
    #     api.get_looks( look_type, min, count).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_looks_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&type=#{look_type}&min=#{min}&count=#{count}"))
    #   end
    # end
    describe "get_trends" do
      it "it passes if the proper data is returned" do
        category = 0
        products = 0
        api.get_trends( category, products).should == Net::HTTP.get( URI.parse( "#{api.api_url}#{api.get_trends_path}?pid=#{api.partner_id}&format=#{api.format}&site=#{api.site}&cat=#{category}&products=#{products}"))
      end
    end
  end
end

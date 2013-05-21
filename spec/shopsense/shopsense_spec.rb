require './spec/spec_helper'

describe Shopsense do
  let(:test_input) { YAML.load_file('test/shopsense_test_config.yml') }
  describe Shopsense::Configuration do
    let(:configuration) { Shopsense::Configuration.new(test_input) }
    describe "initialization of 'Configuration' object" do
      it "passes if 'partner_id' is defined properly" do
        configuration.partner_id.should == test_input['partner_id']
      end
      it "passes if 'format' is defined properly" do
        configuration.format.should == test_input['format']
      end
      it "passes with a valid 'site'" do
        configuration.site.should == test_input['site']
      end
      it "passes if 'format' is able to be updated" do
        new_format = 'xml'
        configuration.format = new_format
        configuration.format.should == new_format
      end
    end
  end

  describe Shopsense::API do
    let(:api) { Shopsense::API.new(test_input) }
    let(:configuration) { api.configuration }
    describe "search" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        min = 10
        count = 20
        api.search(fts, :offset => min, :limit => count).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.search_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&fts=#{fts}&offset=#{min}&limit=#{count}"))
      end
    end
    describe "get_category_histogram" do
      it "it passes if the proper data is returned" do
        fts = 'something'
        api.category_histogram(fts).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_category_histogram_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&fts=#{fts}"))
      end
    end
    describe "get_filter_histogram" do
      it "it passes if the proper data is returned" do
        filter_type = 'Brands'
        fts = 'something'
        api.filter_histogram(filter_type, fts).should == Net::HTTP.get(URI.parse( "#{configuration.api_url}#{configuration.get_filter_histogram_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&filterType=#{filter_type}&fts=#{fts}"))
      end
    end
    describe "get_brands" do
      it "it passes if the proper data is returned" do
        api.brands.should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_brands_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}"))
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
        api.retailers.should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_retailers_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}"))
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
        api.trends(category, products).should == Net::HTTP.get(URI.parse("#{configuration.api_url}#{configuration.get_trends_path}?pid=#{configuration.partner_id}&format=#{configuration.format}&site=#{configuration.site}&cat=#{category}&products=#{products}"))
      end
    end

    describe "With native unserialization" do
      let(:api) { Shopsense::API.new(test_input.merge("unserialize" => true)) }
      let(:configuration) { api.configuration }
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

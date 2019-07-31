require 'base64'
class Client

  attr_accessor :client
  attr_accessor :base_uri
  attr_accessor :authenticate_using_basic
  attr_accessor :basic_authentication
  attr_accessor :use_content_type_json
  def initialize(uri = "")
    @base_uri = uri
    @client = HTTPClient.new
  end

  ################# GET
  # Method to initiate GET Request
  #
  # ==== Attributes
  # * +uri+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
  # * +header+ - header is a hash value eg: {'Content-Type' => 'application/json'}
  def get(uri = '/', query = {}, header = {})
    uri = @base_uri.chomp('/') + uri
    header = setup_header(header)
    @client.request('GET', uri, query, nil, header)
  end

  ################# POST
  # Method to initiate POST Request
  #
  # ==== Attributes
  # * +uri+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +body+ - body is a hash value or string or json value eg: {'ststus' : 1}
  # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
  # * +header+ - header is a hash value eg: {'Content-Type' => 'application/json'}
  def post(uri = '/', body = {}, header = {}, query = {})
    uri = @base_uri.chomp('/') + uri
    header = setup_header(header)
    @client.request('POST', uri, query, body, header)
  end

  ################# PATCH
  # Method to initiate PATCH Request
  #
  # ==== Attributes
  # * +uri+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +body+ - body is a hash value or string or json value eg: {'ststus' : 1}
  # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
  # * +header+ - header is a hash value eg: {'Content-Type' => 'application/json'}
  def patch(uri = '/', body = {}, header = {}, query = {})
    uri = @base_uri.chomp('/') + uri
    header = setup_header(header)
    @client.request('PATCH', uri, query, body, header)
  end

  ################# PUT
  # Method to initiate PUT Request
  #
  # ==== Attributes
  # * +uri+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +body+ - body is a hash value or string or json value eg: {'ststus' : 1}
  # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
  # * +header+ - header is a hash value eg: {'Content-Type' => 'application/json'}
  def put(uri = '/', body = {}, header = {}, query = {})
    uri = @base_uri.chomp('/') + uri
    header = setup_header(header)
    @client.request('PUT', uri, query, body, header)
  end


  ################# DELETE
  # Method to initiate PUT Request
  #
  # ==== Attributes
  # * +uri+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +body+ - body is a hash value or string or json value eg: {'ststus' : 1}
  # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
  # * +header+ - header is a hash value eg: {'Content-Type' => 'application/json'}
  def delete(uri = '/', body = {}, header = {}, query = {})
    uri = @base_uri.chomp('/') + uri
    header = setup_header(header)
    @client.request('DELETE', uri, query, body, header)
  end

  ################# Basic Authentication
  # Set base authenticate value as binding user & password encoded in base64 format
  #
  # ==== Attributes
  # * +username+ - Endpoint url or Endpoint along with base url if base_uri is nil
  # * +password+ - body is a hash value or string or json value eg: {'ststus' : 1}
  def set_basic_auth(username, password)
    @authenticate_using_basic = true
    @basic_authentication = "Basic #{Base64.strict_encode64(username + ':' + password)}".strip
  end

  ################# Configuration
  # set the basic authentication value & content type in hash value and returns it
  #
  # ==== Attributes
  # * +header+ - header is hash value. it may contain value like {'api-version'=> '1'}
  def setup_header(header)
    header["Authorization"]   = @basic_authentication if @authenticate_using_basic && !@basic_authentication.nil?
    header["Content-Type"]    = "application/json" if @use_content_type_jsons
    header
  end

  ################# status code validator
  # method validates response code and expected code. if the validation failes then raises exeception.
  #
  # ==== Attributes
  # * +res+ - res is interger value.
  # * +status_code+ - res is interger value.
  def status_validator(res,status_code)
    raise "status code validation failure Expected: #{status_code} But Actually got #{res.status_code}" if status_code!=res.status_code
  end
end

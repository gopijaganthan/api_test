module Api
  class Lendico

    attr_accessor :client

    ################# constructor function of the class
    #  contruction function will set a API::Client object for initiating request
    #
    # ==== Attributes
    # * +client+ - Object of API::Client
    def initialize(client)
      @client = client
    end

    ################# Autocomplete Api
    # Method to initiate Post Request to Calculate Annuity
    #
    # ==== Attributes
    # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
    # * +status_code+ - status_code is a integer value. it is the expected status code
    def calc_annuity(query= {},status_code=200)
      res = @client.post($ENDPOINTS['Api']['calc_annuity'],query.to_json)
      @client.status_validator(res,status_code)
      JSON.parse(res.body)
    end

    ################# Normalize Api
    # Method to initiate Post Request to Generate plan
    #
    # ==== Attributes
    # * +query+ - query is a hash value eg: {'page' => 1} => ?page=1
    # * +status_code+ - status_code is a integer value. it is the expected status code
    def generate_plan(query= {},status_code=200)
      res = @client.post($ENDPOINTS['Api']['generate_plan'],query.to_json)
      @client.status_validator(res,status_code)
      JSON.parse(res.body)
    end
  end
end

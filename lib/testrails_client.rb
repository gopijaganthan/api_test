class TestRailsclient

  ################# constructor function of the class
  #  contruction function will get the details of run_id & Testrails Api credentials
  #
  # ==== Attributes
  # * +input+ - res is hash value. eg: {"url"=>"https://skillstest.testrail.io/index.php?/api/v2/", "username"=>"archanasivalingam@gmail.com", "password"=>"WRi7NAQPV9B5V/eTW2Hg", "run_id"=>1}
  def initialize(input)
    @client = Client.new(input['url'])
    @client.set_basic_auth(input['username'],input['password'])
    @client.setup_header({})
    @client.use_content_type_json = true
    @run_id = input['run_id']
  end

  ################# constructor function of the class
  #  Updates the status of testcase in a testrun based on caseid
  #
  # ==== Attributes
  # * +data+ - data is hash value. eg: {'status_id' => 1,'comment' => 'Passed'}
  # * +case_id+ - case_id is interger value.
  def set_statuses(case_id,data)
    @client.post("/add_result_for_case/#{@run_id}/#{case_id}",data.to_json,{"Content-Type" => 'application/json'})
  end
end

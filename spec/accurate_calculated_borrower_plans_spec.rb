require 'spec_helper.rb'
RSpec.describe "Api - Acceptance Criteria" do
  before(:all) do
    @httpclient = Client.new($ENDPOINTS['Api']['endpoint'])
    @calc = Api::Lendico.new(@httpclient)
    @calculate = Utility::Calculate.new
    @utils = Utility::Common.new
  end

  it "1) The calculated borrower schedule must comply with the duration in months that was given as input",:test_id => '1' do
    query = {
      "loanAmount": "5000",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    expect(generated_plan.count).to eq(query[:duration])
  end

  it "2) The total payment amount per month in a borrower schedule should equal the value from the annuity call",:test_id => '2' do
    query = {
      "loanAmount": "5000",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    calculated_annuity = @calc.calc_annuity(query)
    borrower_schedule_not_matches_with_annuity = generated_plan[0..-2].select{|each_month| each_month["borrowerPaymentAmount"]!=calculated_annuity["annuity"]}
    expect(borrower_schedule_not_matches_with_annuity).to be_empty
    expect(generated_plan.last["borrowerPaymentAmount"].to_i).to be > 0
  end

  it "3,4) The start date determines the first due date of the calculated schedule. We assume that each schedule entry is always due on the same day (i.e. start date 25.01.18 --> first due date 25.02.18). If the day of the start date does not exist in one of the following months, for that installment (schedule entry) the due date must use the next available calendar day. This must not influence any follow-up schedule entry",:test_id => ['3','4'] do
    query = {
      "loanAmount": "5000",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    expect(generated_plan.map{|x| x["date"].split("T").first}).to eq @utils.determine_due_dates(query[:startDate],query[:duration]-1)
  end

  it "5) The interest calculation complies with a simplified version of a 30/360 day count convention. (Every full month is counted as 30 days)",:test_id => '5' do
    query = {
      "loanAmount": "5000",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    generated_plan.each do |per_month|
      expect(@calculate.interest(per_month[:loanAmount].to_i,per_month[:nominalRate].to_i)).to eq (per_month[:interest].to_i)
    end
  end

  it "6, 7) If there are installments which do not cover a full month, every day has to be taken into account for interest calculation",:test_id => ['6','7'] do |e|
    e.step "The calculated interest per schedule entry is based on the initial outstanding principal of that entry and the duration (in days) between this entry and the last one (or start date)." do
      query = {
        "loanAmount": "5",
        "nominalRate": "5.0",
        "duration": 24,
        "startDate": "2018-01-29"
      }
      generated_plan = @calc.generate_plan(query)
      previous_month = generated_plan.first
      generated_plan[1..generated_plan.length] do |current_month|
        #Find the number of days between previous month and current month to calucuate intereset, find minimum number of days in case of last month
        calculate_interest_for_days = [Date.parse(current_month["date"]).mjd - Date.parse(previous_month["date"]).mjd, 30].min
        expect(@calculate.interest(current_month[:loanAmount].to_i,current_month[:nominalRate].to_i,calculate_interest_for_days)).to eq (current_month[:interest].to_i)
        previous_month = current_month
      end
    end
  end

  it "8) The remaining outstanding principal of one entry equals the initial outstanding principal of the following month",:test_id => '8' do
    query = {
      "loanAmount": "5",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    current_month = generated_plan.first
    generated_plan[1..-1] do |next_month|
      expect(current_month[:remainingOutstandingPrincipal]).to eq (next_month[:initialOutstandingPrincipal])
      current_month = next_month
    end
  end

  it "9) The remaining outstanding principal of the last schedule entry equals always 0.00 €",:test_id => '9' do
    query = {
      "loanAmount": "5",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    expect(generated_plan.last["remainingOutstandingPrincipal"].to_i).to be 0
  end

  it "10) The sum of all principal amounts in the schedule entries equals the total loan amount",:test_id => '10' do
    query = {
      "loanAmount": "5",
      "nominalRate": "5.0",
      "duration": 24,
      "startDate": "2018-01-29"
    }
    generated_plan = @calc.generate_plan(query)
    expect(generated_plan.sum{|each_schedule| each_schedule["principal"].to_f}).to eq(query[:loanAmount].to_f)
  end
end

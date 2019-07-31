module Utility
  class Calculate
    def initilize
      @days_in_year = 360
      @days_in_month = 30
    end

    ################# interest
    # Method calclate interest fo month
    #
    # ==== Attributes
    # * +loan_amount+ - Principle
    # * +nominal_rate+ - nominal_rate for the loan amount
    # * +days_in_month+ - number of days in a month
    # * +days_in_year+ - number of days in a year
    def interest(loan_amount, nominal_rate, days_in_month = 30 , days_in_year = 360)
      interest_in_cents = ((loan_amount * nominal_rate * days_in_month) / days_in_year)# To convert cents to euro by dividing it by 100 and round off decimal by 2
      interest_in_euro = (interest_in_cents.to_f/100).round(2)
    end

    ################# annuity
    # Method to calculate annuity per month
    #
    # ==== Attributes
    # * +input+ - input is a hash value eg: {"loanAmount": "5000","nominalRate": "5.0","duration": 24, "annuity": "219.36"}
    def annuity_per_month(input)
      calculated_value = {}
      calculated_value["interest"] = calculate_interest(input[:loanAmount],input[:nominalRate])
      # To find absolute difference of both which ever is maxium
      calculated_value["principal"] = (input["annuity"] - calculated_value["interest"]).round(2)
      calculated_value["borrower_payment_amount"] = calculated_value["principal"] + calculated_value["interest"]
      calculated_value
    end

    ################# annuity
    # Method calclate annuity for stipulated duration
    #
    # ==== Attributes
    # * +input+ - input is a hash value eg: {"loanAmount": "5000","nominalRate": "5.0","duration": 24, "annuity": "219.36"}
    def annuity(input)
      input[:loanAmount] = input[:loanAmount].to_i if input[:loanAmount].is_a? String
      input[:nominalRate] = input[:nominalRate].to_i if input[:nominalRate].is_a? String
      input[:annuity] = input[:annuity].to_i if input[:annuity].is_a? String
      calc_annuity_per_month(input)
    end
  end
end

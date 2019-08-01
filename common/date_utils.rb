module Utility
  class Date_Utils

    COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    ################# days_in_month
    #To calcualte number of days for a given month
    #
    # ==== Attributes
    # * +date+ - date formater, which has month day and yeat
    def days_in_month(date)
      return 29 if date.month == 2 && Date.gregorian_leap?(date.year)
      COMMON_YEAR_DAYS_IN_MONTH[date.month]
    end


    ################# determine_due_dates
    #Start date determines the first due date of the calculated schedule
    #If the day of the start date does not exist in one of the following months due date will be next available calendar day date
    #The interest calculation complies with a simplified version of a 30/360 day count convent
    #
    # ==== Attributes
    # * +start_date+ - Start date to calculate schedule
    # * +duration+ - number of months
    def determine_due_dates(start_date, duration)
      due_dates = [start_date]
      c_date = Date.parse start_date
      duration.times do
        begin
          if c_date.next_month.month == 1
            c_date = Date.parse "#{c_date.next_year.year}-#{c_date.next_month.month}-#{c_date.day}"
          else
            c_date = Date.parse "#{c_date.year}-#{c_date.next_month.month}-#{c_date.day}"
          end
        rescue  Exception => e
          c_date = Date.parse "#{c_date.year}-#{c_date.next_month(2).month}-#{1}"
        end
        due_dates << c_date.to_s
      end
      return due_dates
    end
  end
end

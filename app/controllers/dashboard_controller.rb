class DashboardController < ApplicationController
  include DashboardHelper

  def index

    #@date = params[:start_date] ? 
    #  Date.parse(params[:start_date]).beginning_of_week : 
    #  DateTime.now.beginning_of_week

    @date = get_beginning_of_week(params[:start_date])

    @current_week = @date.strftime("%U").to_i

    @counters = get_counters_by_day(@date, 
                                    @date.end_of_week)

    @hourly_counters = [ 1,2,3]
  end

  def get_counters_by_day(from, to)

    #GgsnCounter.where(calltime: (from..to)).group("DATE(calltime)").sum(:records_in)
    GgsnCounter.find_by_sql(["select date(calltime) as calldate, 
                                     sum(records_in) as sum_records_in,
                                     sum(records_out) as sum_records_out,
                                     sum(malformed_data) as sum_malformed_data,
                                     sum(missing_data) as sum_missing_data,
                                     sum(zero_value) as sum_zero_value,
                                     sum(min_too_low) as sum_min_too_low
                                from ggsn_counters 
                               where calltime BETWEEN ? AND ?
                            group by date(calltime)", from, to+1])
  end
end

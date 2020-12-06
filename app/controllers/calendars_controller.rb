class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday + x
      # wdayメソッドを用いて取得した数値
      # 「+ x」がないと日にちが動かないので、同じ数字が入り続ける。
      if wday_num >= 7 #「wday_numが7以上の場合」という条件式
        wday_num = wday_num -7 # 曜日は0〜6なので、7になると曜日を取り出せない。
      end

      days = { :month => (@todays_date + x).month, :date => @todays_date.day + x, :plans => today_plans, :wday => wdays[wday_num] }
      # :wday => wdays[wday_num]   wdays(曜日)はwday_num(何番目の曜日)なのかをキー(:wday)に渡す。
      @week_days.push(days)
    end

  end
end

module PersianDate
    def pdate_today
        Date.today.to_pdate.strftime("%Y/%m/%d")
    end
end
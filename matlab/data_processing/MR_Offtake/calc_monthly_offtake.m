function data = calc_monthly_offtake(mdata,mdate)

[dd,mm,yyyy] = datevec(mdate);

for i = 1:length(mm)
    
    mdays = eomday(yyyy(i),mm(i));
    
    data(i) = mdata(i) * ((1000*1000)/(86400 * mdays));
    
end
    

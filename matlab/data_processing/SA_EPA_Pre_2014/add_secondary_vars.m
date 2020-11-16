
clear all;
addpath(genpath('Functions'));

load Matfiles\EPA.mat;

epa = add_agency(epa,'EPA');

lowerlakes = epa;


datearray(:,1) = datenum(2008,01:96,01);

load Matfiles\data2.mat

data = add_agency(data,'DEWNR');

sites = fieldnames(data);
for i = 1:length(sites)
    lowerlakes.(sites{i}) = data.(sites{i});
end

clear data;


load Matfiles\dewnr.mat

dewnr = add_agency(dewnr,'DEWNR');

sites = fieldnames(dewnr);
for i = 1:length(sites)
    lowerlakes.(sites{i}) = dewnr.(sites{i});
end
load Matfiles\data.mat

sites = fieldnames(data);
for i = 1:length(sites)
    
    if ~isfield(lowerlakes,sites{i})
    
        lowerlakes.(sites{i}) = data.(sites{i});
    else
        vars = fieldnames(data.(sites{i}));
        for j = 1:length(vars)
            if ~isfield(lowerlakes.(sites{i}),vars{j})
                lowerlakes.(sites{i}).(vars{j}) = data.(sites{i}).(vars{j});
            end
        end
    end
end

load Matfiles\newtide.mat

newtide.VictorHarbor.SAL = newtide.VictorHarbor.H;
newtide.VictorHarbor.SAL.Data(:) = 35;
% 
% newtide.VictorHarbor.WQ_CAR_DIC = newtide.VictorHarbor.H;
% newtide.VictorHarbor.SAL.Data(:) = 35;


sites = fieldnames(newtide);
for i = 1:length(sites)
    lowerlakes.(sites{i}) = newtide.(sites{i});
end

load Matfiles\newflow.mat

%lowerlakes.Wellington = lowerlakes.Lake_Alexandrina_Wellington;
lowerlakes.Wellington.Flow = newflow.Wellington.Flow;

load Matfiles\inflows.mat;


vars = fieldnames(lowerlakes.Wellington);
for i = 1:length(vars)
    lowerlakes.Wellington.(vars{i}).X = lowerlakes.Wellington.Flow.X;
    lowerlakes.Wellington.(vars{i}).Y = lowerlakes.Wellington.Flow.Y;
end

load Matfiles\pumping.mat;


sites = fieldnames(pumping);
for i = 1:length(sites)
    lowerlakes.(sites{i}) = pumping.(sites{i});
end

load Matfiles\pump1.mat;


sites = fieldnames(pump1);
for i = 1:length(sites)
    lowerlakes.(sites{i}) = pump1.(sites{i});
end

% sites = fieldnames(newtide);
% for i = 1:length(sites)
%     lowerlakes.(sites{i}) = newtide.(sites{i});
% end


sites = fieldnames(lowerlakes);

for i = 1:length(sites)
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TN') & isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM') & isfield(lowerlakes.(sites{i}),'WQ_NIT_NIT') & isfield(lowerlakes.(sites{i}),'WQ_OGM_DON')
        disp([sites{i},':  WQ_OGM_PON']);
        
        
        TN = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TN',sites{i},'Surface',datearray);
        Amm = create_interpolated_dataset(lowerlakes,'WQ_NIT_AMM',sites{i},'Surface',datearray);
        Nit = create_interpolated_dataset(lowerlakes,'WQ_NIT_NIT',sites{i},'Surface',datearray);
        DON = create_interpolated_dataset(lowerlakes,'WQ_OGM_DON',sites{i},'Surface',datearray);
        
        
        if ~isempty(TN) & ~isempty(Amm) & ~isempty(Nit) & ~isempty(DON)
            
            lowerlakes.(sites{i}).WQ_OGM_PON = lowerlakes.(sites{i}).WQ_OGM_DON;
            lowerlakes.(sites{i}).WQ_OGM_PON.Data = TN - Amm - Nit - DON;
            
            lowerlakes.(sites{i}).WQ_OGM_PON.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_PON.Depth(1:length(datearray),1) = 0;
            
            clear TN Amm Nit DON;
        end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP')
        
        disp([sites{i},':  WQ_PHS_FRP_ADS']);
        
        
        WQ_PHS_FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        
        
        if ~isempty(WQ_PHS_FRP)
            
            lowerlakes.(sites{i}).WQ_PHS_FRP_ADS = lowerlakes.(sites{i}).WQ_PHS_FRP;
            
            lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Data = WQ_PHS_FRP .* 0.1;
            lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Date = datearray;
            lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Depth(1:length(datearray),1) = 0;
            
            clear WQ_PHS_FRP;
        end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
        
        disp([sites{i},':  WQ_OGM_DOP']);
        
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        
        if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
            
            
            lowerlakes.(sites{i}).WQ_OGM_DOP = lowerlakes.(sites{i}).WQ_PHS_FRP;
            lowerlakes.(sites{i}).WQ_OGM_DOP.Data = (TP-FRP-FRP_ADS).* 0.4;
            
            lowerlakes.(sites{i}).WQ_OGM_DOP.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_DOP.Depth(1:length(datearray),1) = 0;
            
            clear TP FRP FRP_ADS;
        end
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
        
        disp([sites{i},':  WQ_OGM_POP']);
        
        
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
            
            lowerlakes.(sites{i}).WQ_OGM_POP = lowerlakes.(sites{i}).WQ_PHS_FRP;
            lowerlakes.(sites{i}).WQ_OGM_POP.Data = (TP-FRP-FRP_ADS).* 0.5;
            
            lowerlakes.(sites{i}).WQ_OGM_POP.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_POP.Depth(1:length(datearray),1) = 0;
            
            clear TP FRP FRP_ADS;
        end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
        
        disp([sites{i},':  WQ_OGM_POP']);
        
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
            
            lowerlakes.(sites{i}).WQ_OGM_POP = lowerlakes.(sites{i}).WQ_PHS_FRP;
            lowerlakes.(sites{i}).WQ_OGM_POP.Data = (TP-FRP-FRP_ADS).* 0.5;
            
            lowerlakes.(sites{i}).WQ_OGM_POP.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_POP.Depth(1:length(datearray),1) = 0;
            clear TP FRP FRP_ADS;
        end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN') & ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        
        disp([sites{i},':  WQ_PHY_GRN']);
        
        lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA = lowerlakes.(sites{i}).WQ_PHY_GRN;
        lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data = lowerlakes.(sites{i}).WQ_PHY_GRN.Data ./ 4.166667;
        
    end
    if ~isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN') & isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        
        disp([sites{i},':  WQ_DIAG_PHY_TCHLA']);
        
        lowerlakes.(sites{i}).WQ_PHY_GRN = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_GRN.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data .* 4.166667;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TURBIDITY') & ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TSS')
        
        disp([sites{i},':  WQ_DIAG_TOT_TSS']);
        
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TSS = lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        % TURB = 0.43.*TSS + 9.2
        
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TSS.Data = 0.43 .* lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data   +  9.2;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TURBIDITY')
        
        disp([sites{i},':  WQ_TRC_SS1']);
        
        lowerlakes.(sites{i}).WQ_TRC_SS1 = lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        % TURB = 0.43.*TSS + 9.2
        
        lowerlakes.(sites{i}).WQ_TRC_SS1.Data = 0.43 .* lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data   +  9.2;
        
    end
    
    
    
    
    
    
    
    
    
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TKN') & ...
            isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM')
        
        
        % First variable
        Fdate = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN.Date;
        Fdata = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN.Data;
        % Second Variable
        Sdate = lowerlakes.(sites{i}).WQ_NIT_AMM.Date;
        Sdata = lowerlakes.(sites{i}).WQ_NIT_AMM.Data;
        % Third Variable
        
        
        xdate = [min(Fdate):1:max(Fdate)]';
        
        if length(~isnan(Fdata)) > 3
            
            FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
            
            SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
            
            
            
            
            
            temp_val = FIdata - SIdata;
            
            % Set the variable
            lowerlakes.(sites{i}).ON = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN;
            
            lowerlakes.(sites{i}).ON.Data = [];
            lowerlakes.(sites{i}).ON.Depth = [];
            lowerlakes.(sites{i}).ON.Date=[];
            
            for ii = 1:length(Fdate)
                ss = find(floor(xdate) == floor(Fdate(ii)));
                if ~isempty(ss)
                    lowerlakes.(sites{i}).ON.Data(ii,1) = temp_val(ss);
                    lowerlakes.(sites{i}).ON.Date(ii,1) = xdate(ss);
                    lowerlakes.(sites{i}).ON.Depth(ii,1) = 0;
                end
            end
            lowerlakes.(sites{i}).ON.Title = {'Organic Nitrogen'};
        end
        clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & ...
            isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP')
        
        
        % First variable
        Fdate = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP.Date;
        Fdata = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP.Data;
        % Second Variable
        Sdate = lowerlakes.(sites{i}).WQ_PHS_FRP.Date;
        Sdata = lowerlakes.(sites{i}).WQ_PHS_FRP.Data;
        % Third Variable
        
        
        xdate = [min(Fdate):1:max(Fdate)]';
        
        if length(~isnan(Fdata)) > 3
            
            FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
            
            SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
            
            
            
            
            
            temp_val = FIdata - SIdata;
            
            % Set the variable
            lowerlakes.(sites{i}).OP = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP;
            
            lowerlakes.(sites{i}).OP.Data = [];
            lowerlakes.(sites{i}).OP.Depth = [];
            lowerlakes.(sites{i}).OP.Date=[];
            
            for ii = 1:length(Fdate)
                ss = find(floor(xdate) == floor(Fdate(ii)));
                if ~isempty(ss)
                    lowerlakes.(sites{i}).OP.Data(ii,1) = temp_val(ss);
                    lowerlakes.(sites{i}).OP.Date(ii,1) = xdate(ss);
                    lowerlakes.(sites{i}).OP.Depth(ii,1) = 0;
                end
            end
            lowerlakes.(sites{i}).OP.Title = {'Organic Phosphorus'};
        end
        clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'Conductivity')
        
        disp([sites{i},':  SAL']);
        lowerlakes.(sites{i}).SAL = lowerlakes.(sites{i}).Conductivity;
        
        lowerlakes.(sites{i}).SAL.Data = [];
        
        lowerlakes.(sites{i}).SAL.Data = conductivity2salinity(lowerlakes.(sites{i}).Conductivity.Data);
        
        lowerlakes.(sites{i}).SAL.Title = {'Salinity'};
    end
        
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        lowerlakes.(sites{i}).WQ_PHY_BGA = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_BGA.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
        
        lowerlakes.(sites{i}).WQ_PHY_FDIAT = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_FDIAT.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
        
        lowerlakes.(sites{i}).WQ_PHY_MDIAT = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_MDIAT.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0;
 
        lowerlakes.(sites{i}).WQ_PHY_KARLO = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_KARLO.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.1;
        
        
        if ~isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN')
                    lowerlakes.(sites{i}).WQ_PHY_GRN = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
                    lowerlakes.(sites{i}).WQ_PHY_GRN.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
        end
    end
        
end


tdata = lowerlakes;

clear lowerlakes;

sites = fieldnames(tdata);

for i = 1:length(sites)
    vars = fieldnames(tdata.(sites{i}));
    for j = 1:length(vars)
        lowerlakes.(sites{i}).(upper(vars{j})) = tdata.(sites{i}).(vars{j});
    end
end








%cd Matfiles\

save Matfiles\lowerlakes.mat lowerlakes -mat
save('../BC Files/lowerlakes.mat','lowerlakes','-mat');
save('../Plotting/Matfiles/lowerlakes.mat','lowerlakes','-mat');

cd Matfiles\

summerise_data('lowerlakes.mat','lowerlakes/');


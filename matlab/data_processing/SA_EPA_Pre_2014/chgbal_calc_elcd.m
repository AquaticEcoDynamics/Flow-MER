

ELCOM_BC(:,1) = DATA(:,1);  % Date
ELCOM_BC(:,2) = DATA(:,2);  % DO
ELCOM_BC(:,3) = DATA(:,3);  % DOCL
ELCOM_BC(:,4) = DATA(:,25)-DATA(:,3);  % POCL
%ELCOM_BC(:,5) = DATA(:,4).*0.44;  % DIC
ELCOM_BC(:,5) = DATA(:,4);  % DIC
ELCOM_BC(:,6) = DATA(:,5);  % pH
ELCOM_BC(:,7) = max( (DATA(:,6)-DATA(:,8))./2,0);  % PONL
ELCOM_BC(:,8) = max( (DATA(:,6)-DATA(:,8))./2,0);  % DONL
ELCOM_BC(:,9) = DATA(:,8);  % NH4
ELCOM_BC(:,10) = DATA(:,7);  % NO3
ELCOM_BC(:,11) = max( (DATA(:,9)-DATA(:,10))./2,0);  % POPL
ELCOM_BC(:,12) = max( (DATA(:,9)-DATA(:,10))./2,0);  % DOPL
ELCOM_BC(:,13) = DATA(:,10);  % PO4
ELCOM_BC(:,14) = DATA(:,14);  % SiO2
ELCOM_BC(:,15) = 0.8.*DATA(:,13);  % SSOL1
ELCOM_BC(:,16) = 0.2.*DATA(:,13);  % SSOL2
ELCOM_BC(:,17) = 0.0.*DATA(:,13);  % PIP
ELCOM_BC(:,18) = 0.0.*DATA(:,13);  % PIN
ELCOM_BC(:,19) = 0.2*DATA(:,11);  % CYANO
ELCOM_BC(:,20) = 0.6*DATA(:,11);  % CHLOR
ELCOM_BC(:,21) = 0.2*DATA(:,11);  % FDIAT

ELCOM_BC(:,22) = DATA(:,20+1);  % Na
ELCOM_BC(:,23) = DATA(:,19+1);  % Mg
ELCOM_BC(:,24) = DATA(:,22+1);  % K
ELCOM_BC(:,25) = DATA(:,18+1);  % Cl
ELCOM_BC(:,26) = DATA(:,21+1);  % Ca
ELCOM_BC(:,27) = DATA(:,17+1);  % SO4
ELCOM_BC(:,28) = DATA(:,14+1)./(1000*55.3);  % Fe(OH)3
ELCOM_BC(:,29) = DATA(:,16+1);  % Al
ELCOM_BC(:,30) = max( (DATA(:,15+1)-DATA(:,16+1)),0) ./(1000*26.98);  % Al(OH)3

%CHGBAL not needed in init profiles! 
% sumPostives = (ELCOM_BC(:,9)  /14.0)*3/1000 ...
%             + (ELCOM_BC(:,22) /23.0)*1/1000 ...
%             + (ELCOM_BC(:,24) /39.0)*1/1000 ...
%             + (ELCOM_BC(:,23) /24.3)*2/1000 ...
%             + (ELCOM_BC(:,26) /40.1)*2/1000 ...
%             + (ELCOM_BC(:,29) /26.98)*3/1000; 
% 
%             %  + (10^(-ELCOM_BC(:,6)) /1)*1/1000 ...
%             
% sumNegtives = (ELCOM_BC(:,13) /30.9)*3/1000 ... 
%             + (ELCOM_BC(:,10) /14.0)*1/1000 ...
%             + (ELCOM_BC(:,25) /35.5)*1/1000 ...
%             %+ (ELCOM_BC(:,14) /28.1)*1/1000 ... SiO2 uncharged (or as H2SiO4, also uncharged) - doesn't usually
%             %contribute to chbal for pH <9
%             + (ELCOM_BC(:,5)  /12.0)*2/1000 ...
%             + (ELCOM_BC(:,27) /96.0)*2/1000;
%         
%ELCOM_BC(:,31) = sumPostives - sumNegtives; % CHGBAL
ELCOM_BC(:,31) = 0.0; % FeII
ELCOM_BC(:,32) = 0.0; % FeIII
ELCOM_BC(:,33) = 0.0; % IN_CYA
ELCOM_BC(:,34) = 0.0; % IP_CYA
ELCOM_BC(:,35) = 0.0; % IN_FDI
ELCOM_BC(:,36) = 0.0; % IP_FDI
ELCOM_BC(:,37) = 0.0; % IN_CHL
ELCOM_BC(:,38) = 0.0; % IP_CHL
ELCOM_BC(:,39) = DATA(:,24); % PATH2_VI-coliforms
ELCOM_BC(:,40) = 0.0; % PATH2_DD
 
%9-NH4,22-Na,24-K,23-Mg,26-Ca,29-Al(3x)
 sumPostives = (ELCOM_BC(:,22) /23.0)*1/1000 ...
             + (ELCOM_BC(:,24) /39.0)*1/1000 ...
             + (ELCOM_BC(:,23) /24.3)*2/1000 ...
             + (ELCOM_BC(:,26) /40.1)*2/1000; ...
   
%13-PO4,10-NO3,25-Cl,27-SO4,5-DIC
sumNegtives = (ELCOM_BC(:,25) /35.5)*1/1000 ...
             + (ELCOM_BC(:,5)  /12.0)*1/1000 ...
             + (ELCOM_BC(:,27) /96.0)*2/1000;

%new additional column:
ELCOM_BC(:,41) = sumPostives - sumNegtives; % CHGBAL

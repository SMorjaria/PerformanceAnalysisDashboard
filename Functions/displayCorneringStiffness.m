function displayCorneringStiffness( ...
    TyreLoads, Cornering)
%DISPLAYCORNERINGSTIFFNESS
% Display Stage 3.2 cornering stiffness results.

fprintf('\n');
fprintf('============================================\n');
fprintf('      CORNERING STIFFNESS - STAGE 3.2\n');
fprintf('============================================\n');


fprintf('\nINDIVIDUAL TYRES\n');
fprintf('--------------------------------------------\n');

fprintf('       Fz [N]       C_alpha [N/rad]\n');
fprintf('--------------------------------------------\n');

fprintf('FL   %8.1f        %10.1f\n', ...
    TyreLoads.FL, ...
    Cornering.CalphaFL);

fprintf('FR   %8.1f        %10.1f\n', ...
    TyreLoads.FR, ...
    Cornering.CalphaFR);

fprintf('RL   %8.1f        %10.1f\n', ...
    TyreLoads.RL, ...
    Cornering.CalphaRL);

fprintf('RR   %8.1f        %10.1f\n', ...
    TyreLoads.RR, ...
    Cornering.CalphaRR);


fprintf('\nAXLE CORNERING STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle               : %10.1f N/rad\n', ...
    Cornering.CalphaFront);

fprintf('Rear Axle                : %10.1f N/rad\n', ...
    Cornering.CalphaRear);

fprintf('Total                    : %10.1f N/rad\n', ...
    Cornering.CalphaTotal);


fprintf('\nSTIFFNESS DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                    : %8.2f %%\n', ...
    Cornering.frontDistribution * 100);

fprintf('Rear                     : %8.2f %%\n', ...
    Cornering.rearDistribution * 100);

fprintf('============================================\n');

end
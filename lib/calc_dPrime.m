
function [dPrime c] = calc_dPrime(hits, misses, fa, cr)
% [dPrime c] = calc_dPrime;
% JC 03/01/06

if nargin==0
    fprintf('\n');
    fprintf('   |      YES     |       NO\n');
    fprintf('---|--------------|--------------------\n');
    fprintf('S1 |     hits     |    misses\n');
    fprintf('S2 | false-alarms | correct-rejections\n');
    fprintf('\n');
    hits = input('Number of hits: ');
    fa = input('Number of false alarms: ');
    misses = input('Number of misses: ');
    cr = input('Number of correct rejections: ');
end

%correct for FA values of 0
if fa == 0
    farate = 1./(2*cr); %FA = 1/(2*#LURES)
    fprintf('FA rate is 0, replacing with %.4f\n', farate)
elseif cr ==0
    farate = 1 - (1./(2*fa)); 
    fprintf('FA rate is 1, replacing with %.4f\n', farate)
else
    farate = fa/(fa+cr);
end

if misses == 0
    hitrate = 1 - (1./(2*hits));
    fprintf('Hit rate is 1, replacing with %.4f\n', hitrate)
elseif hits ==0
    hitrate = 1./(2*misses); 
    fprintf('Hit rate rate is 0, replacing with %.4f\n', hitrate)
else
    hitrate = hits/(hits+misses);
end

dPrime = norminv(hitrate,0,1) - norminv(farate,0,1);
c = -0.5 * ( norminv(hitrate,0,1) + norminv(farate,0,1));
    
% dPrime = norminv((hits/(hits+misses)),0,1) - norminv((fa/(fa+cr)),0,1);
% c = -0.5 * ( norminv((hits/(hits+misses)),0,1) + norminv((fa/(fa+cr)),0,1) );


if nargin==0
    fprintf('\n');
    fprintf(['dPrime = ' num2str(dPrime) '\n']);
    fprintf(['c = ' num2str(c) '\n']);
end

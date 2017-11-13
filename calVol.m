function [V] = calVol(I)
%Calcula o volume do elipsoide a partir da FIM

[v, l ] = eig(inv(I));
l = diag(l);

% Utilizacao do intervalo de confiaca a 95%
chisquare_val = 2.79553;
a =chisquare_val*sqrt(l(1));
b =chisquare_val*sqrt(l(2));
c =chisquare_val*sqrt(l(3));
V = (4/3)*pi*a*b*c;
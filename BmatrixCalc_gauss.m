function [B] = BmatrixCalc_gauss(Best_pos,sigma,x)

    b12 = -2*Best_pos'/(2*norm(x-Best_pos)*sigma)^2;
    b22 = 4*(Best_pos*Best_pos')/(2*norm(x-Best_pos)*sigma)^2;
    B = [1/(2*norm(x-Best_pos)*sigma)^2 b12; b12' b22];
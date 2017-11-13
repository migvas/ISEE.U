function [z] = calzvecinov(A,Cy,y,n_sens,W,T,Best_pos,x,sigma)

soma = zeros(length(A(1,:)),1,n_sens);
for i=1:n_sens
    for j=1:n_sens
        soma(:,:,i) = soma(:,:,i) + (W(i,j)*(A(j,:)'*inv(Cy(j,j))*y(j)));
    end
end

for d=1:n_sens
    za(:,:,d) = soma(:,:,d);
    w(d,:) = W(d,:)*(1/(sum(W(d,:),2)));
end


for t=1:T
    somam = zeros(length(A(1,:)),1,n_sens);
    soma = zeros(length(A(1,:)),1,n_sens);
    
    for inov=1:n_sens
        ruido = sigma(inov)*randn;
        r(inov) = abs(norm(Best_pos(:,inov)-x) + ruido);
        y(inov) = (r(inov))^2-norm(Best_pos(:,inov))^2;
    end
    
    
    for k=1:n_sens
        for n=1:n_sens
            somam(:,:,k) = somam(:,:,k) + za(:,:,n)*w(k,n);
            soma(:,:,k) = soma(:,:,k) + (W(k,n)*(A(n,:)'*inv(Cy(n,n))*y(n)));
        end        
        z(:,:,k) = ((t/(t+1))*somam(:,:,k)) + ((1/(t+1))*soma(:,:,k));
    end
    za = z;
end
% for j=1:n_sens
%     za(:,:,j) = A(j,:)'*y(j);
% end
%
%
% for t=1:T
%     for k=1:n_sens
%         z(:,:,k) = ((t/(t+1))*sum(za*w,3))+((1/(t+1))*A(k,:)'*inv(Cy(k,k))*y(k));
%     end
%     za = z;
end
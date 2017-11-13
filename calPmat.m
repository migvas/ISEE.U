function [P] = calPmat(A,Cy,n_sens,W,T)

soma = zeros(length(A(1,:)),length(A(1,:)),n_sens);
for i=1:n_sens
    for j=1:n_sens
        soma(:,:,i) = soma(:,:,i) + (W(i,j)*(A(j,:)'*inv(Cy(j,j))*A(j,:)));
    end
end

for d=1:n_sens
    Pa(:,:,d) = soma(:,:,d);
    w(d,:) = W(d,:)*(1/(sum(W(d,:),2)));
end

for t=1:T
    somam = zeros(length(A(1,:)),length(A(1,:)),n_sens);
    for k=1:n_sens
        for n=1:n_sens
            somam(:,:,k) = somam(:,:,k) + Pa(:,:,n)*w(k,n);
        end        
        P(:,:,k) = ((t/(t+1))*somam(:,:,k)) + ((1/(t+1))*soma(:,:,k));
    end
    Pa = P;
end

% for d=1:n_sens
%     Pa(:,:,d) = A(d,:)'*inv(Cy(d,d))*A(d,:);
% end
% 
% for t=1:T
%     for a=1:n_sens
%         P(:,:,a) = ((t/(t+1))*sum(Pa*w,3))+((1/(t+1))*(A(a,:)'*inv(Cy(a,a))*A(a,:)));
%     end
%     Pa = P;
end

function [ Best_pos, target_posMVU ] = ISEE_U(n_sens,S,x,variance,space)
target_posMVU = zeros(2,n_sens);

for i=1:n_sens
    A(i,:) = [1 -2*S(:,i)'];
    sigma(i)= variance*norm(x-S(:,i));   
end

Best_pos = S; %Define um vector que guarda as melhores posiçoes para cada sensor

for d=1:n_sens
    Cy(d,d) = (2*norm(x-S(:,i))*sigma(d))^2;
end

w = zeros(n_sens,n_sens);
k = 1;
while(k <= n_sens)
       
    for h= 1:n_sens
        for m = h:n_sens
            if norm(Best_pos(:,h)-S(:,m)) <0.7*norm(space)
                w(h,m) = 1;
                w(m,h) = 1;%Matriz usada nos consensu
%Em cada linha o 1 significa que os nos estao conectados
            end
        end
    end

   
    
    %Calcula a matriz de Fischer e calcula o maior vp
    %Pa = P;
    P = calPmat(A,Cy,n_sens,w,20);

    I = P(:,:,k);
    volume = calVol(I);
%     I2 = (A'*inv(Cy)*A);
%     volume2 = calVol(I2);
%     err_vol(t) = volume - volume2;

    B = BmatrixCalc_gauss(Best_pos(:,k),sigma(k),x);
    Bt = I-B;
    
    %Ciclo entre as 8 posiçoes em volta de cada sensor
    for i=round(Best_pos(1,k))-1:round(Best_pos(1,k))+1
        for j=round(Best_pos(2,k))-1:round(Best_pos(2,k))+1
            
            %Variaveis utilizadas para teste
            test_1 = 1;
            test_2 = 1;
             
            %Testa se a posiçao em causa estao fora do espaço considerado
            if i < 0 ||  i > space
                test_1 = 0;
            end
            
            if j < 0 ||  j > space
                test_2 = 0;
            end
            
            %Testa se a posiçao considerada ja esta ocupada por outro
            %sensor ou o targer
            Best_pos_test = [round(Best_pos) x];
            test = ismember(Best_pos_test',[i j],'rows');
            
            if any(test) == 0  && test_1 == 1 && test_2 == 1    
                %Cria variaveis auxiliares na nova posicao
                Aux = [i;j];
                aux_sigma = variance*norm(x-Aux);

                Bs = BmatrixCalc_gauss(Aux,aux_sigma,x);
                
                %teste = round(det(Bs+Bt));
                if aux_sigma ~= 0 %&& teste ~= 0
                    %Calcula a nova matriz de Fischer e compara os maiores
                    %vp's
                    Is = (Bt+Bs);
                    volume_tst = calVol(Is);
                    
                    if volume_tst < volume
                        %Se o volume for menor do que o anteriormente
                        %considerado move o sensor para essa posiçao
                        Best_pos(:,k) = Aux;
                        sigma(k) = aux_sigma;
                        A(k,:) = [1 -2*Best_pos(:,k)'];
                        I = Is;
                        volume = volume_tst;

                        B = BmatrixCalc_gauss(Best_pos(:,k),sigma(k),x);
                        Bt = I-B;
                        Cy(k,k) = (2*norm(x-Best_pos(:,k))*sigma(k))^2;                
                    end
                end
            end
        end
    end
    
    for h=1:n_sens
        ruido = sigma(h)*randn;
        r(h) = abs(norm(Best_pos(:,h)-x)+ruido);
        y(h) = (r(h))^2-norm(Best_pos(:,h))^2;
    end
    
    
    z = calzvecinov(A,Cy,y,n_sens,w,20,Best_pos,x,sigma);
    
    i_pos = inv(I)*z(:,:,k);
    target_posMVU(:,k) = i_pos(2:length(x)+1,:);
    
    k = k+1;
end
clear all;
load("proj_fit_24.mat");
n1=length(id.X{1});
idx1=id.X{1};
idx2=id.X{2};
valx1=val.X{1};
valx2=val.X{2};
idY=id.Y;
valY=val.Y;
degree=15;

mseid_array=zeros(degree, 1);  % initializam o matrice pentru mse-urile de identificare
mseval_array=zeros(degree, 1);  % initializam o matrice pentru mse-urile de validare
idYhat=[];    %initializam  vectorul pentru valorile aproximate pentru datele de identificare
valYhat=[];     % initializam  vectorul pentru valorile aproximate pentru datele de validare

currentdegree=1;    % initializam gradul polinomului la 1
idY=reshape(idY, [], 1);    % transformam idY intr un vector coloana
valY=reshape(valY,[],1);

idPHI=cell(degree, 1);
valPHI=cell(degree, 1);
theta_id=cell(degree, 1);

for currentdegree=1:degree
  idPHI{currentdegree}=[];  % Initialize the matrix
  for i=1:n1
   line=[];
   for j=1:n1
   aux=currentdegree;  % Setting an aux variable for the current degree
    for index=aux:-1:0  %generates all possible
     for k=0:index
    line=[line;idx1(i)^k*idx2(j)^(index-k)];  
    end
    end
    end
       idPHI{currentdegree}=[idPHI{currentdegree}; line];
    end
    % Calculate the number of coeficients for reshaping
    totalcoeffs=((currentdegree+1)*(currentdegree+2))/2;
    idPHI{currentdegree}=reshape(idPHI{currentdegree}, totalcoeffs, []);
    idPHI{currentdegree}=idPHI{currentdegree}';
    
    % calculeaza tetha 
    theta_id{currentdegree}=idPHI{currentdegree}\idY; 
    
    % calculeaza idYhat
    idYhat=idPHI{currentdegree}*theta_id{currentdegree};
   
    % mse optim  la degree 14 
    
    idYhat=reshape(idYhat, n1, n1);

    %plotam cu surf , frumos elegant xD
    %figure;
    %surf(idx1, idx2, idYhat);
    %title(['3D plot for identification yhat, degree ', num2str(currentdegree)]);
    %xlabel('X1');
    %ylabel('X2');
    %zlabel('Y');
    %colorbar;

    %figure;
    %surf(idx1,idx2,id.Y);
    %title(['3D plot for identification y, degree ', num2str(currentdegree)]);
    %xlabel('X1');
    %ylabel('X2');
    %zlabel('Y');
    %colorbar;



   mse_idsum=0;        % initializam suma mse-urilor cu 0
    for u=1:41
        mse_idsum=mse_idsum+(id.Y(u)-idYhat(u)).^2;                %adaugam fiecare mse la suma de mseuri
    end
    mseid_array(currentdegree)=mse_idsum/41;                            % facem media de mseuri
    disp(['ID degree: ', num2str(currentdegree), ', MSE: ', num2str(mseid_array(currentdegree))]);
 end



 for currentdegree=1:degree
    valPHI{currentdegree}=[];
  for i=1:31
   line=[];
  for j=1:31
    aux=currentdegree;  % setam un aux variable ptr gradu curent
    for index=aux:-1:0
        for k=0:index
       line=[line; valx1(i)^k*valx2(j)^(index-k)];
       end
        end
     end
        valPHI{currentdegree}=[valPHI{currentdegree}; line];
    end
    % calculate the number of coefficients for reshaping the PHI matrix
    % with the correct dimensions
    totalcoeffs=((currentdegree+1)*(currentdegree+2))/2;
    valPHI{currentdegree}=reshape(valPHI{currentdegree}, totalcoeffs, []);
    valPHI{currentdegree}=valPHI{currentdegree}';
    
    % calculate valYhat using the same theta as idPHI
    valYhat=valPHI{currentdegree}*theta_id{currentdegree};
    
     % mse optim la val e 15
     %val output
    valY=reshape(valY, 31, 31);
    figure;
    surf(valx1,valx2,valY);
    title(['3D plot for validation y, degree ', num2str(currentdegree)]);
    xlabel('X1');
    ylabel('X2');
    zlabel('Y');
    colorbar;

     %plotu aproximat
    valYhat=reshape(valYhat, 31, 31);
    figure;
    surf(valx1, valx2, valYhat);
    title(['3D plot for validation yhat, degree ', num2str(currentdegree)]);
    xlabel('X1');
    ylabel('X2');
    zlabel('Y');
    colorbar;

  mse_valsum=0;             % initializam vectorul de mse-uri
    for u=1:31
      mse_valsum=mse_valsum+(val.Y(u)-valYhat(u)).^2;   %adaugam fiecare mse la suma de mseuri
    end
    mseval_array(currentdegree)=mse_valsum/31;                  % facem media de mseuri
    disp(['VAL degree: ', num2str(currentdegree), ', MSE: ', num2str(mseval_array(currentdegree))]);
 end

figure;                                             % plot la mse_id vs mse_val pentru fiecare degree
plot(1:degree,mseid_array, 'x-','DisplayName','ID Data');
hold on;
plot(1:degree,mseval_array,'o-','DisplayName','VAL Data');
hold off;
xlabel('Degree');
ylabel('MSE');
title('Degree vs Mean MSE for ID and VAL Data');
legend('show');


















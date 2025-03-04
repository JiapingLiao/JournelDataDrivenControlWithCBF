function [xData,uData]=computeVerticesData(Xf,Pu,Px,C,P,U0,X0,Z0,X1,c3,gamma0,beta0,beta1,Ak,Bk,zk,rk,Count,constraintFlag)
    numVertices=size(Xf.V,1);
    [xData,uData,VXf]=deal(cell(1,numVertices),cell(1,numVertices),Xf.V');

    parpool
        parfor m=1:numVertices
            [Xf0,Pu0,Px0,C0,P0,U00,X00,Z00,X10,c30,gamma00,beta00,beta10,zk0,rk0,constraintFlag0]=deal(Xf,Pu,Px,C,P,U0,X0,Z0,X1,c3,gamma0,beta0,beta1,zk,rk,constraintFlag);
            [U,X]=deal(zeros(size(U0,1),Count),zeros(size(X0,1),Count+1));
            X(:,1)=VXf(:,m);
    
            for i=1:Count
                U(:,i)=ControlAlgorithm1(Xf0,Pu0,Px0,C0,P0,U00,X00,Z00,X10,c30,gamma00,beta00,beta10,X(:,i),zk0,rk0,constraintFlag0);
                X(:,i+1)=Ak*X(:,i)+Bk*[U(:,i);zk];
            end
    
            fprintf('Iteration:%d\n',m);
            [xData{m},uData{m}]=deal(X,U);
        end
    delete(gcp);
end
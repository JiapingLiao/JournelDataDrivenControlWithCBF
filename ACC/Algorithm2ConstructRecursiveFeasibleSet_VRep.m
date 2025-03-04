function [Xf,XSet]=Algorithm2ConstructRecursiveFeasibleSet_VRep(U0,X0,Z0,X1,Pu,Px,Pz)
        [Pu,Px,Pz]=deal(SupplementR(Pu),SupplementR(Px),SupplementR(Pz));
    %%%%Algorithm 2 Construct Recursive Feasible Set    
        XSet={};
    %Solver setup
            mptopt('lpsolver', 'mosek','qpsolver', 'mosek');  
        %Step 1: Input.
            %Dimensions and Other Matrices
            [t,nu,nx,nz]=deal(size(U0,2),size(U0,1),size(X0,1),size(Z0,1));
        %Step 2: Initialization.
                pUXZ1=pinv([U0;X0;Z0;ones(1,t)]);
            %Set the initial candidate set:
                Xi=Px;
            %Compute:
                Pgu=Polyhedron('V',(pUXZ1*[Pu.V';zeros(nx+nz+1,size(Pu.V,1))])','R',(pUXZ1*[Pu.R';zeros(nx+nz+1,size(Pu.R,1))])');
                Pgxi=Polyhedron('V',(pUXZ1*[zeros(nu,size(Px.V,1));Px.V';zeros(nz+1,size(Px.V,1))])','R',(pUXZ1*[zeros(nu,size(Px.R,1));Px.R';zeros(nz+1,size(Px.R,1))])');
                Pgz=Polyhedron('V',(pUXZ1*[zeros(nu+nx,size(Pz.V,1));Pz.V';ones(1,size(Pz.V,1))])','R',(pUXZ1*[zeros(nu+nx,size(Pz.R,1));Pz.R';zeros(1,size(Pz.R,1))])');

                iTu=Polyhedron('V',-Pgu.V*X1','R',-Pgu.R*X1');
                Tz=Polyhedron('V',Pgz.V*X1','R',Pgz.R*X1');
                Txi=Polyhedron('V',Pgxi.V*X1','R',Pgxi.R*X1');
            %Set
                Pi=Polyhedron('V',kron(Txi.V,ones(size(Tz.V,1),1))+repmat(Tz.V,size(Txi.V,1),1),'R',([Txi.R;Tz.R]));i=0;
                Pm=Polyhedron('V',kron(Xi.V,ones(size(iTu.V,1),1))+repmat(iTu.V,size(Xi.V,1),1),'R',([Xi.R;iTu.R]));
       %Step 3: Iterative Refinement.
            while ~(Pm>=Pi)
                    %Pi=Pm&Pi;
                    Pi=minHRep(normalize(Polyhedron([Pi.A;Pm.A],[Pi.b;Pm.b])));
                    %Txi=Pi-Tz
                        options=sdpsettings('solver','mosek','verbose',0);
                        rho=zeros(size(Pi.A,1),1);
                        [nv,nr]=deal(size(Tz.V,1),size(Tz.R,1));
                        lambda=sdpvar(nv+nr,1);
                        for j=1:size(Pi.A,1)
                            Constr=[sum(lambda(1:nv))==1,lambda(:)>=0];
                            optimize(Constr,-Pi.A(j,:)*[Tz.V',Tz.R']*lambda,options);
                            rho(j)=value(Pi.A(j,:)*[Tz.V',Tz.R']*lambda);
                        end
                        Txi=minVRep(minHRep(normalize(Polyhedron(Pi.A,Pi.b-rho))));
                    %
                    Pgxi=Polyhedron('A',Txi.A*X1,'b',Txi.b,'Ae',Txi.Ae,'be',Txi.be)&Pgxi;
                    Xi=minVRep(Polyhedron('V',Pgxi.V*X0','R',Pgxi.R*X0'));

                    Pm=Polyhedron('V',kron(Xi.V,ones(size(iTu.V,1),1))+repmat(iTu.V,size(Xi.V,1),1),'R',([Xi.R;iTu.R]));

                %Increment
                    i=i+1;
                    XSet=[XSet,Xi];
                    display(['Iteration:', int2str(i)]); 
                    
                    if i>=50
                        break;
                    end
            end
       %Step 4: Output
            Xf=computeVRep(Xi)
end

%%
function P=SupplementR(P)
    R_correct=P.R';
    for i=1:size(P.R',2),if -P.A*R_correct(:,i)<=0,R_correct=[R_correct,-R_correct(:,i)];end;end
    P=Polyhedron('V',P.V,'R',R_correct');
end
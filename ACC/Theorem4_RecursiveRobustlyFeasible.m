function Theorem4_RecursiveRobustlyFeasible(varargin)
    % U0,X0,Z0,X1,Pu,Xfzc,Omega
        if nargin==7,varargin{nargin+1}=0;elseif nargin~=8,error('Input incompatibility!');end
        [U0,X0,Z0,X1,Pu,Xf,Pz,Omega]=deal(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},normalize(varargin{6}),varargin{7},varargin{8});
    % Convenient to code
        [nu,nx,nz,t]=deal(size(U0,1),size(X0,1),size(Z0,1),size(X1,2));
%%
    options=sdpsettings('verbose',0,'solver','mosek');
        pUXZ1=pinv([U0;X0;Z0;ones(1,t)]);
        Pgx=Polyhedron('V',(pUXZ1*[zeros(nu,size(Xf.V,1));Xf.V';zeros(nz+1,size(Xf.V,1))])','R',((pUXZ1*[zeros(nu,size(Xf.R,1));Xf.R';zeros(nz+1,size(Xf.R,1))])'));
        Pgz=Polyhedron('V',(pUXZ1*[zeros(nu+nx,size(Pz.V,1));Pz.V';ones(1,size(Pz.V,1))])','R',((pUXZ1*[zeros(nu+nx,size(Pz.R,1));Pz.R';zeros(1,size(Pz.R,1))])'));

        Pgxz=Pgx+Pgz;
    % Verify Vertexes
        [gu,rho]=deal(sdpvar(t,1),sdpvar(size(Xf.A,1),1));
            for j=1:size(Pgxz.V,1)
                Constr=[];
                %Make sure it's point-wise
                temp=Xf.A*X1*(gu+Pgxz.V(j,:)')+Omega*rho<=(Xf.b);Constr=Constr+temp;
                temp=[Pu.A*U0*gu<=Pu.b;[X0;Z0;ones(1,t)]*gu==zeros(nx+nz+1,1)];Constr=Constr+temp;
                for i=1:size(Xf.A,1)
                temp=[rho(i)*eye(t),(gu+Pgxz.V(j,:)')*Xf.A(i,:);((gu+Pgxz.V(j,:)')*Xf.A(i,:))',rho(i)*eye(nx)]>=0;Constr=Constr+temp;
                end
                sol=optimize(Constr,[],options);
                ['vgxz',int2str(j),':',sol.info]
            end
    % Verify Rays
        Rgxz=Pgxz.R./vecnorm(Pgxz.R,2,2)/norm(X1,'fro');
        
        [rho]=deal(sdpvar(size(Xf.A,1),1));

            for j=1:size(Pgxz.R,1)
                Constr=[];
                %Make sure it's point-wise
                margin=1e-3;
                temp=Xf.A*X1*Rgxz(j,:)'+Omega*rho<=margin;Constr=Constr+temp;
                for i=1:size(Xf.A,1)
                    temp=[rho(i)*eye(size(Rgxz,2)),Rgxz(j,:)'*Xf.A(i,:);(Rgxz(j,:)'*Xf.A(i,:))',rho(i)*eye(nx)]>=0;Constr=Constr+temp;
                end
                sol=optimize(Constr,[],options);
                
                ['rgxz',int2str(j),':',sol.info]
            end
end
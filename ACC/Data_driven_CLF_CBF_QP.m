function Data_driven_CLF_CBF_QP(block)
    % Setup S-Function
    setup(block);
    
    function setup(block)
        % Register number of inputs and outputs
        block.NumInputPorts  = 3;  % 1 input (simResults1(:, i))
        block.InputPort(1).DirectFeedthrough =1;

        block.NumOutputPorts = 1;  % 1 output (uk)
        
        Params=block.DialogPrm(1).Data;
        [U0,X0,Z0,T]=deal(Params{1},Params{2},Params{3},Params{8});
        [nu,nx,nz]=deal(size(U0,1),size(X0,1),size(Z0,1));

        % Set input and output port dimensions
        block.InputPort(1).Dimensions = [nx, 1];  % xk size
        block.InputPort(2).Dimensions = [nz, 1];  % xk size
        block.InputPort(3).Dimensions = [1, 1];  % xk size
        block.OutputPort(1).Dimensions = [nu, 1];  % uk size
        block.NumDialogPrms = 1;

        % Register sample times
        block.SampleTimes = [T 0];  % Adjust based on your simulation time step

        % Set block properties
        block.SimStateCompliance = 'DefaultSimState';

        %% Register methods
        block.RegBlockMethod('Outputs',@mdlOutputs);  
    end

    function mdlOutputs(block)
        % Inputs: 
            xk = block.InputPort(1).Data;
            zk = block.InputPort(2).Data;
            rk = block.InputPort(3).Data;
        % DialogPrm
            Params = block.DialogPrm(1).Data;
            [U0,X0,Z0,X1,Xf,Pu,Px,Omega]=deal(Params{1},Params{2},Params{3},Params{4},Params{5},Params{6},Params{7},Params{8});
            [C,c3,gamma0,varepsilon0]=deal(Params{10},Params{11},Params{12},Params{13});
            [beta0,beta1,beta2]=deal(Params{14},Params{15},Params{16});

            P=C'*C;
            Psi=Omega^2*norm(P,'fro');
            flag=Params{end};
        % Output    
        block.OutputPort(1).Data=ControlAlgorithm2(xk,zk,rk,U0,X0,Z0,X1,Xf,Pu,Px,Omega,c3,gamma0,varepsilon0,beta0,beta1,beta2,flag,C,P,Psi);
    end
end

function uk=ControlAlgorithm2(xk,zk,rk,U0,X0,Z0,X1,Xf,Pu,Px,Omega,c3,gamma0,varepsilon0,beta0,beta1,beta2,flag,C,P,Psi)
        %Dimensions
            [nu,t]=deal(size(U0,1),size(U0,2));
        %Decision variable
            [delta0,delta1,delta2]=deal(sdpvar,sdpvar,sdpvar);
            [uk,gk,pk,Wp,Wg]=deal(sdpvar(nu,1),sdpvar(t,1),sdpvar(t,1),sdpvar(t),sdpvar(t));
            [rho1,rho2,rho3,rho4,rho5,rho6,rho7,rho8]=deal(sdpvar,sdpvar,sdpvar,sdpvar,sdpvar,sdpvar,sdpvar(size(Xf.A,1),1),sdpvar(size(Px.A,1),1));
        
        if ~flag(1),Omega=0;Psi=0;end
        if ~flag(3),varepsilon0=0;delta2=0;end

            Constr=[];
        %(a) Constraints for Cost function
            J0=trace(X1'*P*X1*Wp)-2*rk'*C*X1*pk+rk'*rk;
            J=J0+2*Omega*(rho1+rho2)+Psi*rho3+beta0*delta0^2+beta1*delta1^2+beta2*delta2^2;
            temp=[rho1*eye(t),(P*X1*Wp)';P*X1*Wp,rho1*eye(size(P))]>=0;Constr=Constr+temp;
            temp=[rho2*eye(t),(C'*rk*pk')';C'*rk*pk',rho2*eye(size(P))]>=0;Constr=Constr+temp;
            temp=[rho3*eye(t),Wp';Wp,rho3*eye(t)]>=0;Constr=Constr+temp;
            temp=[Wp,pk;pk',1]>=0;Constr=Constr+temp;
        %(b) Constraints for CLF
            V0=trace(X1'*P*X1*Wg)-2*rk'*C*X1*gk+rk'*rk;
            temp=V0+2*Omega*(rho4+rho5)+Psi*rho6-(1-c3)*(C*xk-rk)'*(C*xk-rk)<=delta0;Constr=Constr+temp;
            temp=[rho4*eye(t),(P*X1*Wg)';P*X1*Wg,rho4*eye(size(P))]>=0;Constr=Constr+temp;
            temp=[rho5*eye(t),(C'*rk*gk')';C'*rk*gk',rho5*eye(size(P))]>=0;Constr=Constr+temp;
            temp=[rho6*eye(t),Wg';Wg,rho6*eye(t)]>=0;Constr=Constr+temp;
            temp=[Wg,gk;gk',1]>=0;Constr=Constr+temp;
            
        %(c) Constraints for CBF
            temp=-Px.A*X1*gk+Px.b-Omega*rho8>=(1-gamma0+delta1)*(-Px.A*xk+Px.b)+(varepsilon0+delta2);Constr=Constr+temp;
            temp=[delta1>=gamma0-1,delta1<=gamma0];Constr=Constr+temp;
            for i=1:size(Px.A,1),temp=[rho8(i)*eye(t),(Px.A(i,:)'*gk')';Px.A(i,:)'*gk',rho8(i)*eye(size(P))]>=0;Constr=Constr+temp;end
            if flag(3),temp=delta2>=-varepsilon0;Constr=Constr+temp;end
        %(d) Constraints for Recursive Feasibility
            if flag(2)
                temp=Xf.A*X1*gk+Omega*rho7<=Xf.b;Constr=Constr+temp;
                for i=1:size(Xf.A,1)
                    temp=[rho7(i)*eye(t),(Xf.A(i,:)'*gk')';Xf.A(i,:)'*gk',rho7(i)*eye(size(P))]>=0;Constr=Constr+temp;
                end
            end
        %(d) Constraints for control input
            temp=Pu.A*uk<=Pu.b;Constr=Constr+temp;
        %(e) Constraints for Data-driven description
            temp=[U0;X0;Z0;ones(1,t)]*gk==[uk;xk;zk;1];Constr=Constr+temp;
            temp=[U0;C*X0;Z0;ones(1,t)]*pk==[uk;rk;zk;1];Constr=Constr+temp;
        %% 
            options=sdpsettings('solver','mosek','verbose',0);
            % options.mosek.MSK_DPAR_INTPNT_CO_TOL_NEAR_REL=1e8; 
        %Solve control law
            sol=optimize(Constr,J,options);
            if strfind(sol.info,'infea')
                sol.info
            end
        uk=value(uk);
end
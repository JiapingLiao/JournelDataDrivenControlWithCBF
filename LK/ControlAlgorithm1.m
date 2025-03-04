function uk=ControlAlgorithm1(Xf,Pu,Px,C,P,U0,X0,Z0,X1,c3,gamma0,beta0,beta1,xk,zk,rk,flag)
        % Dimension
            [nu,t]=deal(size(U0,1),size(U0,2));
        % Decision variable
            [delta0,delta1,pk,gk,Wp,Wg,uk]=deal(sdpvar,sdpvar,sdpvar(t,1),sdpvar(t,1),sdpvar(t),sdpvar(t),sdpvar(nu,1));

            Constr=[];
        % (a) Constraints for Cost function
            J0=trace(X1'*P*X1*Wp)-2*rk'*C*X1*pk+rk'*rk;
            temp=[Wp,pk;pk',1]>=0;Constr=Constr+temp;
        % % (b) Constraints for CLF
            V0=trace(X1'*P*X1*Wg)-2*rk'*C*X1*gk+rk'*rk;
            temp=V0-(1-c3)*(C*xk-rk)'*(C*xk-rk)<=delta0;Constr=Constr+temp;
            temp=[Wg,gk;gk',1]>=0;Constr=Constr+temp;

        % % (c) Constraints for CBF
            temp=-Px.A*X1*gk+Px.b>=(1-gamma0+delta1)*(-Px.A*xk+Px.b);Constr=Constr+temp;
            temp=[delta1>=gamma0-1,delta1<=gamma0];Constr=Constr+temp;
        % (d) Constraints for Recursive Feasibility,
            if flag
                temp=Xf.A*X1*gk<=Xf.b;Constr=Constr+temp;
                temp=Xf.Ae*X1*gk==Xf.be;Constr=Constr+temp;
            end
        % (e) Constraints for control input
            temp=Pu.A*uk<=Pu.b;Constr=Constr+temp;
        % (f) Constraints for Data-driven description
            temp=[U0;X0;Z0;ones(1,t)]*gk==[uk;xk;zk;1];Constr=Constr+temp;
            temp=[U0;C*X0;Z0;ones(1,t)]*pk==[uk;rk;zk;1];Constr=Constr+temp;

        J=J0+beta0*delta0^2+beta1*delta1^2; 
        %% 
            options=sdpsettings('solver','mosek','verbose',0);
            % options.mosek.MSK_DPAR_ANA_SOL_INFEAS_TOL=1e2;
        % Solve control law
            sol=optimize(Constr,J,options);
            if contains(sol.info,'infea')||contains(sol.info,'Unbounded')
                sol.info
            end
        uk=value(uk);
end

function Xf=Algorithm2ConstructRecursiveFeasibleSet(U0,X0,Z0,X1,Pu,Px,Pz)
    %%%%Algorithm 2 Construct Recursive Feasible Set    
    %Solver setup
            mptopt('lpsolver', 'mosek','qpsolver', 'mosek');  
        %Step 1: Input.
            %Dimensions and Other Matrices
            [t,nu,nx,nz]=deal(size(U0,2),size(U0,1),size(X0,1),size(Z0,1));
        %Step 2: Initialization.

            %Set the initial candidate set:
                Xi=Px;
            %Compute:
                Pgu=Polyhedron('A',Pu.A*U0,'b',Pu.b,'Ae',[X0;Z0;ones(1,t)],'be',zeros(nx+nz+1,1));
                Pgz=Polyhedron('A',Pz.A*Z0,'b',Pz.b,'Ae',[U0;X0;ones(1,t)],'be',[zeros(nu+nx,1);1]);
                Pgxi=Polyhedron('A',Px.A*X0,'b',Px.b,'Ae',[U0;Z0;ones(1,t)],'be',zeros(nu+nz+1,1));
        
                iTu=Pgu.affineMap(-X1);
                Tz=Pgz.affineMap(X1);
                Txi=Pgxi.affineMap(X1);
            %Set
                Pi=Txi+Tz;i=0;
       %Step 3: Iterative Refinement.
            while ~(Xi+iTu>=Pi)
                    Pi=minHRep(normalize(Pi&(Xi+iTu)));
                    Txi=minHRep(normalize(Pi-Tz));
                    Pgxi=minHRep(normalize(Polyhedron(Txi.A*X1,Txi.b)&Pgxi));
                    Xi=minHRep(normalize(X0*Pgxi));
                %Increment
                    i=i+1;
                    display(['Iteration:', int2str(i)]); 
            end
       %Step 4: Output
            Xf=computeVRep(Xi);
end